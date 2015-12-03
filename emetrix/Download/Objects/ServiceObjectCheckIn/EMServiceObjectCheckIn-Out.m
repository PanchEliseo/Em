//
//  EMServiceObjectCheckIn-Out.m
//  emetrix
//
//  Created by Patricia Blanco on 11/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectCheckIn-Out.h"
#import "EMPendiente+EMExtensions.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectCheckIn_Out

- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        if ([pendiente.tipo integerValue] == EMPendienteTypeCheckIn)
        {
            self.urlService = [NSURL URLWithString:@"http://www.emetrix.com.mx/test60/asistencia_entrada_foto64.php"];
        }
        else
        {
            self.urlService = [NSURL URLWithString:@"http://www.emetrix.com.mx/test60/asistencia_salida_foto64.php"];
        }
        
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
    NSString * stringParams = [NSString stringWithFormat:@"|idCuenta=%@|idUsuario=%@|idTienda=%@",[cuenta.idCuenta stringValue], [cuenta.emUser.idUsuario stringValue],self.pendiente.determinanteGPS];
    
    
    NSMutableArray * arrayObjects = [NSMutableArray arrayWithObjects:stringParams, [NSDate stringServiceFromDate:self.pendiente.date], self.pendiente.cadenaPendiente, self.pendiente.latitud,self.pendiente.longitud,nil];
    
    NSMutableArray * arrayKeys = [NSMutableArray arrayWithObjects:@"params",@"fechaCaptura",@"foto", @"latitud",@"longitud", nil];
    if ([self.pendiente.consecutivo intValue])
    {
        [arrayObjects addObject:self.pendiente.consecutivo];
        [arrayKeys addObject:@"consecutivo"];
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
