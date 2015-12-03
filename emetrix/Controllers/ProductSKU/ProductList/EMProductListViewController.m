//
//  EMProductListViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 06/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMProductListViewController.h"
#import "EMProductListTableViewCell.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"

@interface EMProductListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * arrayProductos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EMProductListViewController

- (void)setTienda:(EMTienda *)tienda
{
    _tienda = tienda;
    self.arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductosForTienda:_tienda cuenta:self.cuenta];
    [self.tableView reloadData];
}

- (void)setCuenta:(EMCuenta *)cuenta
{
    _cuenta = cuenta;
    self.arrayProductos = [[EMManagedObject sharedInstance] mutableArrayProductosForTienda:_tienda cuenta:_cuenta];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayProductos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMProductListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellProductList];
    EMProducto * producto = [self.arrayProductos objectAtIndex:indexPath.row];
    EMMarca * marca = [[producto.emMarcas allObjects] objectAtIndex:0];
    EMCategoria * categoria = [[producto.emCategoria allObjects] objectAtIndex:0];
    cell.lbfNameProduct.text = producto.nombre;
    cell.lbfSKU.text = [NSString stringWithFormat:@"SKU: %@",producto.sku];
    cell.lbfMarkAnsCategory.text = [NSString stringWithFormat:@"Marca: %@ - Categoria: %@",marca.nombre,categoria.nombre];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block EMProducto * producto = [self.arrayProductos objectAtIndex:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProduct:)])
        {
            [self.delegate didSelectProduct:producto];
        }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    EMProductListTableViewCell * cell = (EMProductListTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    EMProducto * producto = [self.arrayProductos objectAtIndex:indexPath.row];
//    EMMarca * marca = [[producto.emMarcas allObjects] objectAtIndex:0];
//    EMCategoria * categoria = [[producto.emCategoria allObjects] objectAtIndex:0];
//    CGFloat height = 0;
//    
//    cell.constraintHeightLbfNameProduct.constant = [self heightForLabel:cell.lbfNameProduct withText:producto.nombre withWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 20];
//    cell.constraintHeightLbfSKU.constant = [self heightForLabel:cell.lbfSKU withText:[NSString stringWithFormat:@"SKU: %@",producto.sku] withWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 20];
//    cell.constraintHeightLbfMArkAnsCategory.constant = [self heightForLabel:cell.lbfMarkAnsCategory withText:[NSString stringWithFormat:@"Marca: %@ - Categoria: %@",marca.nombre,categoria.nombre] withWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 20];
//    [cell updateConstraints];
//    height = height + cell.constraintHeightLbfNameProduct.constant + cell.constraintHeightLbfSKU.constant + cell.constraintHeightLbfMArkAnsCategory.constant + 20;
//
//    return height;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
