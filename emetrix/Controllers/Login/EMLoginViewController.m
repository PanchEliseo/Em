//
//  EMLoginViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 13/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMLoginViewController.h"
#import "UIImage+Blur.h"
#import "NZAlertView.h"
#import "EMServiceObjectLogin.h"
#import "EMContainerViewController.h"
#import "UIViewController+STViewControllerExtension.h"
#import "emetrix-Swift.h"
#import "EMServiceObjectProductos.h"
#import "EMServiceObjectTiendas.h"
#import "EMServiceObjectSondeos.h"
#import "EMServiceObjectTiendasXdia.h"
#import "NSObject+EMObjectExtension.h"
#import "EMServiceObjectProductosXTienda.h"
#import "EMServiceObjectSondeosXTienda.h"
#import "EMServiceObjectMensajesConfigurables.h"
#import "EMServiceObjectSondeosRespuestas.h"
#import "EMVersion.h"
#import "EMRutaDelDiaViewController.h"
#import "EMStatusPhone.h"
#import "EMServiceObjectValidaApp.h"


@interface EMLoginViewController ()<UITextFieldDelegate, UIActionSheetDelegate>
{
    EMServiceObjectValidaApp * validaApp;
    BOOL isNeedUpdate;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgVwTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFldUser;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPassword;
@property (nonatomic) NSInteger indexAccount;
@property (nonatomic) BOOL isAlertShow;

@end

@implementation EMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblVersion.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [self.view sendSubviewToBack:self.imgVwTitle];
//    self.imgVwTitle.image = [self.imgVwTitle.image blurredImage:kEMDefaultBlurred];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    validaApp = [[EMServiceObjectValidaApp alloc] init];
    [validaApp startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error) {
        
        if ([validaApp.response isEqualToString:@"OK"] == NO) {
            
            NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"Atención" message:@"Hay una nueva versión disponible"];
            alert.delegate = self;
            [alert showWithCompletion:^{
                
                NSURL *url = [NSURL URLWithString:validaApp.response];
                
                if (![[UIApplication sharedApplication] openURL:url]) {
                    NSLog(@"%@%@",@"Failed to open url:",[url description]);
                }
                
            }];
        }
        else {
            NSDate * dateActually = [NSDate dateFromString:[NSString stringFromDate:[[NSDate alloc] init]]];
            EMCuenta * cuenta = [[EMManagedObject sharedInstance] accountActive];
            if(cuenta && [cuenta.idCuenta integerValue] && [cuenta.emUser.fecha_vencimiento compare:dateActually] == NSOrderedSame)
            {
                //        el usuario puede pasar
                [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerDownload", nil) animated:YES];
                [self containerParentViewController].cuenta = cuenta;
                [self containerParentViewController].user = cuenta.emUser;
                [self downloadServices];
            }
            else
            {
                [self deleteVersionesAllCuenta];
            }
        }
        
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.indexAccount = 0;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma -mark UIButtonActions

- (IBAction)didPressLogin
{
    if ([validaApp.response isEqualToString:@"OK"] == NO) {
        
        NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"Atención" message:@"Hay una nueva versión disponible"];
        alert.delegate = self;
        [alert showWithCompletion:^{
            
            NSURL *url = [NSURL URLWithString:validaApp.response];
            
            if (![[UIApplication sharedApplication] openURL:url]) {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
            
        }];
    }
    else {
        
        if(self.txtFldPassword.text.length && self.txtFldUser.text.length)
        {
            [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerLogin", nil) animated:YES];
            if([[self containerParentViewController].currentReachability isReachable])
            {
                EMServiceObjectLogin * loginService = [[EMServiceObjectLogin alloc] initWithUsername:self.txtFldUser.text andPassword:self.txtFldPassword.text];
                [loginService startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
                 {
                     
                     if(!error && successDownload)
                     {
                         [self containerParentViewController].user = loginService.user;
                         NSMutableArray * arrayCuentas = [[NSMutableArray alloc] init];
                         for(EMCuenta * cuenta in loginService.user.emCuentas)
                         {
                             [arrayCuentas addObject:cuenta.nombre];
                             if (loginService.user.emCuentas.count == 1)
                             {
                                 [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerDownload", nil) animated:YES];
                                 [self containerParentViewController].cuenta = cuenta;
                                 EMCuenta * cuentaActive = [[EMManagedObject sharedInstance] accountActive];
                                 cuentaActive.activa = [NSNumber numberWithBool:NO];
                                 cuenta.activa = [NSNumber numberWithBool:YES];
                                 [[EMManagedObject sharedInstance] saveLocalContext];
                                 [self pendienteLogMovilForTag:kEMPendienteTagLogin];
                                 [[self containerParentViewController] sendPendientes];
                                 [self downloadServices];
                                 break;
                                 
                             }
                             else
                             {
                                 [SwiftSpinner hide:nil];
                                 
                             }
                         }
                         if (loginService.user.emCuentas.count != 1)
                         {
                             [self presentActionSheetWithButtonsTitle:arrayCuentas];
                             
                         }
                         
                     }
                     else
                     {
                         [SwiftSpinner hide:^
                          {
                              NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo title:@"Lo sentimos" message:[NSString stringWithFormat:@"Ocurrio un error: %@",error.localizedDescription]];
                              [alert show];
                              
                          }];
                         
                     }
                     
                     
                 }];
                
            }
            else
            {
                EMUser * user = [[EMManagedObject sharedInstance] userWithUsername:self.txtFldUser.text password:self.txtFldPassword.text];
                if (user && user.usuario.length)
                {
                    
                    NSDate * dateActually = [NSDate dateFromString:[NSString stringFromDate:[[NSDate alloc] init]]];
                    if([user.fecha_vencimiento compare:dateActually] == NSOrderedSame)
                    {
                        [SwiftSpinner hide:nil];
                        [self containerParentViewController].user = user;
                        NSMutableArray * arrayCuentas = [[NSMutableArray alloc] init];
                        for(EMCuenta * cuenta in user.emCuentas)
                        {
                            [arrayCuentas addObject:cuenta.nombre];
                            if (user.emCuentas.count == 1)
                            {
                                [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerDownload", nil) animated:YES];
                                [self containerParentViewController].cuenta = cuenta;
                                EMCuenta * cuentaActive = [[EMManagedObject sharedInstance] accountActive];
                                cuentaActive.activa = [NSNumber numberWithBool:NO];
                                cuenta.activa = [NSNumber numberWithBool:YES];
                                [[EMManagedObject sharedInstance] saveLocalContext];
                                [self pendienteLogMovilForTag:kEMPendienteTagLogin];
                                [[self containerParentViewController] sendPendientes];
                                [self downloadServices];
                                break;
                                
                            }
                            else
                            {
                                [SwiftSpinner hide:nil];
                                
                            }
                            
                        }
                        if (user.emCuentas.count != 1)
                        {
                            [self presentActionSheetWithButtonsTitle:arrayCuentas];
                        }
                    }
                    else
                    {
                        [SwiftSpinner hide:^
                         {
                             NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:@"Su usuario a caducado. Por favor inicie sesión vía WI-FI o 3G para actualizar la información"];
                             alert.alertDuration = 10.0;
                             [alert show];
                         }];
                        
                    }
                    
                    
                }
                else
                {
                    [SwiftSpinner hide:^
                     {
                         NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:@"Los datos de acceso son incorrectos. Si el problema persiste por favor inicie sesión vía Wi-FI o 3G"];
                         alert.alertDuration = 10.0;
                         [alert show];
                     }];
                    
                    
                }
            }
        }
        else
        {
            NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:NSLocalizedString(@"EMTitleMessageError", nil) message:NSLocalizedString(@"EMTitleMessagePasswordOrUserNil", nil)];
            [alert show];
        }
    }
}

#pragma -mark UITapGestureAction

- (IBAction)didPressImage:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


#pragma -mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
        for(EMCuenta * cuenta in [self containerParentViewController].user.emCuentas)
        {
            if([cuenta.nombre isEqualToString:title])
            {
                [SwiftSpinner show:NSLocalizedString(@"EMTitleSpinnerDownload", nil) animated:YES];
                [self containerParentViewController].cuenta = cuenta;
                EMCuenta * cuentaActive = [[EMManagedObject sharedInstance] accountActive];
                cuentaActive.activa = [NSNumber numberWithBool:NO];
                cuenta.activa = [NSNumber numberWithBool:YES];
                [[EMManagedObject sharedInstance] saveLocalContext];
                [self pendienteLogMovilForTag:kEMPendienteTagLogin];
                [[self containerParentViewController] sendPendientes];
                [self downloadServices];
                break;
            }
        }
        
        
    }

}

