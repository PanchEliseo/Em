//
//  EMProductSKUViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMProductSKUViewController.h"
#import "EMProductSKUTableViewCell.h"
#import "EMProductListViewController.h"
#import "EMScanCodeViewController.h"
#import "NZAlertView.h"
#import <CZPickerView.h>
#import "UIColor+EMColorExtension.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"


typedef enum
{
    EMProductSKUCellTypeInputSKU = 0,
    EMProductSKUCellTypeSelectCategory,
    EMProductSKUCellTypeSelectMark,
    EMProductSKUCellTypeButtonAccept
    
} EMProductSKUCellType;


typedef enum
{
    EMAlertViewSelectProductConfirm = 1
    
} EMAlertView;

@interface EMProductSKUViewController ()<UITableViewDataSource, UITableViewDelegate, /*UIPickerViewDataSource, UIPickerViewDelegate,*/ EMProductSKUTableViewCellDelegate, EMScanDelegate, UITextFieldDelegate, UIAlertViewDelegate, CZPickerViewDataSource, CZPickerViewDelegate, EMProductListDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) NSMutableArray * arrayCategoria;
@property (strong, nonatomic) NSMutableArray * arrayMarca;
@property (strong, nonatomic) NSMutableArray * arrayProductos;

@property (strong, nonatomic) EMMarca * marcaSelected;
@property (strong, nonatomic) EMCategoria * categoriaSelected;
@property (nonatomic) BOOL isCapturadosSelected;
@property (strong, nonatomic) NSString * skuCaptured;
@property (strong, nonatomic) UIAlertView * alertProductConfirm;
@property (strong, nonatomic) UIAlertView * alertWithOutProduct;

@end

@implementation EMProductSKUViewController

- (NSMutableArray *)arrayCategoria
{
    if(!_arrayCategoria)
    {
        _arrayCategoria = [[EMManagedObject sharedInstance] mutableArrayCategoria];
    }
    return _arrayCategoria;
}

- (NSMutableArray *)arrayMarca
{
    if(!_arrayMarca)
    {
        _arrayMarca = [[EMManagedObject sharedInstance] mutableArrayMarcaWithCategoria:self.categoriaSelected];
    }
    return _arrayMarca;
}

- (NSMutableArray *) arrayProductos
{
    if(self.segmentControl.selectedSegmentIndex == 0)
    {
        self.isCapturadosSelected = NO;
    }
    else
    {
        self.isCapturadosSelected = YES;
    }
    _arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductsForMarca:self.marcaSelected forCategoria:self.categoriaSelected capturado:self.isCapturadosSelected tienda:self.tienda cuenta:[self containerParentViewController].cuenta];
    return _arrayProductos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Producto";
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.arrayProductos.count)
    {
        self.productSelected = [self.arrayProductos objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  EMProductSKUTableViewCell * cell;
    
    switch(indexPath.row)
    {
        case EMProductSKUCellTypeInputSKU:
            cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellProductSKU];
            cell.delegate = self;
            cell.txtFldSKU.delegate = self;
            cell.txtFldSKU.text = self.skuCaptured;
            break;
        case EMProductSKUCellTypeSelectCategory:
            cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellProductPicker];
            cell.btnPicker.tag = indexPath.row;
            if (self.categoriaSelected)
            {
                [cell.btnPicker setTitle:self.categoriaSelected.nombre forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnPicker setTitle:@"Todas" forState:UIControlStateNormal];
            }
            cell.lbfTitlePicker.text = [NSString stringWithFormat:@"Total de categorias %ld. Categoria:", (unsigned long)self.arrayCategoria.count];
            cell.delegate = self;
            break;
        case EMProductSKUCellTypeSelectMark:
            cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellProductPicker];
            cell.btnPicker.tag = indexPath.row;
            if (self.marcaSelected)
            {
                [cell.btnPicker setTitle:self.marcaSelected.nombre forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnPicker setTitle:@"Todas" forState:UIControlStateNormal];
            }
            cell.lbfTitlePicker.text = [NSString stringWithFormat:@"Total de marcas %ld. Marca:", (unsigned long)self.arrayMarca.count];
            cell.delegate = self;
            break;
        case EMProductSKUCellTypeButtonAccept:
            cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellProductSKUButton];
            cell.btnPicker.tag = indexPath.row;
            if (self.arrayProductos.count && !self.productSelected)
            {
                EMProducto * productoSel = [self.arrayProductos objectAtIndex:0];
                [cell.btnPicker setTitle:productoSel.nombre forState:UIControlStateNormal];


            }
            else if (self.productSelected)
            {
               [cell.btnPicker setTitle:self.productSelected.nombre forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnPicker setTitle:@"Sin productos" forState:UIControlStateNormal];

            }
            cell.delegate = self;
            
            break;
        default:
            break;
    
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case EMProductSKUCellTypeInputSKU:
            return 85.0;
            break;
        case EMProductSKUCellTypeSelectCategory:
            return 105.0;
            break;
        case EMProductSKUCellTypeSelectMark:
            return 105.0;
            break;
        case EMProductSKUCellTypeButtonAccept:
            return 155.0;
            break;
        default:
            break;
            
    }
    
    return 0;
}
- (IBAction)didPressSearch:(id)sender
{
    [self performSegueWithIdentifier:kEMSegueEMProductListIdentifier sender:self];
}

