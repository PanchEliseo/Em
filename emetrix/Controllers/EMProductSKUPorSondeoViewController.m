//
//  EMProductSKUPorSondeoViewController.m
//  emetrix
//
//  Created by Carlos molina on 24/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMProductSKUPorSondeoViewController.h"
#import "EMCellProduct.h"
#import "NZAlertView.h"
#import "EMSondeoViewController.h"
#import "UIViewController+STViewControllerExtension.h"

@interface EMProductSKUPorSondeoViewController(){
    NSString * textFilter;
    int isCapturadosSelected;
    NSArray * arrayPicker;
    NSInteger enteroPicker;
}
@property (strong, nonatomic) NSMutableArray * arrayProductos;
@property (strong, nonatomic) UIAlertView * alertProductConfirm;
@property (strong, nonatomic) UIAlertView * alertWithOutProduct;
@property (strong, nonatomic) NSString * skuCaptured;

@end

@implementation EMProductSKUPorSondeoViewController

typedef enum
{
    EMAlertViewSelectProductConfirm = 1,
    EMAlertViewSelectProductExit
    
} EMAlertView;

- (NSMutableArray *) arrayProductos:(NSString *)valor
{
    if(self.segment.selectedSegmentIndex == 0)
    {
        isCapturadosSelected = 0;
    }
    else
    {
        isCapturadosSelected = 1;
    }
    // se obtiene el primer valor del picker por el que estaran filtrados por defecto
    NSLog(@"el valor del picker %@", [arrayPicker objectAtIndex:[self.pickerFiltro selectedRowInComponent:0]]);
    _arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductosForCaptura:isCapturadosSelected valor:valor idSondeo:[NSString stringWithFormat:@"%@", self.sondeo.idSondeo] tipo:[arrayPicker objectAtIndex:[self.pickerFiltro selectedRowInComponent:enteroPicker]] tienda:nil];
    if([_arrayProductos count] == 0){
        _arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductosForCaptura:isCapturadosSelected valor:valor idSondeo:@"" tipo:[arrayPicker objectAtIndex:[self.pickerFiltro selectedRowInComponent:enteroPicker]] tienda:self.tienda];
        if([_arrayProductos count] == 0){
            _arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductos:isCapturadosSelected valor:valor tipo:[arrayPicker objectAtIndex:[self.pickerFiltro selectedRowInComponent:enteroPicker]]];
        }
    }
    return _arrayProductos;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self.segment addTarget:self
                  action:@selector(segmentControlAction:)
                  forControlEvents:UIControlEventValueChanged];
    textFilter = @"";
    NSLog(@"el id de sonde %@", self.sondeo.idSondeo);
    arrayPicker = [[NSArray alloc]initWithObjects:@"Cadena", @"Marca", nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = @"Producto";
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [self arrayProductos:@""];
    [self.tableView reloadData];
    if(self.arrayProductos.count)
    {
        self.productSelected = [self.arrayProductos objectAtIndex:0];
    }
}

#pragma mark - UIViewDataSource
//se colocan el numero de celdas en la tabla
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayProductos count];
}

//se llena las celdas de la tabla
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///Reutiliza la celda si existe
    EMCellProduct *cell = [tableView dequeueReusableCellWithIdentifier:@"EMCellProduct"];
    
    ///Crea la celda si no existe
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EMCellProduct" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    EMProducto * producto = [self.arrayProductos objectAtIndex:indexPath.row];
    EMMarca * marca = [[producto.emMarcas allObjects] objectAtIndex:0];
    EMCategoria * categoria = [[producto.emCategoria allObjects] objectAtIndex:0];
    cell.lbfNameProduct.text = producto.nombre;
    cell.lbfSKU.text = [NSString stringWithFormat:@"SKU: %@",producto.sku];
    cell.lbfMarkAnsCategory.text = [NSString stringWithFormat:@"Marca: %@ - Categoria: %@",marca.nombre,categoria.nombre];
    cell.imagenProducto.image = [UIImage imageNamed:@"icon_product.png"];
    cell.imagenEstatus.image = [UIImage imageNamed:@"icon_product.png"];
    EMProducto * prod = [self.arrayProductos objectAtIndex:indexPath.row];
    if([prod.emTiendas count] > 0){
        EMTienda * tienda = [[prod.emTiendas allObjects] objectAtIndex:0];
        NSLog(@"el id de la tienda %@", tienda.idTienda);
    }
    
    return cell;
}

