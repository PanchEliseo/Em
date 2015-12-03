//
//  EMServiceObjectMensajesConfigurables.m
//  emetrix
//
//  Created by Patricia Blanco on 31/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObjectMensajesConfigurables.h"
#import "EMMensajes.h"
@interface EMServiceObjectMensajesConfigurables()
@property (strong, nonatomic) EMMensajes * mensaje;
@end

@implementation EMServiceObjectMensajesConfigurables


- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    self = [super init];
    if (self)
    {
        self.user = user;
        self.account = account;
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@mensajes_configurables.php",self.pathURLService]];
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
        self.urlService = [NSURL URLWithString:[NSString stringWithFormat:@"%@mensajes_configurables.php",self.pathURLService]];
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

- (NSMutableDictionary *) createJsonPostForUser:(EMUser *) user andAccount:(EMCuenta *) account
{
    NSArray * arrayObjects = [NSArray arrayWithObjects:user.idUsuario, account.idCuenta,nil];
    
    NSArray * arrayKeys = [NSArray arrayWithObjects:@"idUsuario", @"idProyecto", nil];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjects:arrayObjects forKeys:arrayKeys];
    return dictionary;
}

- (void)parserJsonReponse:(NSXMLParser *) xmlParser withError:(NSError *) error xmlString: (NSString *) xmlString
{

         [[EMManagedObject sharedInstance] deleteAllMensajesForCuenta:self.account];
    NSRange range = [xmlString rangeOfString:@"|"];
    if (range.location != NSNotFound)
    {
        NSMutableArray * array = [[xmlString componentsSeparatedByString:@"|"] mutableCopy];
        int i = 0;
        for (NSString * string in array)
        {
            if (i % 2)
            {
                if (string.length && [string stringByReplacingOccurrencesOfString:@" " withString:@""].length)
                {
                    self.mensaje.mensaje = string;
                    [[EMManagedObject sharedInstance] saveLocalContext];
                }
            }
            else
            {
                if (string.length && [string stringByReplacingOccurrencesOfString:@" " withString:@""].length)
                {
                    self.mensaje = [[EMManagedObject sharedInstance] newMensaje];
                    self.mensaje.emCuenta = self.account;
                    self.mensaje.date = [[NSDate alloc] init];
                    if ([string hasPrefix:@"GENERAL"])
                    {
                        self.mensaje.tipo = [NSNumber numberWithInt:EMMensajeTypeGeneral];
                    }
                    else if ([string hasPrefix:@"INFORMATIVO"])
                    {
                        self.mensaje.tipo = [NSNumber numberWithInt:EMMensajeTypeInformativo];
                    }
                    else if ([string hasPrefix:@"ALERTA"])
                    {
                        self.mensaje.tipo = [NSNumber numberWithInt:EMMensajeTypeAlerta];
                    }
                    else if([string hasPrefix:@"FELICITACION"])
                    {
                        self.mensaje.tipo = [NSNumber numberWithInt:EMMensajeTypeFelicitacion];
                    }
                    
                }
            }
            i++;
        }

    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         if(!error)
         {
             //         Parse response
             //         delete all entitys emtiendaday
             if (self.customBlock)
             {
                 self.customBlock(YES,error);
             }
            
             
         }
         else
         {
             if (self.customBlock)
             {
                 self.customBlock(NO, error);
             }
             
         }
         
     }];
}
@end
