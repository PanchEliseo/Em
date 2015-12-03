//
//  EMCapacitacionesWebViewViewController.m
//  emetrix
//
//  Created by Carlos molina on 28/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMCapacitacionesWebViewViewController.h"
#import "emetrix-Swift.h"

@interface EMCapacitacionesWebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EMCapacitacionesWebViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.webView.delegate = self;
    [SwiftSpinner show:@"Cargando..." animated:YES];
    self.webView.delegate = self;
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:self.urlRequest];
    [self.webView loadRequest:request];
    self.title = @"Capacitaciones";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SwiftSpinner hide:nil];
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SwiftSpinner hide:nil];

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
