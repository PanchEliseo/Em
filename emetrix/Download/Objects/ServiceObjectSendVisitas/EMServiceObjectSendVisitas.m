//
//  EMServiceObjectSendVisitas.m
//  emetrix
//
//  Created by Patricia Blanco on 29/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSendVisitas.h"
#import "EMPendiente.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectSendVisitas

- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@send_visitas.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@send_visitas.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        
    }
    return self;
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger idPendiente = [[defaults objectForKey:kEMKeyUserSendVisitaPendiente] unsignedIntegerValue];
    idPendiente++;
    NSMutableArray * arrayObjects = [NSMutableArray arrayWithObjects:pendiente.emCuenta.emUser.idUsuario, pendiente.emCuenta.idCuenta,self.pendiente.determinanteGPS,[NSDate stringServiceFromDate:self.pendiente.date],pendiente.latitud,pendiente.longitud,[NSNumber numberWithUnsignedInteger:idPendiente],nil];
    [defaults setObject:[NSNumber numberWithUnsignedInteger:idPendiente] forKey:kEMKeyUserSendVisitaPendiente];
    [defaults synchronize];
    
    NSMutableArray * arrayKeys = [NSMutableArray arrayWithObjects:@"idUsuario", @"idProyecto",@"determinanteGPS",@"fechaCaptura",@"latitud", @"longitud",@"id_pendiente", nil];
    if(pendiente.cadenaPendiente && pendiente.cadenaPendiente.length)
    {
        //se envia información
        [arrayObjects addObject:[NSNumber numberWithInt:2]];
    }
    else
    {
        //solo se dio click a la tienda
        [arrayObjects addObject:[NSNumber numberWithInt:1]];
    }
    [arrayKeys addObject:@"idStatus"];
    if(pendiente.visitaNombre && pendiente.visitaNombre.length)
    {
        [arrayObjects addObject:pendiente.visitaNombre];
        [arrayKeys addObject:@"visitaNombre"];
    }
    
    
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
