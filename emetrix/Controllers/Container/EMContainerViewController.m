//
//  SSSurveyContainerViewController.m
//  survey
//
//  Created by Carlos Alberto Molina Saenz (Vendor) on 1/21/15.
//  Copyright (c) 2015 Carlos Alberto Molina Saenz (Vendor). All rights reserved.
//

#import "EMContainerViewController.h"
#import "UIViewController+STViewControllerExtension.h"
#import "UIViewController+ECSlidingViewController.h"
#import "EMLoginViewController.h"
#import "EMTitleView.h"
#import "EMSondeoLocationDelegate.h"
#import "EMPendiente.h"
#import "EMPendiente+EMExtensions.h"
#import "NSObject+EMObjectExtension.h"
#import "TTCounterLabel.h"
#import "EMStatusPhone.h"
#import "EMServiceObjectFecha.h"


@interface EMContainerViewController ()


@property (strong, nonatomic) NSMutableArray * arrayPendientesToSend;
@property (strong, nonatomic) EMSondeoLocationDelegate * locationDelegate;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) NSTimer * timerDate;

@end

@implementation EMContainerViewController
@synthesize viewControllerContainer = _viewControllerContainer;

- (EMSondeoLocationDelegate *)locationDelegate
{
    _locationDelegate = [[EMSondeoLocationDelegate alloc] init];
    return _locationDelegate;
}

-(UIViewController *) viewControllerContainer
{
    return _viewControllerContainer;
}

- (void)setViewControllerContainer:(UIViewController *)viewControllerContainer
{
    if([viewControllerContainer isKindOfClass:[EMLoginViewController class]])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if ([_viewControllerContainer isKindOfClass:[EMLoginViewController class]] && ![viewControllerContainer isKindOfClass:[EMLoginViewController class]])
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (viewControllerContainer != _viewControllerContainer)
    {
        [_viewControllerContainer.view removeFromSuperview];
        [_viewControllerContainer removeFromParentViewController];
        
        
    }
    
    viewControllerContainer.view.frame = self.viewContainer.frame;
    [self.viewContainer addSubview:viewControllerContainer.view];
    [viewControllerContainer willMoveToParentViewController:self];
    _viewControllerContainer = viewControllerContainer;
    [viewControllerContainer didMoveToParentViewController:self];
    [self addChildViewController:viewControllerContainer];
    self.viewContainer.hidden = NO;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    self.currentReachability = [SPReachability reachabilityForInternetConnection];
    [self.currentReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChanged:) name:UIApplicationSignificantTimeChangeNotification object:nil];

//    carga una sombra para el menu
    self.navigationController.view.layer.shadowOpacity = 0.9f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewControllerContainer = [self viewControllerForStoryBoardName:@"Login"];
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping;
    
    self.navigationItem.leftBarButtonItem = [self addLeftBarButton];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kEMDefaultTimeSendPendientes target:self selector:@selector(sendPendientes) userInfo:nil repeats:YES];
    
    [self.timer fire];
    [self sendPendientes];
    self.timerDate = [NSTimer scheduledTimerWithTimeInterval:kEMDefaultTimeUpdateDate target:self selector:@selector(changeDateUserDefault) userInfo:nil repeats:YES];
    [self.timerDate fire];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[EMStatusPhone currentPhone] updateBluetooth];
    [[EMStatusPhone currentPhone] updateBrightness];
    [[EMStatusPhone currentPhone] updateBaterryLevel];
    [[EMStatusPhone currentPhone] updateLocation];
    [[EMStatusPhone currentPhone] updateHospot];
    [[EMStatusPhone currentPhone] updateUsageData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitleText:(NSString *) title
{
    UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    view.text = title;
    view.textColor = [UIColor whiteColor];
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.navigationItem.titleView = view;
    
}


- (void)openMenu
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered)
    {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    }
    else
    {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (void)sendPendientes
{
    self.arrayPendientesToSend = [[EMManagedObject sharedInstance] mutableArrayPendientes];
    int i = 0;
    for (int j = 0; j< self.arrayPendientesToSend.count; j++)
    {
        EMPendiente * pendiente = [self.arrayPendientesToSend objectAtIndex:j];
        
        switch ([pendiente.estatus intValue])
        {
            case EMPendienteStateWithOutLocation:
            {
                [[NSNotificationCenter defaultCenter] addObserver:pendiente
                                                         selector:@selector(receiveLocation:)
                                                             name:kEMKeyNotificationLocation
                                                           object:nil];
                [self.locationDelegate getCurrentLocation];
                
                break;
            }
            case EMPendienteStatePrepared:
            {
                [pendiente sendPendiente];
                break;
            }
            case EMPendienteStateSend:
            {
                NSDate * datePendiente = [NSDate dateServiceFromString:pendiente.idPendiente];
                datePendiente = [NSDate dateFromString:[NSDate stringFromDate:datePendiente]];
                NSDate * dateActually = [NSDate dateFromString:[NSDate stringFromDate:[NSDate date]]];                
                if([datePendiente compare:dateActually] == NSOrderedAscending)
                {
                    [[EMManagedObject sharedInstance] deleteEntity:pendiente];
                    [[EMManagedObject sharedInstance] saveLocalContext];
                }
                break;
            }
            case EMPendienteStateSending:
            {
                NSTimeInterval timeInterval = [[[NSDate alloc] init] timeIntervalSinceDate: pendiente.dateSending];
                if (timeInterval > 600)
                {
                    //Cambiamos el estado del pendiente ya que lleva 10 min en el estado de enviando
                    pendiente.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                    [pendiente sendPendiente];
                }
                break;
            }
            default:
                break;
        }
        i++;

    }
    
}

- (void)changeDateUserDefault
{
    if (self.currentReachability.isReachable)
    {
        EMServiceObjectFecha * serviceFecha = [[EMServiceObjectFecha alloc] init];
        [serviceFecha startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"date server %@",[EMContainerViewController stringPrintFromDate:[defaults objectForKey:kEMKeyUserDateOld]]);
            [self timeChanged:nil];
        }];
    }
    else
    {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate * updateDate = [userDefaults objectForKey:kEMKeyUserDateOld];
        updateDate = [updateDate dateByAddingTimeInterval:kEMDefaultTimeUpdateDate];
        [userDefaults setObject:updateDate forKey:kEMKeyUserDateOld];
        [userDefaults synchronize];
        NSLog(@"date locally %@",[EMContainerViewController stringPrintFromDate:[userDefaults objectForKey:kEMKeyUserDateOld]]);

    }
}

- (void)timeChanged:(NSNotification *) notification
{
    NSLog(@"Time change ");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDate * oldDate = [defaults objectForKey:kEMKeyUserDateOld];
    NSDate * dateActually = [[NSDate alloc] init];
    NSTimeInterval timeInterval = [oldDate timeIntervalSinceDate:dateActually];
    int time = timeInterval;
    if ([oldDate compare:dateActually] != NSOrderedDescending)
    {
        timeInterval = [dateActually timeIntervalSinceDate:oldDate];
        time = timeInterval;
    }
    NSLog(@"timeinterval %u",time);
    
    if (timeInterval > 1800)
    {
        NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
        formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute |
        NSCalendarUnitSecond;
        formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
//        NSString *string = [formatter stringFromTimeInterval:timeInterval];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cambio de fecha" message:[NSString stringWithFormat:@"Se detecto una diferencia de %@%@",([oldDate compare:dateActually] != NSOrderedAscending)?@"-":@"+",string] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
}





@end
