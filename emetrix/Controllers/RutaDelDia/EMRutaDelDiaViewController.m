//
//  EMRutaDelDiaViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 20/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMRutaDelDiaViewController.h"
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
#import "EMServiceObjectSondeosRespuestasOnline.h"
#import "emetrix-Swift.h"
#import "EMNuevaTiendaPageViewController.h"

@interface EMRutaDelDiaViewController ()<UITableViewDelegate, UITableViewDataSource, NZAlertViewDelegate>{
    UIAlertView *alertMes;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * arrayTiendasPorDia;
@property (strong, nonatomic) NSMutableArray * arrayMensajes;

@property (nonatomic) NSInteger indexMessage;
@property (nonatomic) NSString * textoFilter;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)NSString *visitaNombre;
@property NSInteger posicion;

@end

@implementation EMRutaDelDiaViewController


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
    NSString * idTiendasXDia = [EMRutaDelDiaViewController tiendaXDiaIDWithDate:date user:[self containerParentViewController].user cuenta:[self containerParentViewController].cuenta];
    if ([[EMManagedObject sharedInstance] existTiendaXDiaForId:idTiendasXDia])
    {
        
        EMTiendasXdia * tiendasXDia = [[EMManagedObject sharedInstance] tiendasXdiaForId:idTiendasXDia];
        
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
        _arrayTiendasPorDia = [[[[EMManagedObject sharedInstance] tiendasXdiaForTiendaXDia:tiendasXDia withFilterText:self.textoFilter] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]] mutableCopy];
    }
    return _arrayTiendasPorDia;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //    CGRect rect = self.navigationController.navigationBar.frame;
    //    float y = rect.size.height + rect.origin.y;
    //    self.tableView.contentInset = UIEdgeInsetsMake(y ,0,0,0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    Esta linea es la del navigation
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.tableView.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessageNotification:) name:kEMKeyNotificationMessage object:nil];
    self.indexMessage = 0;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentMessage];
    [[self.view superview] layoutSubviews];
    [self.tableView reloadData];
    [self.view bringSubviewToFront:self.searchBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    switch ([tienda.estatus integerValue])
    {
        case EMStatusTypeNotVisit:
            cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_red"];
            //            cell.imgVwBackground.backgroundColor = [UIColor emRedColor];
            break;
        case EMStatusTypeInVisit:
            cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_yellow"];
            //            cell.imgVwBackground.backgroundColor = [UIColor emYellowColor];
            break;
        case EMStatusTypeVisited:
            cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_green"];
            //            cell.imgVwBackground.backgroundColor = [UIColor emGreenColor];
            break;
        default:
            cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_blue"];
            //            cell.imgVwBackground.backgroundColor = [UIColor emLightBlueColor];
            break;
    }
    if ([tienda.idTienda intValue] == EMSondeoStaticNuevaTienda)
    {
        cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_nuevo"];
        
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self resignFirstResponder];
    
    EMTienda *tienda = [self.arrayTiendasPorDia objectAtIndex:indexPath.row];
    self.posicion = indexPath.row;
    if([tienda.idTienda integerValue] != EMSondeoStaticNuevaTienda && [self validarAlertaDescripcion:tienda] == NO)
        [self enviarASondeo:indexPath.row];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if(buttonIndex == 0){
            if(![[alertView textFieldAtIndex:buttonIndex].text isEqualToString:@""]){
                self.visitaNombre = [alertView textFieldAtIndex:buttonIndex].text;
                [self enviarASondeo:self.posicion];
            }else{
                EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:self.posicion];
                [self validarAlertaDescripcion:tienda];
            }
        }
    }else{
        if(buttonIndex == 0){
            EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:self.posicion];
            tienda.banderaDefinirNombre = [NSNumber numberWithBool:NO];
            [[EMManagedObject sharedInstance] saveLocalContext];
            [self validarAlertaDescripcion:tienda];
        }
    }
}

- (BOOL)validarAlertaDescripcion:(EMTienda *)tienda
{
    if (tienda.definirNombre.boolValue)
    {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(tienda.banderaDefinirNombre.boolValue){
                alertMes = [[UIAlertView alloc] initWithTitle:@"Ya se realizo el cambio de actividad. ¿Esta seguro de continuar?" message:@"" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar", nil];
                alertMes.tag = 2;
                [alertMes show];
            }else{
                alertMes = [[UIAlertView alloc] initWithTitle:@"Descripción de actividad" message:@"" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar", nil];
                alertMes.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertMes.tag = 1;
                [alertMes show];
            }
        }];
        return YES;
    }else
        return NO;
    
}