- (IBAction)didPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark UIPickerView
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
//    {
//        return self.arrayCategoria.count + 1;
//    }
//    else if (pickerView.tag == EMProductSKUCellTypeSelectMark)
//    {
//        return self.arrayMarca.count + 1;
//    }
//    else
//    {
//        if(self.arrayProductos.count == 0)
//        {
//            return 1;
//        }
//        return self.arrayProductos.count;
//    }
//    
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//        
//        if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
//        {
//            if(row == 0)
//            {
//                return @"Todas";
//            }
//            else
//            {
//                row = row - 1;
//                EMCategoria * categoria = [self.arrayCategoria objectAtIndex:row];
//                return categoria.nombre;
//            }
//        }
//        else if (pickerView.tag == EMProductSKUCellTypeSelectMark)
//        {
//            if(row == 0)
//            {
//                return @"Todas";
//            }
//            else
//            {
//                row = row - 1;
//                EMMarca * marca = [self.arrayMarca objectAtIndex:row];
//                return marca.nombre;
//            }
//        }
//        else
//        {
//            if(self.arrayProductos.count == 0)
//            {
//                return @"Sin productos";
//            }
//            else
//            {
//                EMProducto * producto = [self.arrayProductos objectAtIndex:row];
//                return producto.nombre;
//            }
//        }
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
//    {
//        if(row == 0)
//        {
//            self.categoriaSelected = nil;
//        }
//        else
//        {
//            row = row -1;
//            self.categoriaSelected = [self.arrayCategoria objectAtIndex:row];
//        }
//        self.arrayMarca = [[EMManagedObject sharedInstance] mutableArrayMarcaWithCategoria:self.categoriaSelected];
//        
//    }
//    else if(pickerView.tag == EMProductSKUCellTypeSelectMark)
//    {
//        if(row == 0)
//        {
//            self.marcaSelected = nil;
//        }
//        else
//        {
//            row = row -1;
//            self.marcaSelected = [self.arrayMarca objectAtIndex:row];
//        }
//    }
//    else
//    {
////        son productos
//        if(self.arrayProductos.count)
//        {
//            self.productSelected = [self.arrayProductos objectAtIndex:row];
//        }
//        
//    }
//    if(pickerView.tag != EMProductSKUCellTypeButtonAccept)
//    {
//        [self.tableView reloadData];
//        EMProductSKUTableViewCell * cell = (EMProductSKUTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMProductSKUCellTypeButtonAccept inSection:0]];
//        if(self.arrayProductos.count)
//        {
//            [cell.pickerView selectRow:0 inComponent:0 animated:YES];
//            self.productSelected = [self.arrayProductos objectAtIndex:0];
//        }
//        
//    }
//
//}


#pragma -mark UISegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kEMSegueEMProductListIdentifier])
    {
        ((EMProductListViewController *)segue.destinationViewController).cuenta = [self containerParentViewController].cuenta;
        ((EMProductListViewController *)segue.destinationViewController).tienda = self.tienda;
        ((EMProductListViewController *)segue.destinationViewController).delegate = self;


    }
    else if([segue.identifier isEqualToString:kEMSegueScanCodeIdentifier])
    {
        ((EMScanCodeViewController *)[((UINavigationController *)segue.destinationViewController).viewControllers objectAtIndex:0]).delegate = self;
    }
}

