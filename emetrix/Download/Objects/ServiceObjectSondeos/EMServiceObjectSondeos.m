//
//  EMServiceObjectSondeos.m
//  emetrix
//
//  Created by Patricia Blanco on 15/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectSondeos.h"
#import "NSObject+EMObjectExtension.h"

@interface EMServiceObjectSondeos()
@property (strong, nonatomic) EMSondeo * sondeo;
@property (strong, nonatomic) NSMutableArray * preguntas;
@property (strong, nonatomic) NSMutableArray * respuestas;
@property (nonatomic) NSInteger  indexPregunta;
@property (nonatomic) NSInteger  indexRespuesta;
@end

@implementation EMServiceObjectSondeos

- (NSMutableArray *) preguntas
{
    if(!_preguntas)
    {
        _preguntas = [[NSMutableArray alloc] init];
    }
    return _preguntas;
}

- (NSMutableArray *) respuestas
{
    if(!_respuestas)
    {
        _respuestas = [[NSMutableArray alloc] init];
    }
    return _respuestas;
}

- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [self init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.jsonRequest = [self createJsonPostForUser:self.user andAccount:self.account];
        self.indexRespuesta = 0;
        self.indexPregunta = 0;

        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@descargar_sondeos.php",self.pathURLService]];
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
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
    if(!error)
    {
        [[EMManagedObject sharedInstance] deleteAllSondeosForCuenta:self.account];
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
    else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             self.customBlock(NO, error);
         }];
    }
          }];

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
    if([elementName isEqualToString:kEMKeyXMLEncuesta])
    {
        EMSondeo * sondeo = [[EMManagedObject sharedInstance] sondeoForId:[[attributeDict objectForKey:kEMKeyXMLId] integerValue]];
        sondeo.idSondeo = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLId] integerValue]];
        sondeo.nombre = [attributeDict objectForKey:kEMKeyLoginXMLName];
        sondeo.indice = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEMKeyXMLIndice] integerValue]];
        sondeo.capturaSKU = [NSNumber numberWithBool:[[attributeDict objectForKey:kEMKeyXMLCapturaSKU] boolValue]];
        sondeo.obligatorio = [NSNumber numberWithBool:[[attributeDict objectForKey:kEMKeyXMLObligatorio] boolValue]];
        [sondeo addEmCuentasObject:self.account];
        [[EMManagedObject sharedInstance] saveLocalContext];
        self.sondeo = sondeo;
    }
    else if([elementName isEqualToString:kEMKeyXMLPreguntaEncuesta])
    {
        NSString * idPregunta;
        if ([self.sondeo.idSondeo integerValue] == EMSondeoStaticFotos || [self.sondeo.idSondeo integerValue] == EMSondeoStaticFotoGaleria || [self.sondeo.idSondeo integerValue] == EMSondeoStaticNuevaTienda || [self.sondeo.idSondeo integerValue] == EMSondeoStaticAsistencia)
        {
            idPregunta = [EMServiceObjectSondeos idEMPreguntaWithIdPregunta:[attributeDict objectForKey:kEMKeyXMLId] idCuenta:[self.account.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]];

        }
        else
        {
            idPregunta = [attributeDict objectForKey:kEMKeyXMLId];

        }
        EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
        pregunta.idPregunta = idPregunta;
        pregunta.obligatorio = [NSNumber numberWithBool:[[attributeDict objectForKey:kEMKeyXMLObligatorio] boolValue]];
        pregunta.respuesta = [attributeDict objectForKey:kEMKeyXMLRespuesta];
        pregunta.texto = [attributeDict objectForKey:kEMKeyXMLTexto];
        pregunta.tipo = [attributeDict objectForKey:kEMKeyXMLTipo];
        pregunta.order = [NSNumber numberWithInteger:self.indexPregunta];
        [self.sondeo addEmPreguntasObject:pregunta];
        if (self.respuestas.count)
        {
            EMRespuesta * respuesta = [self.respuestas lastObject];
            pregunta.idParent = respuesta.idRespuesta;
        }
        self.indexPregunta++;
        [[EMManagedObject sharedInstance] saveLocalContext];
        [self.preguntas addObject:pregunta];
        
    }
    else if([elementName isEqualToString:kEMKeyXMLOpcionEncuesta])
    {
        EMPregunta * pregunta = [self.preguntas lastObject];
        NSString * idRespuesta = [EMRespuesta idEMRespuestaWithIdRespuesta:[attributeDict objectForKey:kEMKeyXMLId] idPregunta:pregunta.idPregunta idSondeo:[self.sondeo.idSondeo stringValue]];
        
        EMRespuesta * respuesta = [[EMManagedObject sharedInstance] respuestaForId:idRespuesta];
        respuesta.idRespuesta = idRespuesta;
        respuesta.order = [NSNumber numberWithInteger:self.indexRespuesta];
        respuesta.respuesta = [attributeDict objectForKey:kEMKeyXMLTexto];
        respuesta.emPregunta = pregunta;
        self.indexRespuesta ++;
        [[EMManagedObject sharedInstance] saveLocalContext];
        [self.respuestas addObject:respuesta];
        
    }
//    faltan las preguntas y respuestas
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:kEMKeyXMLPreguntaEncuesta])
    {
        [self.preguntas removeLastObject];
    }
    else if([elementName isEqualToString:kEMKeyXMLOpcionEncuesta])
    {
        [self.respuestas removeLastObject];
    }

}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"XML processing done!");
}

@end
