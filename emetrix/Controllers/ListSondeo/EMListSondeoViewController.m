//
//  EMListSondeoViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 20/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMListSondeoViewController.h"
#import "EMListSondeoTableViewCell.h"
#import "UIColor+EMColorExtension.h"
#import "EMSondeoViewController.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMProductSKUViewController.h"
#import "EMSondeoFotoViewController.h"
#import "EMCheckInViewController.h"
#import "NZAlertView.h"
#import "EMListPedidosViewController.h"
#import "EMPull.h"
#import "EMContainerViewController.h"
#import "NSObject+EMObjectExtension.h"
#import "EMProductSKUPorSondeoViewController.h"

@interface EMListSondeoViewController ()<UITableViewDataSource, UITableViewDelegate, EMProductSKUDelegate, EMProductSKUDelegatePorSondeo>
@property (strong, nonatomic) NSMutableArray * arraySondeos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isProductSelected;
@property (strong, nonatomic) EMProducto * producto;
@property (strong, nonatomic) EMSondeo * sondeoSelected;

@end

@implementation EMListSondeoViewController

- (void) setTienda:(EMTienda *)tienda
{
    _tienda = tienda;
    if(_tienda && [_tienda.emSondeos allObjects].count)
    {
        self.arraySondeos = [[EMManagedObject sharedInstance] orderArray:[[tienda.emSondeos allObjects] mutableCopy] withKey:@"indice"];
        if ([self.arraySondeos containsObject:[[EMManagedObject sharedInstance] sondeoForId:EMSondeoStaticNuevaTienda]])
        {
            [self.arraySondeos removeObject:[[EMManagedObject sharedInstance] sondeoForId:EMSondeoStaticNuevaTienda]];
        }
//        self.arraySondeos = [[[tienda.emSondeos allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]] mutableCopy];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)arraySondeos
{
    if(!_arraySondeos)
    {
        _arraySondeos = [[NSMutableArray alloc] init];
    }
    return _arraySondeos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(handleGesture:)];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem.title = @"Ruta";
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(performBack:);
    
    // Do any additional setup after loading the view.
}
- (void) didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    self.title = self.tienda.nombre;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
    return self.arraySondeos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSondeo * sondeo = [self.arraySondeos objectAtIndex:indexPath.row];
    EMListSondeoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellListSondeoIdentifier];
    cell.lbfName.text = sondeo.nombre;
    cell.lbfSubName.text = [sondeo.idSondeo stringValue];
    if ([self.tienda.checkIn boolValue] || [sondeo.idSondeo integerValue] == EMSondeoStaticAsistencia)
    {
        NSString * pullId = [EMPull pullIdWhitUser:[self containerParentViewController].user
                                            cuenta:[self containerParentViewController].cuenta
                                            sondeo:sondeo
                                            tienda:self.tienda];
        EMPull * pull = [[EMManagedObject sharedInstance] pullForId:pullId];

        
        
        switch ([pull.estado integerValue])
        {
            case EMPullStateStart:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_sondeo_red"];
                switch ([sondeo.idSondeo integerValue])
                {
                    case EMSondeoStaticPedidos:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_pedidos_red"];
                        break;
                    case EMSondeoStaticFotos:
                    case EMSondeoStaticFotoGaleria:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_fotos_red"];
                        break;
                    
                    default:
                        break;
                }

                break;
            case EMPullStateIncomplete:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_sondeo_blue"];
                switch ([sondeo.idSondeo integerValue])
                {
                    case EMSondeoStaticPedidos:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_pedidos_green"];
                        break;
                    case EMSondeoStaticFotos:
                    case EMSondeoStaticFotoGaleria:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_fotos_green"];
                        break;
                    
                    default:
                        break;
                }
                break;
            case EMPullStateComplete:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_sondeo_green"];
                switch ([sondeo.idSondeo integerValue])
                {
                    case EMSondeoStaticPedidos:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_pedidos_green"];
                        break;
                    case EMSondeoStaticFotos:
                    case EMSondeoStaticFotoGaleria:
                        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_fotos_green"];
                        break;
                    
                    default:
                        break;
                }
                break;
            default:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_sondeo_red"];
                break;
        }
        cell.lbfName.textColor = [UIColor blackColor];
        cell.lbfSubName.textColor = [UIColor blackColor];
    }
    else
    {
        cell.lbfName.textColor = [UIColor grayColor];
        cell.lbfSubName.textColor = [UIColor grayColor];
        cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_sondeo_gray"];
        
        switch ([sondeo.idSondeo integerValue])
        {
            case EMSondeoStaticPedidos:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_pedidos_gray"];
                break;
            case EMSondeoStaticFotos:
            case EMSondeoStaticFotoGaleria:
                cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_fotos_gray"];
                break;
                
            default:
                break;
        }
        
    }
    if ([sondeo.idSondeo integerValue] == EMSondeoStaticAsistencia)
    {
        if ([self.tienda.checkIn boolValue])
        {
            cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_checkOut"];
            cell.lbfName.text = NSLocalizedString(@"EMTitleCheckOut", nil);
        }
        else
        {
            cell.imgVwSondeo.image = [UIImage imageNamed:@"icon_checkIn"];
            cell.lbfName.text = NSLocalizedString(@"EMTitleCheckIn", nil);
        }
    }


    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
        EMSondeo * sondeo = [self.arraySondeos objectAtIndex:indexPath.row];
        self.sondeoSelected = sondeo;
        if ([self.tienda.checkIn boolValue])
        {
            EMSondeo * sondeo = [self.arraySondeos objectAtIndex:indexPath.row];
            self.sondeoSelected = sondeo;
            if([sondeo.capturaSKU boolValue] && !self.isProductSelected)
            {
                UINavigationController * vc = (UINavigationController *)[self viewControllerForStoryBoardName:@"ProductSKUPorSondeo"];
                /*EMProductSKUViewController * vcSKU = [vc.viewControllers objectAtIndex:0];
                vcSKU.delegate = self;
                vcSKU.tienda = self.tienda;*/
                EMProductSKUPorSondeoViewController * vcSKU = [vc.viewControllers objectAtIndex:0];
                vcSKU.sondeo = sondeo;
                vcSKU.tienda = self.tienda;
                vcSKU.delegate = self;
                [self presentViewController:vc animated:YES completion:nil];
            }
            else if(![sondeo.capturaSKU boolValue])
            {
                if ([sondeo.idSondeo integerValue] != EMSondeoStaticAsistencia && [sondeo.idSondeo integerValue] != EMSondeoStaticFotoGaleria && [sondeo.idSondeo integerValue] != EMSondeoStaticFotos && [sondeo.idSondeo integerValue] != EMSondeoStaticPedidos)
                {
                    UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Sondeo"];
                    EMSondeoViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                    sondeoVC.sondeo = self.sondeoSelected;
                    sondeoVC.tienda = self.tienda;
                    [self presentViewController:navigation animated:YES completion:^{
                        self.isProductSelected = NO;
                    }];
                }
                else
                {
                    switch ([sondeo.idSondeo integerValue])
                    {
                        case EMSondeoStaticFotos:
                        {
                            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Fotos"];
                            EMSondeoFotoViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                            sondeoVC.sondeo = self.sondeoSelected;
                            sondeoVC.isFotoGaleria = NO;
                            sondeoVC.tienda = self.tienda;
                            [self presentViewController:navigation animated:YES completion:^{
                                self.isProductSelected = NO;
                            }];
                        }
                            break;
                        case EMSondeoStaticFotoGaleria:
                        {
                            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Fotos"];
                            EMSondeoFotoViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                            sondeoVC.sondeo = self.sondeoSelected;
                            sondeoVC.isFotoGaleria = YES;
                            sondeoVC.tienda = self.tienda;
                            [self presentViewController:navigation animated:YES completion:^{
                                self.isProductSelected = NO;
                            }];
                        }
                            break;
                        case EMSondeoStaticAsistencia:
                        {
                            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"CheckIn-Out"];
                            EMCheckInViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                            sondeoVC.tienda = self.tienda;
                            [self presentViewController:navigation animated:YES completion:^{
                                self.isProductSelected = NO;
                            }];
                        }
                            break;
                        case EMSondeoStaticPedidos:
                        {
                            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Pedidos"];
                            EMListPedidosViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                            sondeoVC.tienda = self.tienda;
                            [self presentViewController:navigation animated:YES completion:^{
                                self.isProductSelected = NO;
                            }];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                
                
            }
            
        }
        else
        {
            if ([sondeo.idSondeo integerValue] == EMSondeoStaticAsistencia)
            {
                UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"CheckIn-Out"];
                EMCheckInViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
                sondeoVC.tienda = self.tienda;
                [self presentViewController:navigation animated:YES completion:^{
                    self.isProductSelected = NO;
                }];
            }
            else
            {
                NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"No puedes entrar a ningún sondeo hasta que realices %@", NSLocalizedString(@"EMTitleCheckIn", nil)]];
                [alert show];
            }
        }
    });
}