- (IBAction)didPressSegment
{
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

- (void)didPressScanner
{
    [self performSegueWithIdentifier:kEMSegueScanCodeIdentifier sender:self];
}

- (void)didPressPickerView:(UIButton *)sender
{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Seleccione una opción"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.headerBackgroundColor = [UIColor emDarkBlueColor];
    picker.tag = sender.tag;
    picker.delegate = self;
    picker.dataSource = self;
    [picker show];

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
        EMProductSKUTableViewCell * cell = (EMProductSKUTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMProductSKUCellTypeButtonAccept inSection:1]];
        [cell.btnAccept sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        if (!self.alertWithOutProduct.isVisible)
        {
            self.alertWithOutProduct = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:[NSString stringWithFormat:@"No se encontró ningún producto con el código %@",code] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alertWithOutProduct show];
            self.skuCaptured = @"";
        }
        
    }
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
        alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"¡Lo sentimos!" message:@"No se encuentras productos que coincidan con el código ingresado"];
    }
    [alert show];
    [self.tableView reloadData];
}

#pragma -mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self didScanCode:textField.text];
    [self didDismissScanViewController];
}
#pragma -mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == EMAlertViewSelectProductConfirm)
    {
        if(buttonIndex == 1)
        {
            if([self.delegate respondsToSelector:@selector(didSelectProduct:)])
            {
                [self.delegate didSelectProduct:self.productSelected];
            }
            if([self.delegate respondsToSelector:@selector(willDismissProductSKU)])
            {
                [self.delegate willDismissProductSKU];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                if([self.delegate respondsToSelector:@selector(didDismissProductSKU)])
                {
                    [self.delegate didDismissProductSKU];
                }
            }];
            
        }
    }
}

#pragma -mark CZPickerView

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
    {
        return self.arrayCategoria.count + 1;
    }
    else if (pickerView.tag == EMProductSKUCellTypeSelectMark)
    {
        return self.arrayMarca.count + 1;
    }
    else
    {
        if(self.arrayProductos.count == 0)
        {
            return 1;
        }
        return self.arrayProductos.count;
    }
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row
{
    if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
    {
        if(row == 0)
        {
            return @"Todas";
        }
        else
        {
            row = row - 1;
            EMCategoria * categoria = [self.arrayCategoria objectAtIndex:row];
            return categoria.nombre;
        }
    }
    else if (pickerView.tag == EMProductSKUCellTypeSelectMark)
    {
        if(row == 0)
        {
            return @"Todas";
        }
        else
        {
            row = row - 1;
            EMMarca * marca = [self.arrayMarca objectAtIndex:row];
            return marca.nombre;
        }
    }
    else
    {
        if(self.arrayProductos.count == 0)
        {
            return @"Sin productos";
        }
        else
        {
            EMProducto * producto = [self.arrayProductos objectAtIndex:row];
            return producto.nombre;
        }
    }

}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    if(pickerView.tag == EMProductSKUCellTypeSelectCategory)
    {
        if(row == 0)
        {
            self.categoriaSelected = nil;
        }
        else
        {
            row = row -1;
            self.categoriaSelected = [self.arrayCategoria objectAtIndex:row];
        }
        self.arrayMarca = [[EMManagedObject sharedInstance] mutableArrayMarcaWithCategoria:self.categoriaSelected];
        
    }
    else if(pickerView.tag == EMProductSKUCellTypeSelectMark)
    {
        if(row == 0)
        {
            self.marcaSelected = nil;
        }
        else
        {
            row = row -1;
            self.marcaSelected = [self.arrayMarca objectAtIndex:row];
        }
    }
    else
    {
        //        son productos
        if(self.arrayProductos.count)
        {
            self.productSelected = [self.arrayProductos objectAtIndex:row];
        }
        
    }
    [self.tableView reloadData];
    if(pickerView.tag != EMProductSKUCellTypeButtonAccept)
    {
        EMProductSKUTableViewCell * cell = (EMProductSKUTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMProductSKUCellTypeButtonAccept inSection:0]];
        if(self.arrayProductos.count)
        {
            [cell.pickerView selectRow:0 inComponent:0 animated:YES];
            self.productSelected = [self.arrayProductos objectAtIndex:0];
        }
        
    }

}

#pragma -mark EMProductListDelegate

- (void)didSelectProduct:(EMProducto *)producto
{
    self.productSelected = producto;
    EMProductSKUTableViewCell * cell = (EMProductSKUTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMProductSKUCellTypeButtonAccept inSection:1]];
    [cell.btnAccept sendActionsForControlEvents:UIControlEventTouchUpInside];
}



@end
