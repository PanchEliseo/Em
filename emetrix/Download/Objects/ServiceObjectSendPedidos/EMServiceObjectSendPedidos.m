//
//  EMServiceObjectSendPedidos.m
//  emetrix
//
//  Created by Carlos molina on 20/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSendPedidos.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectSendPedidos

- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@send_pedidos.php",self.pathURLService]];
        
        self.typePetition = EMServicePetitionPOST;
        
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"init is private" reason:@"Use - (instancetype)initWithPendiente:(EMPendiente *)pendiente for initialize" userInfo:nil];
}

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    
    if (!self.pendiente)
    {
        @throw [NSException exceptionWithName:@"Pendiente is nil please" reason:@"Use - (instancetype)initWithPendiente:(EMPendiente *)pendiente for initialize" userInfo:nil];
    }
    if (!self.jsonRequest)
    {
        self.jsonRequest = [self createJsonPostForPendiente:self.pendiente];
    }
    self.customBlock = block;
    [super startDownload];
    
    
}

- (NSMutableDictionary *) createJsonPostForPendiente:(EMPendiente *)pendiente
{
    NSMutableArray * arrayObjects = [NSMutableArray arrayWithObjects:pendiente.cadenaPendiente,nil];
    
    NSMutableArray * arrayKeys = [NSMutableArray arrayWithObjects:@"params", nil];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
}

- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{
    
    if([[xmlString lowercaseString] isEqualToString:kEMKeyXMLOK] || [[xmlString lowercaseString] hasPrefix:kEMKeyXMLOK])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(YES, nil);
         }];
    }
    else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(NO,error);
         }];
    }
    
    
}
@end
