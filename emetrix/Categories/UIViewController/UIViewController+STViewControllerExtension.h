//
//  UIViewController+STViewControllerExtension.h
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz (Vendor) on 11/12/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMContainerViewController;
@interface UIViewController (STViewControllerExtension)
- (UIFont *) ss_fontWithSize:(CGFloat)size;
- (void)showAlertViewWithMessage:(NSString *) message;
- (void) addTitleView;
- (UIViewController *) viewControllerForStoryBoardName:(NSString *) storyBoardName;
- (UIViewController *) viewControllerForStoryBoardName:(NSString *) storyBoardName vcIdentifier:(NSString *) identifier;
- (UIBarButtonItem *) addLeftBarButton;
- (UIBarButtonItem *) addRightBarButton;
- (CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text withWidth: (float) width;
- (BOOL) validEmail:(NSString*) emailString;
- (NSString *)encodeToBase64String:(UIImage *)image;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (void)presentActionSheetWithButtonsTitle:(NSArray *) arrayButtonsTitle;
- (EMContainerViewController *) containerParentViewController;
- (EMPendiente *) pendienteLogMovilForTag:(NSString *)tag;
- (void)deleteVersionesAllCuenta;
@end
