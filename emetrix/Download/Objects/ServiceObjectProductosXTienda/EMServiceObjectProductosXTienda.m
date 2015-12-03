//
//  EMServiceObjectProductosXTienda.m
//  emetrix
//
//  Created by Patricia Blanco on 20/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectProductosXTienda.h"

@implementation EMServiceObjectProductosXTienda

- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        //self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos_x_tienda.php",self.pathURLService]];
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos_x_tienda_x_sondeo.php",self.pathURLService]];
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
        //self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos_x_tienda.php",self.pathURLService]];
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos_x_tienda_x_sondeo.php",self.pathURLService]];
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
             //         delete all entitys emtiendaday
             
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
                 //             verificar error
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
                  {
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:kEMKeyXMLProductoCadena])
    {
        NSMutableArray * arrayTiendas = [[EMManagedObject sharedInstance] tiendasForIdCadena:[[attributeDict objectForKey:kEMKeyXMLIdCadena] integerValue]];
        EMProducto * producto = [[EMManagedObject sharedInstance] productForId:[attributeDict objectForKey:kEMKeyXMLSku]];
        NSLog(@"id sondeo %@", [attributeDict objectForKey:kEMKeyXMLIdSondeo]);
        //producto.idSondeo = [attributeDict objectForKey:kEMKeyXMLIdSondeo];
        producto.idSondeo = @"812";
        for(EMTienda * tienda in arrayTiendas)
        {
            [tienda addEmProductosObject:producto];
        }
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}

@end
