//
//  EMServiceObjectUploaderFoto.m
//  emetrix
//
//  Created by Patricia Blanco on 11/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectUploaderFoto.h"
#import "EMPendiente+EMExtensions.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectUploaderFoto

- (instancetype)initWithPendiente:(EMPendiente *)pendiente
{
    self = [super init];
    if (self)
    {
        self.pendiente = pendiente;
        self.urlService = [NSURL URLWithString:@"http://www.emetrix.com.mx/test60/uploader_foto64.php"];
        self.typePetition = EMServicePetitionPOST;
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:@"http://www.emetrix.com.mx/test60/uploader_foto64.php"];
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
    EMCuenta * cuenta = self.pendiente.emCuenta;
    NSString * stringParams = [NSString stringWithFormat:@"|idCuenta=%@|idUsuario=%@|idTienda=%@|idCategoriaFoto=%@|comentariosFoto=%@|opciones_foto=12,22",[cuenta.idCuenta stringValue], [cuenta.emUser.idUsuario stringValue],self.pendiente.determinanteGPS, self.pendiente.idCategoriaFoto,(self.pendiente.comentariosFoto.length)?self.pendiente.comentariosFoto:@""];
    
    
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
