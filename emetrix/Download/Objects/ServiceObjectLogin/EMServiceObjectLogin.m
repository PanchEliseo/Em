//
//  EMServiceObjectLogin.m
//  emetrix
//
//  Created by Patricia Blanco on 14/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//


#import "EMServiceObjectLogin.h"
#import <UIKit/UIKit.h>
#import "NSObject+EMObjectExtension.h"

@interface EMServiceObjectLogin()
@property (strong, nonatomic) EMCuenta * cuenta;
@end
@implementation EMServiceObjectLogin

- (instancetype)initWithUsername:(NSString *) userName andPassword:(NSString *) password
{
    self = [super init];
    if (self)
    {
        self.userName = userName;
        self.password = password;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@loginy.php",self.pathURLService]];
        self.jsonRequest = [self createJsonPostForUserName:self.userName andPassword:self.password];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@loginy.php",self.pathURLService]];
        self.typePetition = EMServicePetitionPOST;
        self.typeService = EMServiceLogin;
        
    }
    return self;
}

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL success, NSError * error))block;
{
    if (!self.userName || !self.password)
    {
        @throw [NSException exceptionWithName:@"username or password are nil please" reason:@"Use - initWithUsername:(NSString *) userName andPassword:(NSString *) password for initialize" userInfo:nil];
    }
    if (!self.jsonRequest)
    {
        self.jsonRequest = [self createJsonPostForUserName:self.userName andPassword:self.password];
    }
    self.customBlock = block;
    [super startDownload];
    
}

- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{
    if(!error)
    {
        if([xmlString isEqualToString:@"false"])
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"usuario o cantraseña incorrectas" forKey:NSLocalizedDescriptionKey];
            // populate the error object with the details
            NSError * error = [NSError errorWithDomain:@"Credenciales invalidas" code:-1 userInfo:details];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 self.customBlock(NO, error);
             }];
        }
        else
        {
            [[EMManagedObject sharedInstance] deleteAllRespuestasDefault];
            
            //         Parse response
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
        
    }
    else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(NO, error);
         }];
    }

}

