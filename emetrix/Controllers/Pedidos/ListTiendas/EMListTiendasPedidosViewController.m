//
//  EMListTiendasPedidosViewController.m
//  emetrix
//
//  Created by Carlos molina on 19/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMListTiendasPedidosViewController.h"
#import "NSObject+EMObjectExtension.h"
#import "EMRutaDelDiaTableViewCell.h"
#import "UIColor+EMColorExtension.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMListSondeoViewController.h"
#import "EMContainerViewController.h"
#import "NZAlertView.h"
#import "NZAlertViewDelegate.h"
#import "EMMensajes.h"
#import "EMServiceObjectMensajesConfigurables.h"
#import "EMPendiente+EMExtensions.h"
#import "EMSondeoViewController.h"
#import "EMListPedidosViewController.h"

@interface EMListTiendasPedidosViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * arrayTiendasPorDia;
@property (strong, nonatomic) NSMutableArray * arrayMensajes;
@end

@implementation EMListTiendasPedidosViewController

- (NSMutableArray *) arrayMensajes
{
    if(!_arrayMensajes && !_arrayMensajes.count)
    {
        _arrayMensajes = [[[self containerParentViewController].cuenta.emMensajes allObjects] mutableCopy];
        
    }
    return _arrayMensajes;
}
- (NSMutableArray *) arrayTiendasPorDia
{
    NSDate * date = [[NSDate alloc] init];
    NSString * idTiendasXDia = [EMListTiendasPedidosViewController tiendaXDiaIDWithDate:date user:[self containerParentViewController].user cuenta:[self containerParentViewController].cuenta];
    if ([[EMManagedObject sharedInstance] existTiendaXDiaForId:idTiendasXDia])
    {
        
        EMTiendasXdia * tiendasXDia = [[EMManagedObject sharedInstance] tiendasXdiaForId:idTiendasXDia];
        
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
        _arrayTiendasPorDia = [[[tiendasXDia.emTiendas allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]] mutableCopy];
        
    }
    if ([_arrayTiendasPorDia containsObject:[[EMManagedObject sharedInstance] tiendaForId:[NSString stringWithFormat:@"%u",EMSondeoStaticNuevaTienda]]])
    {
        [_arrayTiendasPorDia removeObject:[[EMManagedObject sharedInstance] tiendaForId:[NSString stringWithFormat:@"%u",EMSondeoStaticNuevaTienda]]];
    }
    return _arrayTiendasPorDia;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = self.navigationController.navigationBar.frame;
    float y = rect.size.height + rect.origin.y;
    self.tableView.contentInset = UIEdgeInsetsMake(y ,0,0,0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    Esta linea es la del navigation
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    return self.arrayTiendasPorDia.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:indexPath.row];
    EMRutaDelDiaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellRutaDelDiaIdentifier];
    cell.lbfName.text = tienda.nombre;
    cell.lbfId.text = tienda.idTienda;
    cell.imgVwBackground.backgroundColor = [UIColor emLightBlueColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:indexPath.row];
    if ([tienda.idTienda integerValue] != EMSondeoStaticNuevaTienda)
    {
        //        ir a pendientes
        [self performSegueWithIdentifier:kEMSegueListPedidosSegueIdentifier sender:tienda];
    }
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[self containerParentViewController] preferredStatusBarStyle];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEMSegueListPedidosSegueIdentifier])
    {
        ((EMListPedidosViewController *)segue.destinationViewController).tienda = sender;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 */

@end
