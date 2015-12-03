//
//  EMListTiendaViewController.m
//  emetrix
//
//  Created by Marco on 18/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMListTiendaViewController.h"
#import "EMRutaDelDiaTableViewCell.h"
#import "EMSondeoLocationDelegate.h"
#import "EMTienda.h"
#import "EMServiceObjectTiendasXdia.h"
#import "NSObject+EMObjectExtension.h"

@interface EMListTiendaViewController ()
{
    EMTienda * tiendaSeleccionada;
    CLLocationManager * locationManager;
    CLLocation * userLocation;
    BOOL locationGET;
    NSArray * arrayTiendas;
}

@end

@implementation EMListTiendaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationGET = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSArray *)ordenarTiendasPorLocalizacion
{
    NSMutableArray * arrayOrdenado;
    
    arrayOrdenado = [[EMManagedObject sharedInstance] mutableArrayTiendasPorCuenta:self.cuenta];
    
    if (userLocation) {
        
        [arrayOrdenado sortUsingComparator: ^(EMTienda * tiendaUno, EMTienda * tiendaDos)
        {
            CLLocation *locationTiendaUno = [[CLLocation alloc] initWithLatitude:tiendaUno.latitud.doubleValue longitude:tiendaUno.longitud.doubleValue];
            CLLocation *locationTiendaDos = [[CLLocation alloc] initWithLatitude:tiendaDos.latitud.doubleValue longitude:tiendaDos.longitud.doubleValue];
                             
            CLLocationDistance dist_a = [locationTiendaUno distanceFromLocation:userLocation];
            CLLocationDistance dist_b = [locationTiendaDos distanceFromLocation:userLocation];
                             
            if ( dist_a < dist_b )
                return (NSComparisonResult)NSOrderedAscending;
            else if ( dist_a > dist_b)
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedSame;
        }];
    }

    return arrayOrdenado;
}




#pragma -mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayTiendas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMTienda * tienda = (EMTienda *)[arrayTiendas objectAtIndex:indexPath.row];
    EMRutaDelDiaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellRutaDelDiaIdentifier];
    cell.lbfName.text = tienda.nombre;
    cell.lbfId.text = tienda.idTienda;
    cell.imgVwCar.image = [UIImage imageNamed:@"icon_car_blue"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tiendaSeleccionada = (EMTienda *)[arrayTiendas objectAtIndex:indexPath.row];
    
    tiendaSeleccionada.emSondeos = [NSSet setWithArray:[[EMManagedObject sharedInstance] mutableArraySondeosPorCuenta:self.cuenta]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                               message:[NSString stringWithFormat:@"La tienda %@ se agregará a tu ruta del dia", tiendaSeleccionada.nombre]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"ACEPTAR",@"CANCELAR", nil];
    
    alert.tag = 1;
    [alert show];
}




#pragma -mark SerachBar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    arrayTiendas = [self ordenarTiendasPorLocalizacion];
    
    if (searchText.length > 0)
        arrayTiendas = [arrayTiendas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"nombre CONTAINS %@", searchText.uppercaseString]];
    
    if (searchText.length == 0)
        [searchBar resignFirstResponder];
    
    [tableViewTiendas reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    arrayTiendas = [self ordenarTiendasPorLocalizacion];
    [tableViewTiendas reloadData];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma -mark CLLocation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    userLocation = newLocation;
    locationGET = YES;
    
    arrayTiendas = [self ordenarTiendasPorLocalizacion];
    [tableViewTiendas reloadData];
}


#pragma -mark UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0) {
            
            NSDate * date = [[NSDate alloc] init];
            NSString * idTiendasXDia = [EMServiceObjectTiendasXdia tiendaXDiaIDWithDate:date user:self.usuario cuenta:self.cuenta];
            EMTiendasXdia * tiendasXdia = [[EMManagedObject sharedInstance] tiendasXdiaForId:idTiendasXDia];
            tiendasXdia.idTiendasXdia = idTiendasXDia;
            [tiendasXdia addEmTiendasObject:tiendaSeleccionada];
            [[EMManagedObject sharedInstance] saveLocalContext];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}



@end
