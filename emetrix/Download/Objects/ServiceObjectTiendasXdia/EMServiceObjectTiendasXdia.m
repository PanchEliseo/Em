//
//  EMServiceObjectTiendasXdia.m
//  emetrix
//
//  Created by Patricia Blanco on 15/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectTiendasXdia.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMServiceObjectTiendasXdia

- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_tiendas_x_dia_status.php",self.pathURLService]];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_tiendas_x_dia_status.php",self.pathURLService]];
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
        [[EMManagedObject sharedInstance] deleteTiendasXdiaForCuenta:self.account];
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
    
    if([elementName isEqualToString:kEMKeyXMLTienda])
    {
        NSDate * date = [[NSDate alloc] init];
        NSString * idTiendasXDia = [EMServiceObjectTiendasXdia tiendaXDiaIDWithDate:date user:self.user cuenta:self.account];
        EMTiendasXdia * tiendasXdia = [[EMManagedObject sharedInstance] tiendasXdiaForId:idTiendasXDia];
        tiendasXdia.idTiendasXdia = idTiendasXDia;
        EMTienda * tienda = [[EMManagedObject sharedInstance] tiendaForId:[attributeDict objectForKey:kEMKeyXMLId]];
        tienda.idTienda = [attributeDict objectForKey:kEMKeyXMLId];
        tienda.estatus = [attributeDict objectForKey:kEMKeyXMLEstatus];
        tienda.icono = [attributeDict objectForKey:kEMKeyXMLIcono];
        tienda.num_fotos = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLNumFotos] integerValue]];
        [tiendasXdia addEmTiendasObject:tienda];
        [[EMManagedObject sharedInstance] saveLocalContext];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}


@end
