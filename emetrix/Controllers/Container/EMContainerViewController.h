//
//  SSSurveyContainerViewController.h
//  survey
//
//  Created by Carlos Alberto Molina Saenz (Vendor) on 1/21/15.
//  Copyright (c) 2015 Carlos Alberto Molina Saenz (Vendor). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPReachability.h"

@interface EMContainerViewController : UIViewController
@property EMUser * user;
@property EMCuenta * cuenta;
@property (strong, nonatomic) UIViewController * viewControllerContainer;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (nonatomic, strong) SPReachability *currentReachability;
- (void)setTitleText:(NSString *) title;
- (void)sendPendientes;
@end