- (NSMutableDictionary *) createJsonPostForUserName:(NSString *) userName andPassword:(NSString *) password
{
    NSArray * arrayObjects = [NSArray arrayWithObjects:userName, password, @"60.0", [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"",nil];
    
    NSArray * arrayKeys = [NSArray arrayWithObjects:@"usuario", @"password",@"version",@"imei",@"telefono", nil];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
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
    
    if([elementName isEqualToString:kEMKeyLoginXMLUser])
    {
//        usuario agregar a container
        EMUser * usuario = [[EMManagedObject sharedInstance] userForId:[[attributeDict objectForKey:kEMKeyXMLId] integerValue]];
        usuario.idUsuario = [NSNumber numberFromString:[attributeDict objectForKey:kEMKeyXMLId]];
        usuario.usuario = self.userName;
        usuario.password = self.password;
        usuario.udid_phone = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//#warning Se comento la linea para hacer pruebas eliminar NSDate * newDateExpired = [[NSDate alloc] init]; y descomentar NSDate * newDateExpired = [NSDate dateFromString:[attributeDict objectForKey:kEMKeyLoginXMLUserDateExpired]];
        NSDate * newDateExpired = [NSDate dateFromString:[attributeDict objectForKey:kEMKeyLoginXMLUserDateExpired]];
//        NSDate * newDateExpired = [[NSDate alloc] init];
        if (usuario.fecha_vencimiento)
        {
            if ([usuario.fecha_vencimiento compare:newDateExpired] == NSOrderedAscending)
            {
                //            ya existía el usuario hay que borrar productos capturados. tiendas con check in y actualizar el id de tiendas por día
                for (EMCuenta * cuenta in usuario.emCuentas)
                {
                    EMTiendasXdia * tiendaXdia = [[EMManagedObject sharedInstance] tiendasXdiaForId:[EMServiceObjectLogin tiendaXDiaIDWithDate:usuario.fecha_vencimiento user:usuario cuenta:cuenta]];
                    tiendaXdia.idTiendasXdia = [EMServiceObjectLogin tiendaXDiaIDWithDate:newDateExpired user:usuario cuenta:cuenta];
                    [[EMManagedObject sharedInstance] saveLocalContext];
                    for (EMTienda * tienda in cuenta.emTiendas)
                    {
                        tienda.checkIn = [NSNumber numberWithBool:NO];
                        tienda.checkOut = [NSNumber numberWithBool:NO];
                        tienda.estatus = [NSString stringWithFormat:@"%u",EMStatusTypeNotVisit];
                        [[EMManagedObject sharedInstance] saveLocalContext];
                        
                    }
                    for (EMProducto * producto in cuenta.emProductos)
                    {
                        producto.capturado = [NSNumber numberWithBool:NO];
                        [[EMManagedObject sharedInstance] saveLocalContext];
                    }
                    for (EMSondeo * sondeo in cuenta.emSondeos)
                    {
                        sondeo.emPull.estado = [NSNumber numberWithInt:EMStatusTypeNotVisit];
                        [[EMManagedObject sharedInstance] saveLocalContext];
                    }
                }


            }
            
        }
        
        
        usuario.fecha_vencimiento = newDateExpired;
        [[EMManagedObject sharedInstance] saveLocalContext];
        self.user = usuario;
    }
    else if([elementName isEqualToString:kEMKeyLoginXMLAccount])
    {
        EMCuenta * cuenta = [[EMManagedObject sharedInstance] accountForId:[[attributeDict objectForKey:kEMKeyXMLId] integerValue]];
        cuenta.filtroCategoria = [attributeDict objectForKey:kEMKeyLoginXMLFilterCategory];
        cuenta.filtroMarca = [attributeDict objectForKey:kEMKeyLoginXMLFilterMarca];
        cuenta.gps = [NSNumber numberWithBool:[attributeDict objectForKey:kEMKeyLoginXMLGPS]];
        cuenta.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        cuenta.nuevaTienda = [NSNumber numberWithBool:[attributeDict objectForKey:kEMKeyLoginXMLNewTienda]];
        cuenta.visitaExtra = [NSNumber numberWithBool:[attributeDict objectForKey:kEMKeyLoginXMLVisitaExtra]];
        cuenta.idCuenta = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLId] integerValue]];
        cuenta.emUser = self.user;
        cuenta.indicadoresRendimiento = [NSNumber numberWithInteger:[[attributeDict objectForKey:KEMKeyLoginXMLIndicadoresRendimiento] integerValue]];
        cuenta.capacitaciones = [NSNumber numberWithInteger:[[attributeDict objectForKey:KEMKeyLoginXMLCapacitaciones] integerValue]];
        cuenta.descargaSondeosOnline = [NSNumber numberWithInteger:[[attributeDict objectForKey:KEMKeyLoginXMLDescargaSondeosOnline] integerValue]];
        
        [[EMManagedObject sharedInstance] saveLocalContext];
        self.cuenta = cuenta;
    }
    else if([elementName isEqualToString:kEMKeyLoginXMLVersion])
    {
        
        self.cuenta.tiendas = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyXMLTiendas] intValue]];
        
        self.cuenta.productos = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyLoginXMLProducts] intValue]];
        
        self.cuenta.sondeos = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyLoginXMLSondeos] intValue]];
        
        self.cuenta.tiendasXdia = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyLoginXMLTiendasXDia] intValue]];
        
        self.cuenta.sondeosXTienda = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyLoginXMLSondeosXTienda]  intValue]];
        
        self.cuenta.productosXTienda = [NSNumber numberWithInt:[[attributeDict objectForKey:kEMKeyLoginXMLProductosXTienda] intValue]];
        [[EMManagedObject sharedInstance] saveLocalContext];


    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}

@end
