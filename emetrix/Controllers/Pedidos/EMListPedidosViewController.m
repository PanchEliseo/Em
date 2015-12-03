//
//  EMListPedidosViewController.m
//  emetrix
//
//  Created by Carlos molina on 19/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMListPedidosViewController.h"
#import "EMPedidosTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import "NZAlertView.h"
#import "NSObject+EMObjectExtension.h"


@interface EMListPedidosViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * arrayProductos;
@property (strong, nonatomic) NSString * textoFilter;
@property (weak, nonatomic) IBOutlet UISearchBar *serchBar;
@property (strong, nonatomic) NSMutableArray * arrayProductosEnPedido;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic) BOOL isPedidoSelected;
@property (strong, nonatomic) UIButton * buttonPedido;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintSearchBarHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSendPedido;
@property (weak, nonatomic) IBOutlet UILabel *lbfPrecioTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbfProductosTotales;



@end

@implementation EMListPedidosViewController

- (NSMutableArray *) arrayProductos
{
    if (self.textoFilter && self.textoFilter.length)
    {
        _arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductosWithContainsString:self.textoFilter];
    }
    else
    {
        _arrayProductos = [[EMManagedObject sharedInstance] orderArray:[[[self containerParentViewController].cuenta.emProductos allObjects] mutableCopy] withKey:@"nombre"];
    }
   
    return _arrayProductos;
}

- (NSMutableArray *)arrayProductosEnPedido
{

    _arrayProductosEnPedido = [[EMManagedObject sharedInstance] mutableArrayProductosWithCuentaAndHaveCantidad:[self containerParentViewController].cuenta];
    return _arrayProductosEnPedido;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (EMProducto * producto in [[self containerParentViewController].cuenta.emProductos allObjects])
    {
        producto.cantidad = [NSNumber numberWithDouble:0];
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
    self.title = @"Productos";
    self.textoFilter = @"";
    //    Esta linea es la del navigation
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.buttonPedido = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.buttonPedido setTitle:@"En pedido" forState:UIControlStateNormal];
    [self.buttonPedido setTitle:@"Productos" forState:UIControlStateSelected];

    [self.buttonPedido addTarget:self action:@selector(didPressPedido) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonPedido];
    self.lbfProductosTotales.text = [NSString stringWithFormat:@"Productos en tu pedido: %ld", (unsigned long)self.arrayProductosEnPedido.count];
    double precioTotal = 0.00;
    for (EMProducto * producto in self.arrayProductosEnPedido)
    {
        precioTotal = precioTotal + ([producto.cantidad doubleValue] * [producto.precio doubleValue]);
    }
    self.lbfPrecioTotal.text = [NSString stringWithFormat:@"Precio total: $%.2f",precioTotal];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self.view superview] layoutSubviews];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (EMProducto * producto in [[self containerParentViewController].cuenta.emProductos allObjects])
    {
        producto.cantidad = [NSNumber numberWithDouble:0];
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    //    Es importante que este metodo se sobreescriba ya que si no se hace
    [super didMoveToParentViewController:parent];
    [self.tableView reloadData];
}

#pragma -mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isPedidoSelected)
    {
        if (self.arrayProductosEnPedido.count == 0)
        {
            self.tableView.hidden = YES;
        }
        else
        {
            self.tableView.hidden = NO;

        }
        return self.arrayProductosEnPedido.count;
    }
    if (self.arrayProductos.count == 0)
    {
        self.tableView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = NO;
        
    }
    return self.arrayProductos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMProducto * producto;
    if (self.isPedidoSelected)
    {
        if (self.arrayProductosEnPedido.count > indexPath.row)
        {
            producto = [self.arrayProductosEnPedido objectAtIndex:indexPath.row];
        }
    }
    else
    {
        producto = [self.arrayProductos objectAtIndex:indexPath.row];
    }
    
    EMPedidosTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellPedidos];
    [cell.imgVwPedido sd_setImageWithURL:[NSURL URLWithString:producto.urlImg] placeholderImage:[UIImage imageNamed:@"emetrix_logo_login"] completed:nil];
    cell.lbfName.text = producto.nombre;
    cell.lbfPrecio.text = [NSString stringWithFormat:@"$%@",producto.precio];
    if ([producto.cantidad integerValue])
    {
        cell.txtVwCantidad.text = [producto.cantidad stringValue];
            cell.lbfSubTotal.text = [NSString localizedStringWithFormat:@"$ %.2f",[producto.cantidad doubleValue] * [producto.precio doubleValue]];

    }
    else
    {
        cell.txtVwCantidad.text = nil;
       cell.txtVwCantidad.placeholder = @"Cantidad";
        cell.lbfSubTotal.text = @"Subtotal";

    }
    cell.txtVwCantidad.tag = indexPath.row;
    cell.txtVwCantidad.delegate = self;
    [cell.txtVwCantidad addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
//    cell.lbfId.text = enda.idTienda;
//    cell.imgVwBackground.backgroundColor = [UIColor emLightBlueColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:indexPath.row];
//    if ([tienda.idTienda integerValue] != EMSondeoStaticNuevaTienda)
//    {
////        ir a pendientes
//        [self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
//    }

    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[self containerParentViewController] preferredStatusBarStyle];
}