#pragma -mark Download Services


- (void) downloadServices
{
    if (self.indexAccount < [[self containerParentViewController].user.emCuentas allObjects].count)
    {
        EMCuenta * cuenta = [[[self containerParentViewController].user.emCuentas allObjects] objectAtIndex:self.indexAccount];
        EMVersion * version;
        
        if (cuenta.emVersion)
        {
            version = cuenta.emVersion;

        }
        else
        {
            version = [[EMManagedObject sharedInstance] newVersion];
            version.emCuenta = cuenta;
            [[EMManagedObject sharedInstance] saveLocalContext];
        }
        
        //            ya se descargaron servicios antes
        if ([version.tiendas integerValue] != [cuenta.tiendas integerValue] || [version.tiendasXDia integerValue] != [cuenta.tiendas integerValue])
        {
            //                la version de tiendas es diferente;
            [self downloadTiendasWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
             {
                 
                 if (!error)
                 {
                     [self downloadTiendasXDiaWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
                      {
                          
                          if (!error)
                          {
                              version.tiendas = cuenta.tiendas;
                              version.tiendasXDia = cuenta.tiendasXdia;
                              [[EMManagedObject sharedInstance] saveLocalContext];
                              [self verifyServiceDownloadWithError:error withAccount:cuenta isDownloadComplete:NO];
                          }
                          else
                          {
                              [self showAlertForError:error];
                          }
                          
                      }];
                 }
                 else
                 {
                     [self showAlertForError:error];
                 }
             }];
        }
        else if([version.productos integerValue] != [cuenta.productos integerValue] || [version.productosXTienda integerValue] != [cuenta.productosXTienda integerValue])
        {
            [self downloadProductsWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
             {
                 if (!error)
                 {
                     [self downloadProductsXTiendaWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error) {
                         if (!error)
                         {
                             version.productosXTienda = cuenta.productosXTienda;
                             version.productos = cuenta.productos;
                             [[EMManagedObject sharedInstance] saveLocalContext];
                             [self verifyServiceDownloadWithError:error withAccount:cuenta isDownloadComplete:NO];
                         }
                         else
                         {
                             [self showAlertForError:error];
                         }
                     }];
                 }
                 else
                 {
                     [self showAlertForError:error];
                 }
                 
             }];
            
        }
        else if ([version.sondeos integerValue] != [cuenta.sondeos integerValue] || [version.sondeosXTienda integerValue] != [cuenta.sondeosXTienda integerValue])
        {

            
            [self downloadSondeosWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
             {
                 if (!error)
                 {
                     [self downloadSondeosXTiendaWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error) {
                         if (!error)
                         {
                             version.sondeos = cuenta.sondeos;
                             version.sondeosXTienda = cuenta.sondeosXTienda;
                            [[EMManagedObject sharedInstance] saveLocalContext];
                            [[EMManagedObject sharedInstance] deleteAllMensajesForCuenta:cuenta];
                            
                             EMServiceObjectMensajesConfigurables * mensajesConfigurables = [[EMServiceObjectMensajesConfigurables alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
                            [mensajesConfigurables startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
                            {
                                [EMRutaDelDiaViewController sendMessageNotification];
                                [[EMManagedObject sharedInstance] saveLocalContext];
                                
                                //Se validan las descargas online de respuestas de sondeos
                                if ([cuenta.descargaSondeosOnline boolValue] == NO)
                                {
                                    EMServiceObjectSondeosRespuestas * sondeosRes = [[EMServiceObjectSondeosRespuestas alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
                                    [sondeosRes startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
                                     {
                                         [self verifyServiceDownloadWithError:error withAccount:cuenta isDownloadComplete:NO];
                                    
                                     }];
                                }
                                else
                                {
                                    [self verifyServiceDownloadWithError:error withAccount:cuenta isDownloadComplete:NO];
                                }
                                      
                            }];

                             
                         }
                         else
                         {
                             [self showAlertForError:error];
                         }
                     }];
                 }
                 else
                 {
                     [self showAlertForError:error];
                 }
                 
             }];
        }
        else
        {
            self.indexAccount++;
            [self downloadServices];
        }

    }
    else
    {
        [self verifyServiceDownloadWithError:nil withAccount:[self containerParentViewController].cuenta isDownloadComplete:YES];
    }
    
}


- (void)verifyServiceDownloadWithError:(NSError *)error withAccount:(EMCuenta *)cuenta isDownloadComplete:(BOOL) isDownloadComplete
{
    EMVersion * version = cuenta.emVersion;
    if([version.tiendas integerValue] == [cuenta.tiendas integerValue] && [version.tiendasXDia integerValue] == [cuenta.tiendasXdia integerValue] && [version.productos integerValue] == [cuenta.productos integerValue] && [version.productosXTienda integerValue] == [cuenta.productosXTienda integerValue] && [version.sondeos integerValue] == [cuenta.sondeos integerValue] && [version.sondeosXTienda integerValue] == [cuenta.sondeosXTienda integerValue] && [cuenta.idCuenta integerValue] == [[self containerParentViewController].cuenta.idCuenta integerValue] && isDownloadComplete)
    {
        [SwiftSpinner hide:nil];
        [[self containerParentViewController] setTitleText:@"Ruta del día"];
        [self containerParentViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"RutaDelDia"];

    }
    else if (error)
    {
        [self showAlertForError:error];
    }
    else
    {
//        falta alguna versión
        [self downloadServices];
    }
    
}


- (void)showAlertForError:(NSError *) error
{
    [SwiftSpinner hide:^
     {
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
          {
              NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"Ocurrio un error: %@",error.localizedDescription]];
              [alert show];
              

              
          }];
     }];
    self.indexAccount = 0;
}