- (void) handleGesture:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectProduct:(EMProducto *)producto
{
    self.producto = producto;
    self.isProductSelected = YES;
    self.producto.capturado = [NSNumber numberWithBool:YES];
    [[EMManagedObject sharedInstance] saveLocalContext];
}

- (void)didDismissProductSKU
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
        UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Sondeo"];
        EMSondeoViewController * sondeoVC = [navigation.viewControllers objectAtIndex:0];
        sondeoVC.sondeo = self.sondeoSelected;
        sondeoVC.tienda = self.tienda;
        sondeoVC.sku = self.producto.sku;
        [self presentViewController:navigation animated:YES completion:^{
            self.isProductSelected = NO;
        }];

    });
}

-(void)performBack:(id)sender {
    
    BOOL existeSondeoObligatorioSinResponder = NO;
    EMSondeo * sondeo;
    
    for (sondeo in self.arraySondeos) {
        if (sondeo.obligatorio.boolValue) {
            NSArray * arr = [[EMManagedObject sharedInstance] mutableArrayPendientesForIdSondeo:sondeo.idSondeo.stringValue idTienda:self.tienda.idTienda];
            if (arr.count == 0) {
                existeSondeoObligatorioSinResponder = YES;
                break;
            }
        }
    }
    
    if (existeSondeoObligatorioSinResponder) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:[NSString stringWithFormat:@"Existen sondeos sin contestar: %@", sondeo.nombre]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: @"ACEPTAR", @"SALIR", nil];
        alert.tag = 1;
        [alert show];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
