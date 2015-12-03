//
//  EMScanCodeViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 05/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMScanCodeViewController.h"
#import "RSCodeView.h"
#import "RSCodeGen.h"
#import "NZAlertView.h"

@interface EMScanCodeViewController ()
@property (strong, nonatomic) NSString * barcode;

@end

@implementation EMScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __block EMScanCodeViewController * weakSelf = self;
        self.barcodesHandler = ^(NSArray *barcodeObjects)
    {
        if (barcodeObjects.count > 0)
        {
            NSMutableString *text = [[NSMutableString alloc] init];
            [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 [text appendString:[NSString stringWithFormat:@"%@: %@", [(AVMetadataObject *)obj type], [obj stringValue]]];
                 if (idx != (barcodeObjects.count - 1))
                 {
                     [text appendString:@"\n"];
                 }
             }];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               weakSelf.barcode = text;
                               if([weakSelf.delegate respondsToSelector:@selector(didScanCode:)])
                               {
                                   [weakSelf.delegate didScanCode:text];
                               }
                               if([weakSelf.delegate respondsToSelector:@selector(willDismissScanViewController)])
                               {
                                   [weakSelf.delegate willDismissScanViewController];
                               }
                               [weakSelf dismissViewControllerAnimated:YES completion:^
                                {
                                    if([weakSelf.delegate respondsToSelector:@selector(didDismissScanViewController)])
                                    {
                                        [weakSelf.delegate didDismissScanViewController];
                                    }
                                    
                                }];
                               
                           });
            
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               weakSelf.barcode = @"";
                           });
        }
        
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)__applicationDidEnterBackground:(NSNotification *)notification
{
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.tapGestureHandler = ^(CGPoint tapPoint) {
        };
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
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
