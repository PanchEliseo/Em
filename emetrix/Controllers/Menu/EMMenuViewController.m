//
//  EMMenuViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 16/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMMenuViewController.h"
#import "EMMenuTableViewCell.h"
#import "UIImage+Blur.h"
#import "UIViewController+ECSlidingViewController.h"
#import "EMContainerViewController.h"
#import "UIViewController+STViewControllerExtension.h"
#import "JSImagePickerViewController.h"
#import "EMRutaDelDiaViewController.h"
#import "EMLoginViewController.h"
#import "EMPendientesViewController.h"
#import "EMVersion.h"
#import "EMServiceObjectProductos.h"
#import "EMServiceObjectProductosXTienda.h"
#import "NZAlertView.h"
#import "emetrix-Swift.h"
#import "EMListTiendasPedidosViewController.h"
#import "EMServiceObjectCapacitaciones.h"
#import "EMGalleryCapacitacionesViewController.h"
#import "EMSoporteTecnicoViewController.h"



typedef enum
{
    EMMenuPerfil = 0,
    EMMenuRuta,
    EMMenuCambiarCuenta,
    EMMenuPendientes,
    EMMenuSoporteTecnico,
    EMMenuActualizarApp,
    EMMenuActualizarProductos,
    EMMenuSalir
    
} EMMenu;

@interface EMMenuViewController ()<UITableViewDataSource,UITableViewDelegate, JSImagePickerViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray * arrayRows;
@property (strong, nonatomic) NSMutableArray * arrayImagesRows;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwBackground;
@property (strong, nonatomic) UIImage * imageSelected;

@end

@implementation EMMenuViewController

- (NSMutableArray *) arrayRows
{
    if(!_arrayRows)
    {
        _arrayRows = [[NSMutableArray alloc] initWithObjects:@"Ruta del día",@"Cambiar de cuenta",@"Pendientes", @"Soporte técnico",@"Actualizar aplicación",@"Actualizar productos",@"Salir", nil];
    }
    return _arrayRows;
}

