//
//  UIViewController+STViewControllerExtension.m
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz (Vendor) on 11/12/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "EMStatusPhone.h"
#import "EMVersion.h"

@implementation UIViewController (STViewControllerExtension)


- (void) addTitleView
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0 ,0 ,100,30)];
    [button setTitle:@"Yujui!" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [self ss_fontWithSize:26];
    button.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    button.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem * title = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (self.navigationItem.leftBarButtonItem != nil)
    {
        UIBarButtonItem * item = self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:item,title, nil];
    }
    else
    {
        self.navigationItem.titleView = button;

    }
}


- (UIFont *) ss_fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"BubblegumSans-Regular" size:size];
}

- (void)showAlertViewWithMessage:(NSString *) message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (UIViewController *) viewControllerForStoryBoardName:(NSString *) storyBoardName
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    return [story instantiateInitialViewController];
}

- (UIViewController *) viewControllerForStoryBoardName:(NSString *) storyBoardName vcIdentifier:(NSString *) identifier
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    return [story instantiateViewControllerWithIdentifier:identifier];
}

- (UIBarButtonItem *) addLeftBarButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIImage *background = [UIImage imageNamed:@"icon_menu"];
    [button setBackgroundImage:background forState:UIControlStateNormal];

    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    barButton.tintColor = [UIColor blueColor];
    
    return barButton;
}

- (UIBarButtonItem *) addRightBarButton{
     UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     UIImage *background = [UIImage imageNamed:@"icon_privacy"];
     [button setBackgroundImage:background forState:UIControlStateNormal];
     
//     [button addTarget:self action:@selector(presentPrivacyPolicy) forControlEvents:UIControlEventTouchUpInside];
    
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
     barButton.tintColor = [UIColor blueColor];
     
     return barButton;
}

- (CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text withWidth: (float) width
{
     CGSize maximumLabelSize     = CGSizeMake(width, FLT_MAX);
      NSRange range = NSMakeRange(0, [label.attributedText length]);
     NSDictionary *attributes = [label.attributedText attributesAtIndex:0 effectiveRange:&range];

     CGSize expectedLabelSize    = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
     
     return expectedLabelSize.height;
}


- (BOOL) validEmail:(NSString*) emailString {
     
     if([emailString length]==0){
          return NO;
     }
     
     NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
     
     NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
     NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
     
     if (regExMatches == 0) {
          return NO;
     } else {
          return YES;
     }
}

- (NSString *)encodeToBase64String:(UIImage *)image
{
     return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
     NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
     return [UIImage imageWithData:data];
}

- (void)presentActionSheetWithButtonsTitle:(NSArray *) arrayButtonsTitle
{
    UIActionSheet *popup;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popup = [[UIActionSheet alloc] initWithTitle:@"Selecciona una cuenta:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    }
    else
    {
        popup = [[UIActionSheet alloc] initWithTitle:@"Selecciona una cuenta:" delegate:self cancelButtonTitle:NSLocalizedString(@"EMTitleButtonCancel", nil) destructiveButtonTitle:nil otherButtonTitles:nil];
    }
    
    popup.tag = 1;
    
    for (NSString *title in arrayButtonsTitle)
    {
        [popup addButtonWithTitle:title];
    }
    
    [popup showInView:self.view];
}

- (EMContainerViewController *) containerParentViewController
{
    return ((EMContainerViewController *)[((UINavigationController *)self.slidingViewController.topViewController).viewControllers objectAtIndex:0]);
}

- (EMPendiente *) pendienteLogMovilForTag:(NSString *)tag
{
    //    logs
    EMPendiente * pendienteLog = [[EMManagedObject sharedInstance] newPendiente];
    pendienteLog.date = [[NSDate alloc] init];
    pendienteLog.emCuenta = [self containerParentViewController].cuenta;
    pendienteLog.tag = kEMPendienteTagCheckIn;
    [[EMStatusPhone currentPhone] updateReachableWithCurrentReachability:[self containerParentViewController].currentReachability];
    pendienteLog.conexion = [EMStatusPhone currentPhone].stateReachability;
    pendienteLog.hotspot = [EMStatusPhone currentPhone].stateHotSpotString;
    pendienteLog.bluetooth = [EMStatusPhone currentPhone].stateBluetoothString;
    pendienteLog.brillo = [EMStatusPhone currentPhone].stateBrightness;
    pendienteLog.bateria = [EMStatusPhone currentPhone].stateBatteryString;
    pendienteLog.gps = [EMStatusPhone currentPhone].stateLocation;
    pendienteLog.datos = [EMStatusPhone currentPhone].stateDataUsage;
    pendienteLog.tipo = [NSNumber numberWithInt:EMPendienteTypeLogsMovil];
    pendienteLog.estatus = [NSNumber numberWithInt:EMPendienteStatePrepared];
    [[EMManagedObject sharedInstance] saveLocalContext];
    
    return pendienteLog;
}

- (void)deleteVersionesAllCuenta
{
    //       caduco
    for (EMCuenta * cuenta in [[EMManagedObject sharedInstance] mutableArrayCuentas])
    {
        cuenta.activa = [NSNumber numberWithBool:NO];
        cuenta.emVersion.tiendas = [NSNumber numberWithInt:0];
        cuenta.emVersion.tiendasXDia = [NSNumber numberWithInt:0];
        cuenta.emVersion.productos =  [NSNumber numberWithInt:0];
        cuenta.emVersion.productosXTienda =  [NSNumber numberWithInt:0];
        cuenta.emVersion.sondeos =  [NSNumber numberWithInt:0];
        cuenta.emVersion.sondeosXTienda =  [NSNumber numberWithInt:0];
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
}



@end
