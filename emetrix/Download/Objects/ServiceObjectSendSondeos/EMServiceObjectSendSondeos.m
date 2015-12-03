//
//  EMServiceObjectSendSondeos.m
//  emetrix
//
//  Created by Patricia Blanco on 29/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSendSondeos.h"
#import "EMPendiente.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectSendSondeos


- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        if (pendiente.idNuevaTienda && pendiente.idNuevaTienda.length)
        {
                    self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@agregar_nueva_tienda_android.php",self.pathURLService]];
        }
        else
        {
                   self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@send_sondeos_configurables.php",self.pathURLService]];
        }

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
    NSMutableArray * arrayObjects = [NSMutableArray arrayWithObjects:pendiente.emCuenta.emUser.idUsuario, pendiente.emCuenta.idCuenta,self.pendiente.determinanteGPS, self.pendiente.idSondeo,self.pendiente.cadenaPendiente,[NSDate stringServiceFromDate:self.pendiente.date],nil];
    
    NSMutableArray * arrayKeys = [NSMutableArray arrayWithObjects:@"idUsuario", @"idProyecto",@"determinanteGPS",@"SondeoID",@"sondeo",@"fechaCaptura", nil];
    if(self.pendiente.sku && self.pendiente.sku.length)
    {
        [arrayObjects addObject:self.pendiente.sku];
        [arrayKeys addObject:@"sku"];
    }
    if(self.pendiente.idNuevaTienda && self.pendiente.idNuevaTienda.length)
    {
        [arrayObjects addObject:self.pendiente.idNuevaTienda];
        [arrayKeys addObject:@"idNuevaTienda"];
    }
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
}

- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{

    NSLog(@"que le pasa a esto %@", xmlString);
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