- (void)enviarASondeo:(NSInteger)posicion{
    EMTienda * tienda = [self.arrayTiendasPorDia objectAtIndex:posicion];
    EMUser * usuario = [self containerParentViewController].user;
    EMCuenta * cuenta =[self containerParentViewController].cuenta;
    
    if([tienda.idTienda integerValue] != EMSondeoStaticNuevaTienda)
    {
        if ([[self containerParentViewController].cuenta.descargaSondeosOnline boolValue]) {
            
            if ([[EMManagedObject sharedInstance] existsRespuestasDefaultForCuenta:cuenta tienda:tienda] == NO) {
                
                [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerDownload", nil) animated:YES];
                
                EMServiceObjectSondeosRespuestasOnline * sondeosResOnline = [[EMServiceObjectSondeosRespuestasOnline alloc] initWithUsuario:usuario cuenta:cuenta tienda:tienda];
                
                [sondeosResOnline startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
                 {
                     [SwiftSpinner hide:nil];
                     
                     if (error || successDownload == NO)
                         [[[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"Lo sentimos" message:@"No se tiene información de una visita anterior"] show];
                     [self prepareForPresentSondoVCWithTienda:tienda];
                 }];
            }
            else
                [self prepareForPresentSondoVCWithTienda:tienda];
        }
        else
            [self prepareForPresentSondoVCWithTienda:tienda];
    }
    else
        [self prepareForPresentSondoVCWithTienda:tienda];
    
}

- (void)prepareForPresentSondoVCWithTienda:(EMTienda *) tienda
{
    if ([tienda.idTienda integerValue] != EMSondeoStaticNuevaTienda)
    {
        EMListSondeoViewController * vc = (EMListSondeoViewController *)[self viewControllerForStoryBoardName:@"ListSondeos"];
        vc.tienda = tienda;
        
        //        Creamos el pendiente de la visita
        EMPendiente * pendienteVisita = [[EMManagedObject sharedInstance] newPendiente];
        pendienteVisita.date = [[NSDate alloc] init];
        pendienteVisita.idPendiente = [EMRutaDelDiaViewController stringServiceFromDate:pendienteVisita.date];
        pendienteVisita.determinanteGPS = tienda.idTienda;
        pendienteVisita.tipo = [NSNumber numberWithInteger:EMPendienteTypeSendVisita];
        pendienteVisita.estatus = [NSNumber numberWithInteger:EMPendienteStateWithOutLocation];
        if(tienda.definirNombre.boolValue){
            pendienteVisita.visitaNombre = self.visitaNombre;
        }
        pendienteVisita.emCuenta = [self containerParentViewController].cuenta;
        [self pendienteLogMovilForTag:kEMPendienteTagTienda];
        [[EMManagedObject sharedInstance] saveLocalContext];
        [[self containerParentViewController] sendPendientes];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
        
        //se modifica el nombre en la base de datos por el nuevo que introdujo el usuario
        if(tienda.definirNombre.boolValue && ![self.visitaNombre isEqualToString:@""]){
            //setear la bandera en YES
            tienda.banderaDefinirNombre = [NSNumber numberWithBool:YES];
            tienda.nombre = self.visitaNombre;
            [[EMManagedObject sharedInstance] saveLocalContext];
        }
        
    }
    else
    {
        EMSondeo * sondeo = [[EMManagedObject sharedInstance] sondeoForId:EMSondeoStaticNuevaTienda];
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"NuevaTienda" bundle:nil];
        
        EMNuevaTiendaPageViewController * tiendaVC = [storyBoard instantiateViewControllerWithIdentifier:@"EMNuevaTiendaPageViewController"];
        tiendaVC.usuario = [self containerParentViewController].user;
        tiendaVC.sondeo = sondeo;
        tiendaVC.tienda = tienda;
        tiendaVC.cuenta = [self containerParentViewController].cuenta;
        
        [self.parentViewController.navigationController pushViewController:tiendaVC animated:YES];
    }
}

#pragma -mark PresentMessage
- (void)presentMessage
{
    if(self.indexMessage < self.arrayMensajes.count)
    {
        EMMensajes * mensaje = [self.arrayMensajes objectAtIndex:self.indexMessage];
        NZAlertView * alert;
        switch ([mensaje.tipo integerValue])
        {
            case EMMensajeTypeFelicitacion:
                alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess title:@"¡Felicidades!" message:mensaje.mensaje delegate:self];
                break;
            case EMMensajeTypeGeneral:
                alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"General" message:mensaje.mensaje delegate:self];
                break;
            case EMMensajeTypeAlerta:
                alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Atención" message:mensaje.mensaje delegate:self];
                break;
            case EMMensajeTypeInformativo:
                alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"Informativo" message:mensaje.mensaje delegate:self];
                break;
                
            default:
                break;
        }
        alert.alertDuration = 1000;
        [alert show];
        
        self.indexMessage ++;
    }
    else
    {
        self.tableView.userInteractionEnabled = YES;
    }
}
- (void)NZAlertViewDidDismiss:(NZAlertView *)alertView
{
    [self presentMessage];
}

- (void) receivedMessageNotification:(NSNotification *) notification
{
    [self presentMessage];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end