//
//  SSServiceObject.h
//  survey
//
//  Created by Werever on 16/01/15.
//  Copyright (c) 2015 Carlos Alberto Molina Saenz  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMDownloadServiceManager.h"

//0 is developer
//1 is production

typedef enum
{
    EMServicePetitionGET = 0,
    EMServicePetitionPOST,
    
    
} EMServicePetition;

typedef enum
{
    EMServiceToUseDeveloper = 0,
    EMServiceToUseProduction,
    
    
} EMServiceToUse;

typedef void(^EMServiceObjectBlock)(BOOL successDownload, NSError * error);

@interface EMServiceObject : NSObject<NSXMLParserDelegate>


@property (strong, nonatomic) NSMutableDictionary * jsonRequest;
@property (nonatomic) EMServicePetition typePetition;
@property (nonatomic) EMServices typeService;
@property (strong, nonatomic) NSURL * urlService;
@property (strong, nonatomic) NSString * pathURLService;
@property (nonatomic, copy) EMServiceObjectBlock customBlock;
- (void)startDownload;
- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString;
- (NSMutableDictionary *) createJsonPostForUser:(EMUser *) user andAccount:(EMCuenta *) account;

@end
