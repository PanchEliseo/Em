//
//  EMServiceObjectTiendas.m
//  emetrix
//
//  Created by Patricia Blanco on 15/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectTiendas.h"

@implementation EMServiceObjectTiendas


- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_tiendas.php",self.pathURLService]];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_tiendas.php",self.pathURLService]];
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
    

         if(!error)
         {
                 //         Parse response
             [[EMManagedObject sharedInstance] deleteAllTiendasForCuenta:self.account];
             xmlParser.delegate = self;
             if([xmlParser parse])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
                  {
                      self.customBlock(YES,error);
                  }];
             }
             else
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
                  {
                      //             verificar error
                      self.customBlock(NO,error);
                  }];
             }
             
         }
         else
         {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^
              {
                  self.customBlock(NO, error);
              }];
         }

         

}



- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"File found and parsing started");
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSString *errorString = [NSString stringWithFormat:@"Error code %ld", (long)[parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:kEMKeyXMLTienda])
    {
        EMTienda * tienda = [[EMManagedObject sharedInstance] tiendaForId:[attributeDict objectForKey:kEMKeyXMLId]];
        if(![[attributeDict objectForKey:kEMKeyXMLDefinirNombre] isEqualToString:@"0"]){
            tienda.definirNombre = [NSNumber numberWithBool:[[attributeDict objectForKey:kEMKeyXMLDefinirNombre] integerValue]];
            //tienda.definirNombre = [NSNumber numberWithBool:[attributeDict objectForKey:kEMKeyXMLDefinirNombre]];
        }
        tienda.idTienda = [attributeDict objectForKey:kEMKeyXMLId];
        tienda.idCadena = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIdCadena] integerValue]];
        tienda.latitud = [NSNumber numberWithDouble:[[attributeDict objectForKey:kEMKeyXMLLatitud] doubleValue]];
        tienda.longitud = [NSNumber numberWithDouble:[[attributeDict objectForKey:kEMKeyXMLLongitud] doubleValue]];
        tienda.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        tienda.checkGPS = [NSNumber numberWithBool:[[attributeDict objectForKey:kEMKeyXMLCheckGPS] boolValue]];
        tienda.rangoGPS = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLRangoGPS] integerValue]];
        tienda.banderaDefinirNombre = [NSNumber numberWithBool:NO];
        if([tienda.emCuentas allObjects].count)
        {
            BOOL isAdd = NO;
            for(EMCuenta * cuenta in tienda.emCuentas)
            {
                if([cuenta.idCuenta integerValue] == [self.account.idCuenta integerValue])
                {
                    isAdd = YES;
                }
            }
            if(!isAdd)
            {
                [tienda addEmCuentasObject:self.account];
            }
        }
        else
        {
            [tienda addEmCuentasObject:self.account];
        }

        [[EMManagedObject sharedInstance] saveLocalContext];
        
        
        
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}

@end
