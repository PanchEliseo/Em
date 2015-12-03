//
//  EMServiceObjectFecha.m
//  emetrix
//
//  Created by Carlos molina on 22/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectFecha.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectFecha

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@horalocal.php",self.pathURLService]];
        self.typePetition = EMServicePetitionGET;        
    }
    return self;
}

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    self.customBlock = block;
    [super startDownload];
    
}


- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{
    if(!error)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
             NSDate * date = [EMServiceObjectFecha datePrintFromString:xmlString];
             NSLog(@"Log %@", date);
             [defaults setObject:[EMServiceObjectFecha datePrintFromString:xmlString] forKey:kEMKeyUserDateOld];
             [defaults synchronize];
             if (self.customBlock)
             {
                 self.customBlock(YES, error);
             }
         }];
    }
    else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(NO, error);
         }];
    }
    
}


@end
