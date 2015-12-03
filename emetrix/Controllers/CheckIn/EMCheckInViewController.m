//
//  EMCheckInViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 11/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMCheckInViewController.h"
#import "emetrix-Swift.h"
#import "EMSondeoLocationDelegate.h"
#import "NZAlertView.h"
#import <MapKit/MapKit.h>
#import "EMPendiente.h"
#import "NSObject+EMObjectExtension.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import "JSImagePickerViewController.h"
#import "EMStatusPhone.h"

#define d2r (M_PI / 180.0)

@interface EMCheckInViewController ()<MKMapViewDelegate, JSImagePickerViewControllerDelegate>
@property (strong, nonatomic) EMSondeoLocationDelegate * locationDelegate;
@property (strong, nonatomic) CLLocation * location;
@property (strong, nonatomic) CLLocation * locationStore;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL dismiss;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCheck;


@end

@implementation EMCheckInViewController

- (CLLocation *)locationStore
{
    if (!_locationStore)
    {
        _locationStore = [[CLLocation alloc] initWithLatitude:[self.tienda.latitud doubleValue] longitude:[self.tienda.longitud doubleValue]];
    }
    return _locationStore;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLocation:) name:kEMKeyNotificationLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedErrorLocation:) name:kEMKeyNotificationErrorLocation object:nil];

    if ([self.tienda.checkIn boolValue])
    {
        self.title = NSLocalizedString(@"EMTitleCheckOut", nil);
        [self.btnCheck setTitle:NSLocalizedString(@"EMTitleCheckOut", nil)];
    }
    else
    {
        self.title = NSLocalizedString(@"EMTitleCheckIn", nil);
        [self.btnCheck setTitle:NSLocalizedString(@"EMTitleCheckIn", nil)];
    }

    
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.centerCoordinate = self.locationStore.coordinate;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.locationStore.coordinate;
    point.title = self.tienda.nombre;
    MKCoordinateRegion regionStore = MKCoordinateRegionMakeWithDistance(self.locationStore.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:regionStore] animated:YES];
    
    [self.mapView addAnnotation:point];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do attle preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didiPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressCheckIn:(id)sender
{
    if(self.location)
    {
        if ([self.tienda.checkGPS boolValue])
        {
//#warning Descomentar y comentar
            if ([self.location distanceFromLocation:self.locationStore] > [self.tienda.rangoGPS integerValue])
//            if ([self.location distanceFromLocation:self.locationStore] > 10000000000)
            {
                
                NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"No se encuentra a una distancía razonable para hacer %@",([self.tienda.checkIn boolValue])?NSLocalizedString(@"EMTitleCheckOut", nil):NSLocalizedString(@"EMTitleCheckIn", nil)]];
                [alert show];
                
            }
            else
            {
                //  mandar servicio check in
                JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
                imagePicker.delegate = self;
                imagePicker.showCamera = YES;
                [imagePicker showImagePickerInController:self animated:YES];
            }
            
        }
        else
        {
            //  mandar servicio check in
            JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
            imagePicker.delegate = self;
            imagePicker.showCamera = YES;
            [imagePicker showImagePickerInController:self animated:YES];
        }

    }
    else
    {
        [SwiftSpinner show:@"Obteniendo lozalización" animated:YES];
        self.locationDelegate = [[EMSondeoLocationDelegate alloc] init];
        [self.locationDelegate getCurrentLocation];
    }
}

