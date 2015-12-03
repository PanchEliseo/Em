//
//  EMServiceObjectLogsMovil.m
//  emetrix
//
//  Created by Patricia Blanco on 14/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectLogsMovil.h"
#import "EMPendiente+EMExtensions.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectLogsMovil

- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        self.urlService = [NSURL URLWithString:@"http://www.emetrix.com.mx/test60/logsMovil.php"];
        self.typePetition = EMServicePetitionPOST;
        
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"init is private" reason:@"Use - (instancetype)initWithPendiente:(EMPendiente *)pendiente isCheckIn:(BOOL) isCheckIn" userInfo:nil];
    return nil;
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
    EMCuenta * cuenta = self.pendiente.emCuenta;
    NSMutableArray * arrayObjects = [NSMutableArray arrayWithObjects:cuenta.idCuenta,cuenta.emUser.idUsuario,[NSDate stringServiceFromDate:self.pendiente.date], self.pendiente.tag, self.pendiente.conexion,self.pendiente.hotspot,self.pendiente.bluetooth,self.pendiente.brillo,self.pendiente.bateria, self.pendiente.gps, self.pendiente.datos,nil];
    
    NSMutableArray * arrayKeys = [NSMutableArray arrayWithObjects:@"idProyecto",@"idUsuario",@"fechaCaptura",@"tag", @"conexion",@"hotSpot",@"bluetooth",@"brillo",@"bateria",@"gps",@"datos", nil];
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