- (void) downloadProductsWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectProductos * serviceProductos = [[EMServiceObjectProductos alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    [serviceProductos startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload,error);
     }];
}

- (void) downloadProductsXTiendaWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectProductosXTienda * serviceProductosXTienda = [[EMServiceObjectProductosXTienda alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    
    [serviceProductosXTienda startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload,error);

     }];
}

- (void) downloadSondeosWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectSondeos * serviceSondeos = [[EMServiceObjectSondeos alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    [serviceSondeos startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload,error);

     }];
}

- (void) downloadSondeosXTiendaWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectSondeosXTienda * serviceSondeosXTienda = [[EMServiceObjectSondeosXTienda alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    [serviceSondeosXTienda startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload,error);
     }];

    
}

- (void) downloadTiendasWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectTiendas * serviceTiendas = [[EMServiceObjectTiendas alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    [serviceTiendas startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload, error);
     }];
}

- (void) downloadTiendasXDiaWithCuenta:(EMCuenta *) cuenta completionBlock:(void (^) (BOOL success, NSError * error))block
{
    EMServiceObjectTiendasXdia * serviceTiendasXdia = [[EMServiceObjectTiendasXdia alloc] initWithUser:[self containerParentViewController].user andAccount:cuenta];
    [serviceTiendasXdia startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
     {
         block(successDownload, error);
     }];
}

@end