#pragma -mark UISerchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.textoFilter = searchText;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.textoFilter = nil;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self.tableView reloadData];
    
}




#pragma -mark UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{


}
- (void)textFieldDidChange:(UITextField *)textField
{
    //    Cargar producto a o remover producto del pedido
    NSString * cantidad = textField.text;
    EMPedidosTableViewCell * cell = (EMPedidosTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    EMProducto * producto;
    if (self.isPedidoSelected)
    {
        producto = [self.arrayProductosEnPedido objectAtIndex:textField.tag];
    }
    else
    {
        producto = [self.arrayProductos objectAtIndex:textField.tag];
    }
    cell.lbfSubTotal.text = [NSString localizedStringWithFormat:@"$ %.2f",[cantidad doubleValue] * [producto.precio doubleValue]];
    producto.cantidad = [NSNumber numberWithDouble:[cantidad doubleValue]];
    [[EMManagedObject sharedInstance] saveLocalContext];
    self.lbfProductosTotales.text = [NSString stringWithFormat:@"Productos en tu pedido: %ld", (unsigned long)self.arrayProductosEnPedido.count];
    double precioTotal = 0.00;
    for (EMProducto * producto in self.arrayProductosEnPedido)
    {
        precioTotal = precioTotal + ([producto.cantidad doubleValue] * [producto.precio doubleValue]);
    }
    self.lbfPrecioTotal.text = [NSString stringWithFormat:@"Precio total: \n%@",[NSString localizedStringWithFormat:@"$ %.2f", precioTotal]];
}
- (IBAction)didPressSondeos:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressPedido
{
    if (self.buttonPedido.selected)
    {
        self.buttonPedido.selected = NO;
        self.isPedidoSelected = NO;
//
        
    }
    else
    {
        self.buttonPedido.selected = YES;
        self.isPedidoSelected = YES;
    }
    [UIView animateWithDuration:0.5 animations:^(void)
    {
        self.viewContainer.alpha = 0;

    }
    completion:^(BOOL finished)
    {
        if (self.buttonPedido.selected)
        {
            self.contraintSearchBarHeight.constant = 0;
        }
        else
        {
            self.contraintSearchBarHeight.constant = 44;
        }
        [self.view updateConstraints];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            self.viewContainer.alpha = 1;
        }
        completion:^(BOOL finished)
        {
             
        }];
    }];
}
- (IBAction)didPressSend:(id)sender
{
//    enviar pedido
    if (self.arrayProductosEnPedido.count)
    {
        NSMutableDictionary * dictionaryToSend = [[NSMutableDictionary alloc] init];
        [dictionaryToSend setObject:[[self containerParentViewController].cuenta.idCuenta stringValue] forKey:@"idProyecto"];
        [dictionaryToSend setObject:[[self containerParentViewController].user.idUsuario stringValue] forKey:@"idUsuario"];
        [dictionaryToSend setObject:self.tienda.idTienda forKey:@"idTienda"];
        NSMutableArray * arrayProducts = [[NSMutableArray alloc] init];
        for (EMProducto * producto in self.arrayProductosEnPedido)
        {
            NSDictionary * dictionaryProduct = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:producto.sku, producto.cantidad, nil] forKeys:[NSArray arrayWithObjects:@"idProducto",@"cantidad", nil]];
            [arrayProducts addObject:dictionaryProduct];
        }
        [dictionaryToSend setObject:arrayProducts forKey:@"productos"];
        [dictionaryToSend setObject:[EMListPedidosViewController stringServiceFromDate:[[NSDate alloc] init]] forKey:@"fechaCaptura"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryToSend
                                                           options:0                                                             error:&error];
        if (! jsonData)
        {
            NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"Ocurrio un error: %@",error.localizedDescription]];
            [alert show];
        }
        else
        {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            EMPendiente * pendiente = [[EMManagedObject sharedInstance] newPendiente];
            pendiente.date = [[NSDate alloc] init];
            pendiente.idPendiente = [EMListPedidosViewController stringServiceFromDate:pendiente.date];
            pendiente.emCuenta = [self containerParentViewController].cuenta;
            pendiente.tipo = [NSNumber numberWithInt:EMPendienteTypePedido];
            pendiente.estatus = [NSNumber numberWithInt:EMPendienteStatePrepared];
            pendiente.cadenaPendiente = jsonString;
            [[EMManagedObject sharedInstance] saveLocalContext];
            [[self containerParentViewController] sendPendientes];
            NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess title:@"En proceso" message:@"Tu pedido será enviado"];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        
    }
    else
    {
        NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:@"No cuentas con productos en tu pedido"];
        [alert show];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
