//
//  EMServiceObjectSondeosRespuestasOnline.m
//  emetrix
//
//  Created by Marco Antonio Flores Lopez on 06/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSondeosRespuestasOnline.h"
#import "NSObject+EMObjectExtension.h"
#import "EMRespuestasDefault.h"

@implementation EMServiceObjectSondeosRespuestasOnline

- (instancetype)initWithUsuario:(EMUser *) usuario cuenta:(EMCuenta *) cuenta tienda:(EMTienda *) tienda
{
    self = [super init];
    if (self)
    {
        self.usuario = usuario;
        self.cuenta = cuenta;
        self.tienda = tienda;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_sondeos_respuestas_x_tienda.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceSondeoRespuestasOnline;
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_sondeos_respuestas_x_tienda.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceSondeoRespuestasOnline;
        
    }
    return self;
}


- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    if (!self.usuario || !self.cuenta || !self.tienda)
    {
        @throw [NSException exceptionWithName:@"user or account are nil please" reason:@"Use - (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account password for initialize" userInfo:nil];
    }
    if (!self.jsonRequest)
    {
        self.jsonRequest = [self createJsonPostForIdUser:self.usuario.idUsuario idCuenta:self.cuenta.idCuenta idTienda:self.tienda.idTienda];
    }
    self.customBlock = block;
    [super startDownload];
}


- (NSMutableDictionary *) createJsonPostForIdUser:(NSNumber *)IdUsuario idCuenta:(NSNumber *)IdCuenta idTienda:(NSString *)IdTienda
{
    NSArray * arrayObjects = [NSArray arrayWithObjects:IdUsuario, IdCuenta, IdTienda, nil];
    
    NSArray * arrayKeys = [NSArray arrayWithObjects:@"idUsuario", @"idCuenta", @"idTienda", nil];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
}


- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{
    
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary * json;
    if (data)
    {
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
    }
    
    if(!error && !err && json.count)
    {
        //         Parse response
        for (NSDictionary * dictionaryTiendas in [json objectForKey:@"tiendas"])
        {
            NSString * idTienda = [dictionaryTiendas objectForKey:@"idTienda"];
            EMTienda * tienda = [[EMManagedObject sharedInstance] tiendaForId:idTienda];
            
            NSString * idEncuesta;
            NSString * idPregunta;
            NSString * respuesta;
            //NSString * sku;
             
            for (NSDictionary * dictionaryRespuestas in [dictionaryTiendas objectForKey:@"preguntasRespuestas"])
            {
                idEncuesta = [dictionaryRespuestas objectForKey:@"idEncuesta"];
                idPregunta = [dictionaryRespuestas objectForKey:@"idPregunta"];
                respuesta = [dictionaryRespuestas objectForKey:@"respuesta"];
                //sku = [dictionaryRespuestas objectForKey:@"sku"];
                
                if (![respuesta isKindOfClass:[NSNull class]])
                {
                    
                    EMSondeo * sondeo = [[EMManagedObject sharedInstance] sondeoForId:[idEncuesta integerValue]];
                    
                    EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
                    
                    EMRespuestasDefault * respuestaDefault = [[EMManagedObject sharedInstance]
                                                              respuestaDefaultForCuenta:self.cuenta
                                                              tienda:tienda
                                                              pregunta:pregunta
                                                              sondeo:sondeo];
                    
                    if (respuestaDefault.idCuenta == nil ||
                        respuestaDefault.idSondeo == nil ||
                        respuestaDefault.idTienda == nil ||
                        respuestaDefault.idPregunta == nil) {
                        
                        respuestaDefault.idCuenta = self.cuenta.idCuenta.stringValue;
                        respuestaDefault.idSondeo = sondeo.idSondeo.stringValue;
                        respuestaDefault.idTienda = tienda.idTienda;
                        respuestaDefault.idPregunta = pregunta.idPregunta;
                        respuestaDefault.respuesta = respuesta;
                        //respuestaDefault.sku
                        
                        [[EMManagedObject sharedInstance] saveLocalContext];

                    }
                }
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(YES,error);
         }];
    }
    else
    {
        if (error)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.customBlock(NO, error);
             }];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.customBlock(NO, err);
             }];
        }
        
    }
    
}


@end
