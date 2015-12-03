//
//  EMServiceObjectCapacitaciones.m
//  emetrix
//
//  Created by Carlos molina on 26/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectCapacitaciones.h"

@implementation EMServiceObjectCapacitaciones


- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_capacitaciones.php",self.pathURLService]];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_capacitaciones.php",self.pathURLService]];
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
    

    if(!error && !err)
    {
        //         Parse response
        for (NSDictionary * dictionaryCapacitacion in [json objectForKey:@"capacitacion"])
        {
            NSString * categoria = [dictionaryCapacitacion objectForKey:@"categoria"];
            NSString * urlArchivo = [dictionaryCapacitacion objectForKey:@"urlArchivo"];
            NSString * urlThumb = [dictionaryCapacitacion objectForKey:@"urlThumb"];
            NSString * comentario = [dictionaryCapacitacion objectForKey:@"comentario"];
            
            EMCapacitacion * capacitacion = [[EMManagedObject sharedInstance] capacitacionForId:urlArchivo];
            capacitacion.urlArchivo = urlArchivo;
            capacitacion.urlThumb = urlThumb;
            capacitacion.comentario = comentario;
            EMCategoriaCapacitacion * categoriaCapacitacion = [[EMManagedObject sharedInstance] categoriaCapacitacionForId:categoria];
            categoriaCapacitacion.categoria = categoria;
            capacitacion.emCategoriaCapacitacion = categoriaCapacitacion;
            capacitacion.emCuenta = self.account;
            [[EMManagedObject sharedInstance] saveLocalContext];
            
            
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
