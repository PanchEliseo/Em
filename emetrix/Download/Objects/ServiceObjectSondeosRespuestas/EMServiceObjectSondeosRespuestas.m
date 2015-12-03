//
//  EMServiceObjectSondeosRespuestas.m
//  emetrix
//
//  Created by Carlos molina on 02/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSondeosRespuestas.h"
#import "NSObject+EMObjectExtension.h"
#import "EMRespuestasDefault.h"

@implementation EMServiceObjectSondeosRespuestas


- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_sondeos_respuestas_default.php",self.pathURLService]];
        self.jsonRequest = [self createJsonPostForUser:self.user andAccount:self.account];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceLogin;
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_sondeos_respuestas_default.php?idCuenta=126&idUsuario=1185",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceLogin;
        
    }
    return self;
}

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    if (!self.user || !self.account)
    {
        @throw [NSException exceptionWithName:@"user or account are nil please" reason:@"Use - (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account password for initialize" userInfo:nil];
    }
    if (!self.jsonRequest)
    {
        self.jsonRequest = [self createJsonPostForUser:self.user andAccount:self.account];
    }
    self.customBlock = block;
    [super startDownload];
    
    
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
            
            for (NSDictionary * dictionaryRespuestas in [dictionaryTiendas objectForKey:@"preguntasRespuestas"])
            {
                idEncuesta = [dictionaryRespuestas objectForKey:@"idEncuesta"];
                idPregunta = [dictionaryRespuestas objectForKey:@"idPregunta"];
                respuesta = [dictionaryRespuestas objectForKey:@"respuesta"];
                
                if (![respuesta isKindOfClass:[NSNull class]])
                {
                    
                    EMSondeo * sondeo = [[EMManagedObject sharedInstance] sondeoForId:[idEncuesta integerValue]];
                    
                    EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
                    //
                    EMRespuestasDefault * respuestaDefault = [[EMManagedObject sharedInstance] respuestaDefaultForCuenta:self.account tienda:tienda pregunta:pregunta sondeo:sondeo];

                    respuestaDefault.idCuenta = self.account.idCuenta.stringValue;
                    respuestaDefault.idSondeo = sondeo.idSondeo.stringValue;
                    respuestaDefault.idTienda = tienda.idTienda;
                    respuestaDefault.idPregunta = pregunta.idPregunta;
                    respuestaDefault.respuesta = respuesta;
                    
                    [[EMManagedObject sharedInstance] saveLocalContext];

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
