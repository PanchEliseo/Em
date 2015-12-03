//
//  EMSoporteTecnicoViewController.m
//  emetrix
//
//  Created by Carlos molina on 21/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSoporteTecnicoViewController.h"
#import <MessageUI/MessageUI.h>

@interface EMSoporteTecnicoViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation EMSoporteTecnicoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblVersion.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
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
- (IBAction)didPressCall:(UIButton *)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:018000883956"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:018000883956"]];
    }
    
}
- (IBAction)didPressEmail:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"Soporte app IOS";
    // Email Content
    NSString *messageBody = @"Soporte app IOS";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"soporte@evolve.com.mx"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
