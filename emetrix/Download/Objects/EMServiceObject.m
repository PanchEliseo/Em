//
//  SSServiceObject.m
//  survey
//
//  Created by Werever on 16/01/15.
//  Copyright (c) 2015 Carlos Alberto Molina Saenz  . All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObject()

@property (nonatomic) NSInteger serverToUse;

@end

@implementation EMServiceObject

- (NSURL *)urlService
{
    if (!_urlService)
    {
        _urlService = [[NSURL alloc] init];
    }
    return _urlService;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.serverToUse = EMServiceToUseDeveloper;
        
        if (self.serverToUse == EMServiceToUseDeveloper)
        {
            self.pathURLService = @"http://www.emetrix.com.mx/test60/";
        }
        else
        {
//    verificar url de producción
            self.pathURLService = @"http://www.emetrix.com.mx/test60/";
        }
    }
    return self;
}



- (void)startDownload
{
    if (self.typePetition == EMServicePetitionPOST)
    {
        [[EMDownloadServiceManager sharedInstance] downloadJsonPOSTWithServiceObject:self];
    }
    else
    {
        [[EMDownloadServiceManager sharedInstance] downloadJsonGETWithServiceObject:self];
    }
}

- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{
    if (error)
    {
        self.customBlock(nil, error);
    }
}

- (NSMutableDictionary *) createJsonPostForUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    NSArray * arrayObjects = [NSArray arrayWithObjects:user.idUsuario, account.idCuenta,nil];
    
    NSArray * arrayKeys = [NSArray arrayWithObjects:@"idUsuario", @"idCuenta", nil];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
}


@end