- (NSMutableArray *) arrayImagesRows
{
    if(!_arrayImagesRows)
    {
        _arrayImagesRows = [[NSMutableArray alloc] initWithObjects:@"calendar",@"change_user",@"pendientes_clock", @"icon_call_center",@"icon_download",@"icon_product",@"icon_exit", nil];
    }
    return _arrayImagesRows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgVwBackground.image = [self.imgVwBackground.image blurredImage:kEMDefaultBlurred];
    // Do any additional setup after loading the view.
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

#pragma -mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayRows.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMCuenta * cuenta = [self containerTopViewController].cuenta;
    EMMenuTableViewCell * cell;
    if(indexPath.row == EMMenuPerfil)
    {
        NSString * base64Image = [[NSUserDefaults standardUserDefaults] objectForKey:kEMKeyUserDefaultProfileImage];
        
       cell = (EMMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kEMKeyCellMenuAvatarIdentifier];

        cell.lbNameAccount.text = cuenta.nombre;
        if((base64Image && base64Image.length) || self.imageSelected)
        {
//            tiene imagen guardada
            if (self.imageSelected)
            {
                cell.imgVwAvatar.image = self.imageSelected;
            }
            else
            {
                cell.imgVwAvatar.image = [self decodeBase64ToImage:base64Image];
            }
            
        }
        else
        {
            cell.imgVwAvatar.image = [UIImage imageNamed:@"avatar"];
        }
//        verificar si existe alguna imagen guardada
    }
    else
    {
        cell = (EMMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kEMKeyCellMenuOptionIdentifier];
        cell.imgVwAvatar.image = [UIImage imageNamed:[self.arrayImagesRows objectAtIndex:indexPath.row -1]];
        cell.lbNameAccount.text = [self.arrayRows objectAtIndex:indexPath.row -1];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EMMenuPerfil)
    {
        return 200;
    }
    else
    {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case EMMenuRuta:
            if(![[self containerTopViewController].viewControllerContainer isKindOfClass:[EMRutaDelDiaViewController class]])
            {
                [[self containerParentViewController] setTitleText:@"Ruta del día"];
                [self containerParentViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"RutaDelDia"];
            }
            
        break;
        case EMMenuCambiarCuenta:
        {
            NSMutableArray * arrayCuentas = [[NSMutableArray alloc] init];
            for(EMCuenta * cuenta in [[self containerTopViewController].user.emCuentas allObjects])
            {
                [arrayCuentas addObject:cuenta.nombre];
            }
            [self presentActionSheetWithButtonsTitle:arrayCuentas];
        }
            
        
        break;
        case EMMenuPendientes:
        {
             if(![[self containerTopViewController].viewControllerContainer isKindOfClass:[EMPendientesViewController class]])
             {
                 [self containerTopViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"Pendientes"];
                 [[self containerTopViewController] setTitleText:@"Pendientes"];
                 
                 
             }
        }
            
        break;
            
        /*case EMMenuCapacitaciones:
        {

            
            EMServiceObjectCapacitaciones * capacitaciones = [[EMServiceObjectCapacitaciones alloc] initWithUser:[self containerTopViewController].user andAccount:[self containerTopViewController].cuenta];
            [capacitaciones startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
            {
//                NSLog(@"Termino la descarga de capacitaciones");
                if(![[self containerTopViewController].viewControllerContainer isKindOfClass:[EMGalleryCapacitacionesViewController class]])
                {
                    [self containerTopViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"Capacitaciones"];
                    [[self containerTopViewController] setTitleText:@"Capacitaciones"];
                }
            }];
        }
            
            break;*/
        case EMMenuSoporteTecnico:
        {
            if(![[self containerTopViewController].viewControllerContainer isKindOfClass:[EMSoporteTecnicoViewController class]])
            {
                [self containerTopViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"SoporteTecnico"];
                [[self containerTopViewController] setTitleText:@"Soporte técnico"];
            }

        }
            
            break;
        case EMMenuActualizarApp:
            
        break;
        case EMMenuActualizarProductos:
        {
            [SwiftSpinner show:@"Actualizando productos" animated:YES];
            EMCuenta * cuenta = [self containerTopViewController].cuenta;
            [self downloadProductsWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
             {
                 if (!error)
                 {
                     [self downloadProductsXTiendaWithCuenta:cuenta completionBlock:^(BOOL success, NSError *error)
                     {
                         if (error)
                         {
                             [self showAlertForError:error];
                         }
                         else
                         {
                             [SwiftSpinner hide:nil];
                             NZAlertView * alert = [[NZAlertView alloc] initWithStyle: NZAlertStyleSuccess title:@"¡Correcto!"message:@"Todos tus productos se han actualizado correctamente"];
                             [alert show];
                         }
                        
                     }];
                 }
                 else
                 {
                     [self showAlertForError:error];
                 }
                 
             }];

        }
            
        break;
        case EMMenuSalir:
            if(![[self containerTopViewController].viewControllerContainer isKindOfClass:[EMLoginViewController class]])
            {
                [self containerTopViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"Login"];
                [self deleteVersionesAllCuenta];
                [[EMManagedObject sharedInstance] saveLocalContext];
            }
            
        break;
    }
    if(indexPath.row != EMMenuPerfil)
    {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

#pragma -mark UIGestureRecognizer

- (IBAction)didPressChangeImage:(UITapGestureRecognizer *)sender
{
    JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}


#pragma -mark JSImagePickerViewController


- (void)imagePickerDidSelectImage:(UIImage *)image
{
    if(image)
    {
        self.imageSelected = image;
        [self.tableView reloadData];
        
    }
}

- (void)imagePickerDidClose
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        [[NSUserDefaults standardUserDefaults] setObject:[self encodeToBase64String:self.imageSelected] forKey:kEMKeyUserDefaultProfileImage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            [self.tableView reloadData];
        });
    });
    
}

- (EMContainerViewController *) containerTopViewController
{
    return ((EMContainerViewController *)[((UINavigationController *)[self.slidingViewController topViewController]).viewControllers objectAtIndex:0]);
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
                
                [self containerParentViewController].cuenta = cuenta;
                EMCuenta * cuentaActive = [[EMManagedObject sharedInstance] accountActive];
                cuentaActive.activa = [NSNumber numberWithBool:NO];
                cuenta.activa = [NSNumber numberWithBool:YES];
                [[EMManagedObject sharedInstance] saveLocalContext];
                [self containerTopViewController].viewControllerContainer = [self viewControllerForStoryBoardName:@"RutaDelDia"];
                [[self containerTopViewController] setTitleText:@"Ruta del Día"];
                [self.slidingViewController resetTopViewAnimated:YES];
                
                
                break;
            }
        }
        
        
    }
    
}


#pragma -mark DownloadProducts
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

#pragma -mark NZAlertView

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

}

@end
