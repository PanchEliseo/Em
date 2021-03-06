//
//  EMServiceObjectProductos.m
//  emetrix
//
//  Created by Patricia Blanco on 15/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectProductos.h"

@implementation EMServiceObjectProductos


- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos.php",self.pathURLService]];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_productos.php",self.pathURLService]];
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
    NSLog(@"xmlString: %@",xmlString);
    
         if(!error)
         {
             //         Parse response
             [[EMManagedObject sharedInstance] deleteAllProductsForCuenta:self.account];
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
    NSString *errorString = [NSString stringWithFormat:@"Error code %ld", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:kEMKeyXMLProducto])
    {
        EMProducto * producto = [[EMManagedObject sharedInstance] productForId:[attributeDict objectForKey:kEMKeyXMLSku]];
        producto.sku = [attributeDict objectForKey:kEMKeyXMLSku];
        producto.descripcion = [attributeDict objectForKey:kEMKeyXMLDescripcion];
        producto.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        producto.precioMax = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLPrecioMax] integerValue]];
        producto.precioMin = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLPrecioMin] integerValue]];
        producto.precioMin = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLPrecioMin] integerValue]];
        producto.precio = [attributeDict objectForKey:kEMKeyXMLPrecioPedido];
        producto.urlImg = [attributeDict objectForKey:kEMKeyXMLFotoUrl];
        producto.capturado = [NSNumber numberWithBool:NO];
        EMMarca * marca = [[EMManagedObject sharedInstance] marcaForId:[attributeDict objectForKey:kEMKeyXMLIdMarca]];
        marca.idMarca = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIdMarca] integerValue]];
        [producto addEmMarcasObject:marca];
        EMCategoria * categoria = [[EMManagedObject sharedInstance] categoryForId:[attributeDict objectForKey:kEMKeyXMLIdCategoria]];
        categoria.idCategoria = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIdCategoria] integerValue]];
        [producto addEmCategoriaObject:categoria];
        [producto addEmCuentasObject:self.account];
        [[EMManagedObject sharedInstance] saveLocalContext];
        
        
    }
    else if([elementName isEqualToString:kEMKeyXMLMarca])
    {
        EMMarca * marca = [[EMManagedObject sharedInstance] marcaForId:[attributeDict objectForKey:kEMKeyXMLIdMarca]];
        marca.idMarca = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIdMarca] integerValue]];
        marca.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        [[EMManagedObject sharedInstance] saveLocalContext];
        
    }
    else if ([elementName isEqualToString:kEMKeyXMLCategoria])
    {
        EMCategoria * categoria = [[EMManagedObject sharedInstance] categoryForId:[attributeDict objectForKey:kEMKeyXMLIdCategoria]];
        categoria.idCategoria = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIdCategoria] integerValue]];
        categoria.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}

@end