- (void)segmentControlAction:(UISegmentedControl *)segment{
    if(segment.selectedSegmentIndex == 0){
        NSLog(@"el texto filtrado %@", textFilter);
        [self arrayProductos:textFilter];
        [self.tableView reloadData];
    }else{
        [self arrayProductos:textFilter];
        [self.tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.productSelected = [self.arrayProductos objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    [self didPressAceptar];
}

- (IBAction)accionCancelar:(id)sender {
    
    //NSMutableArray *array = [[EMManagedObject sharedInstance] mutableArrayProductosForCaptura:0 valor:@"" idSondeo:[NSString stringWithFormat:@"%@", self.sondeo.idSondeo] tipo:@"" tienda:nil];
    NSLog(@"cuantos trae %lu", (unsigned long)[self.arrayProductos count]);
    BOOL existeSondeoObligatorioSinResponder = NO;
    
    if([self.arrayProductos count] == 0){
        existeSondeoObligatorioSinResponder = YES;
    }
    
    if (existeSondeoObligatorioSinResponder)
        [self dismissViewControllerAnimated:YES completion:nil];
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:[NSString stringWithFormat:@"Existen productos sin contestar"]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: @"ACEPTAR", @"SALIR", nil];
        alert.tag = 2;
        [alert show];
    }
}

#pragma -mark UISerchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    textFilter = searchText;
    NSLog(@"al buscar %@", textFilter);
    [self arrayProductos:textFilter];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    textFilter = @"";
    [self arrayProductos:textFilter];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self arrayProductos:textFilter];
    [self.tableView reloadData];
    
}

#pragma -mark EMProductSKUTableViewCellDelegate
- (void)didPressAceptar
{
    if(self.productSelected)
    {
        if (!self.alertProductConfirm.isVisible)
        {
            NSString * message = [NSString stringWithFormat:@"¿El producto que seleccionarás es: %@?",self.productSelected.nombre];
            self.alertProductConfirm = [[UIAlertView alloc] initWithTitle:@"¡Advertencia!" message:message delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Seleccionar", nil];
            self.alertProductConfirm.tag = EMAlertViewSelectProductConfirm;
            [self.alertProductConfirm show];
        }
        
    }
    
}

- (IBAction)pressScanner:(id)sender {
    [self performSegueWithIdentifier:kEMSegueScanCodeIdentifier sender:self];
}

#pragma -mark UISegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kEMSegueScanCodeIdentifier])
    {
        ((EMScanCodeViewController *)[((UINavigationController *)segue.destinationViewController).viewControllers objectAtIndex:0]).delegate = self;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == EMAlertViewSelectProductConfirm){
        if(buttonIndex == 1){
            //se captura el sondeo
            self.productSelected.capturado = [NSNumber numberWithBool:YES];
            [[EMManagedObject sharedInstance] saveLocalContext];
            // se envia al controller de los sondeos
            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Sondeo"];
            EMSondeoViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
            sondeoVC.sondeo = self.sondeo;
            sondeoVC.tienda = self.tienda;
            sondeoVC.sku = self.productSelected.sku;
            sondeoVC.tipo = isCapturadosSelected;
            sondeoVC.productSku = @"si";
            sondeoVC.producto = self.productSelected;
            NSLog(@"el sku que pulso %@", self.productSelected.sku);
            [self presentViewController:navigation animated:YES completion:nil];
            
        }
    }else{
        NSLog(@"que trae %ld", (long)buttonIndex);
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma -mark EMScanDelegate
- (void)didScanCode:(NSString *)code
{
    NSLog(@"code: %@",code);
    if ([code rangeOfString:@": "].location != NSNotFound)
    {
        code = [code substringFromIndex:[code rangeOfString:@": "].location + 2];
    }
    NSInteger codeInt = [code integerValue];
    code = [[NSNumber numberWithInteger:codeInt] stringValue];
    if([[EMManagedObject sharedInstance] existProductForId:code])
    {
        self.skuCaptured = code;
        self.productSelected = [[EMManagedObject sharedInstance] productForId:code];
        /*EMProductSKUTableViewCell * cell = (EMProductSKUTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMProductSKUCellTypeButtonAccept inSection:1]];
        [cell.btnAccept sendActionsForControlEvents:UIControlEventTouchUpInside];*/
        
    }
    /*else
    {
        if (!self.alertWithOutProduct.isVisible)
        {
            self.alertWithOutProduct = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:[NSString stringWithFormat:@"No se encontró ningún producto con el código %@",code] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alertWithOutProduct show];
            self.skuCaptured = @"";
        }
        
    }*/
}

- (void)didDismissScanViewController
{
    NZAlertView * alert;
    if(self.skuCaptured.length)
    {
        alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess title:@"¡Gracias!" message:@"Se encontró un producto para el código ingresado"];
    }
    else
    {
        alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"¡Lo sentimos!" message:@"No se encuentran productos que coincidan con el código ingresado"];
    }
    [alert show];
    [self.tableView reloadData];
}

#pragma mark Picker Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [arrayPicker count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [arrayPicker objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"que valor esta seleccionando %@", [arrayPicker objectAtIndex:[pickerView selectedRowInComponent:component]]);
    //aquise realizara la consulta correspondiente para saber el filtro de busqueda
    enteroPicker = component;
    [self arrayProductos:textFilter];
    [self.tableView reloadData];
}

@end