- (void)receivedLocation:(NSNotification *)notification
{
    [SwiftSpinner hide:nil];
    NSDictionary * dictionary = notification.object;
    NSString * location = [dictionary objectForKey:kEMQuestionTypeGPS];
    NSArray * array = [location componentsSeparatedByString:kEMSeparatorLocalization];
    self.location = [[CLLocation alloc] initWithLatitude:[[array objectAtIndex:0] doubleValue] longitude:[[array objectAtIndex:1] doubleValue]];
    if ([self.tienda.checkGPS boolValue])
    {
//#warning Descomentar y comentar
                    if ([self.location distanceFromLocation:self.locationStore] > [self.tienda.rangoGPS integerValue])
//        if ([self.location distanceFromLocation:self.locationStore] > 10000000000)
        {
            
            NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"No se encuentra a una distancía razonable para hacer %@",([self.tienda.checkIn boolValue])?NSLocalizedString(@"EMTitleCheckOut", nil):NSLocalizedString(@"EMTitleCheckIn", nil)]];
            [alert show];
            
        }
        else
        {
            //  mandar servicio check in
            JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
            imagePicker.delegate = self;
            imagePicker.showCamera = YES;
            [imagePicker showImagePickerInController:self animated:YES];
        }
        
    }
    else
    {
        //  mandar servicio check in
        JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
        imagePicker.delegate = self;
        imagePicker.showCamera = YES;
        [imagePicker showImagePickerInController:self animated:YES];
    }

    
    
}

- (void)receivedErrorLocation:(NSNotification *)notification
{
    [SwiftSpinner hide:nil];
}



- (double) haversine_kmWithCoordinate:(CLLocation *)tienda location:(CLLocation *) location
{
//    double lat1, double long1, double lat2, double long2
    double lat1 = tienda.coordinate.latitude;
    double long1 = tienda.coordinate.longitude;
    double lat2 = location.coordinate.latitude;
    double long2 = location.coordinate.longitude;
    
    
    double dlong = (long2 - long1) * d2r;
    double dlat = (lat2 - lat1) * d2r;
    double a = pow(sin(dlat/2.0), 2) + cos(lat1*d2r) * cos(lat2*d2r) * pow(sin(dlong/2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = 6367 * c;
    
    return d;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
}

#pragma -mark JSImagePickerViewControllerDelegate
- (void)imagePickerDidSelectImage:(UIImage *)image
{
    EMPendiente * pendiente = [[EMManagedObject sharedInstance] newPendiente];
    //        Creamos el pendiente del sondeo
    pendiente.date = [[NSDate alloc] init];
    pendiente.idPendiente = [EMCheckInViewController stringServiceFromDate:pendiente.date];
    pendiente.determinanteGPS = self.tienda.idTienda;
    pendiente.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
    pendiente.emCuenta = [self containerParentViewController].cuenta;
    pendiente.latitud = [NSNumber numberWithDouble:self.location.coordinate.latitude];
    pendiente.longitud = [NSNumber numberWithDouble:self.location.coordinate.longitude];
    pendiente.cadenaPendiente = [self encodeToBase64String:image];
    if ([self.tienda.checkIn boolValue])
    {
        self.tienda.checkOut = [NSNumber numberWithBool:YES];
        self.tienda.estatus = [NSString stringWithFormat:@"%u",EMStatusTypeVisited];
        pendiente.tipo = [NSNumber numberWithInteger:EMPendienteTypeCheckOut];

    }
    else
    {
        self.tienda.estatus = [NSString stringWithFormat:@"%u",EMStatusTypeInVisit];
        self.tienda.checkIn = [NSNumber numberWithBool:YES];
        pendiente.tipo = [NSNumber numberWithInteger:EMPendienteTypeCheckIn];

    }
//    logs
    if ([self.tienda.checkIn boolValue])
    {
        [self pendienteLogMovilForTag:kEMPendienteTagCheckOut];
    }
    else
    {
        [self pendienteLogMovilForTag:kEMPendienteTagCheckIn];
    }
    if ([self.tienda.checkOut boolValue])
    {
        self.tienda.checkIn = [NSNumber numberWithBool:NO];
        self.tienda.checkOut = [NSNumber numberWithBool:NO];
    }
    [[EMManagedObject sharedInstance] saveLocalContext];
    [[self containerParentViewController] sendPendientes];
    self.dismiss = YES;
    
    
}

- (void)imagePickerDidClose
{
    if (self.dismiss)
    {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}


@end
