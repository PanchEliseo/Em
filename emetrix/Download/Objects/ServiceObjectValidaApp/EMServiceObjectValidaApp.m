//
//  EMServiceObjectValidaApp.m
//  emetrix
//
//  Created by Marco Antonio Flores Lopez on 21/10/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMServiceObjectValidaApp.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectValidaApp

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@url_valida_app.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceLogin;
        
    }
    return self;
}

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    self.customBlock = block;
    //[super startDownload];
    
    NSData *lobjDatDatosSwn;
    NSString * astrContenido = [NSString stringWithFormat:@"http://www.emetrix.com.mx/test60/url_valida_app.php?dispositivo=%@&version=%@",@"1",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSURL * lobjUrl = [[NSURL alloc] initWithString: astrContenido];
    
    NSMutableURLRequest *lobjRequest =[[NSMutableURLRequest alloc] initWithURL: lobjUrl];
    
    [lobjRequest addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [lobjRequest addValue: @"gzip, deflate" forHTTPHeaderField: @"Accept-Encoding"];
    [lobjRequest setHTTPMethod:@"POST"];
    
    [lobjRequest addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[astrContenido length]] forHTTPHeaderField:@"Content-Length"];
        [lobjRequest setHTTPBody: [astrContenido dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    
    NSError * lobjError = nil;
    
    lobjDatDatosSwn = [NSURLConnection sendSynchronousRequest:lobjRequest
                                            returningResponse:nil
                                                        error:&lobjError];
    
    self.response = [NSString stringWithUTF8String:[lobjDatDatosSwn bytes]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         self.customBlock(NO, lobjError);
     }];
}

@end
