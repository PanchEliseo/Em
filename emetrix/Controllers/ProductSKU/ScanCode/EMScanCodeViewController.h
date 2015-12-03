//
//  EMScanCodeViewController.h
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSScannerViewController.h>
@protocol EMScanDelegate<NSObject>
- (void)didScanCode:(NSString *) code;
- (void)didDismissScanViewController;
@optional
- (void)willDismissScanViewController;
@end
@interface EMScanCodeViewController : RSScannerViewController

@property (strong, nonatomic) id<EMScanDelegate> delegate;

@end
