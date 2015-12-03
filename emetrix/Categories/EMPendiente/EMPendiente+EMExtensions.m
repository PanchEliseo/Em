//
//  EMPendiente+EMExtensions.m
//  emetrix
//
//  Created by Patricia Blanco on 30/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMPendiente+EMExtensions.h"
#import "EMServiceObjectSendSondeos.h"
#import "EMServiceObjectSendVisitas.h"
#import "EMServiceObjectUploaderFoto.h"
#import "EMServiceObjectCheckIn-Out.h"
#import "EMServiceObjectLogsMovil.h"
#import "EMServiceObjectSendPedidos.h"

@implementation EMPendiente (EMExtensions)



- (void) setEstatus:(NSNumber *)estatus
{
    [self willChangeValueForKey:@"estatus"];
    [self setPrimitiveValue:estatus forKey:@"estatus"];
    [self didChangeValueForKey:@"estatus"];
    [self sendNotificationPendienteChange];
}
#pragma -mark NSNotificationCenter
- (void)receiveLocation:(NSNotification *) notification
{

    if([self.estatus integerValue] != EMPendienteStateSending || [self.estatus integerValue] != EMPendienteStateSend)
    {
        if([self.estatus integerValue] == EMPendienteStateWithOutLocation)
        {
            NSDictionary * dictionary = notification.object;
            NSString * stringLocation = [dictionary objectForKey:kEMQuestionTypeGPS];
            NSArray * arrayLocation = [stringLocation componentsSeparatedByString:kEMSeparatorLocalization];
            self.latitud = [NSNumber numberWithDouble:[[arrayLocation objectAtIndex:0] doubleValue]];
            self.longitud = [NSNumber numberWithDouble:[[arrayLocation objectAtIndex:1] doubleValue]];
            self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[EMManagedObject sharedInstance] saveLocalContext];

        }
        [self sendPendiente];

    }

}

- (void)sendPendiente
{
    if([self.tipo integerValue] == EMPendienteTypeSendSondeo)
    {

        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend)
        {
  
            EMServiceObjectSendSondeos * serviceSendSondeos = [[EMServiceObjectSendSondeos alloc] initWithPendiente:self];
            [serviceSendSondeos startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 NSLog(@"ya la respuesta del envio %d", successDownload);
                 if(successDownload)
                 {
                     //                    se envio toda la información
                    self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                    self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
             }];

        }
    }
    if([self.tipo integerValue] == EMPendienteTypeSendVisita)
    {
        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend && [self.estatus integerValue] != EMPendienteStateWithOutLocation)
        {
            EMServiceObjectSendVisitas * serviceSendVisitas = [[EMServiceObjectSendVisitas alloc] initWithPendiente:self];
            [serviceSendVisitas startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 if(successDownload)
                 {
                     //                    se envio toda la información
                    self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                    self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                     
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
                 
             }];
            
        }

    }
    if([self.tipo integerValue] == EMPendienteTypeSendFoto)
    {
        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend && [self.estatus integerValue] != EMPendienteStateWithOutLocation)
        {
            EMServiceObjectUploaderFoto * serviceSendFoto = [[EMServiceObjectUploaderFoto alloc] initWithPendiente:self];
            [serviceSendFoto startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 if(successDownload)
                 {
                     //                    se envio toda la información
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                     
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
                 
             }];
            
        }
        
    }
    
    if([self.tipo integerValue] == EMPendienteTypeCheckIn || [self.tipo integerValue] == EMPendienteTypeCheckOut)
    {
        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend && [self.estatus integerValue] != EMPendienteStateWithOutLocation)
        {
            EMServiceObjectCheckIn_Out * serviceSendCheck = [[EMServiceObjectCheckIn_Out alloc] initWithPendiente:self];
            [serviceSendCheck startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 if(successDownload)
                 {
                     //                    se envio toda la información
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                     
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
                 
             }];
            
        }
        
    }
    if([self.tipo integerValue] == EMPendienteTypeLogsMovil)
    {
        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend && [self.estatus integerValue] != EMPendienteStateWithOutLocation)
        {
            EMServiceObjectLogsMovil * serviceLogs = [[EMServiceObjectLogsMovil alloc] initWithPendiente:self];
            [serviceLogs startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 if(successDownload)
                 {
                     //                    se envio toda la información
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                     
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
                 
             }];
            
        }
        
    }
    
    if([self.tipo integerValue] == EMPendienteTypePedido)
    {
        if( [self.estatus integerValue] != EMPendienteStateSending && [self.estatus integerValue] != EMPendienteStateSend && [self.estatus integerValue] != EMPendienteStateWithOutLocation)
        {
            EMServiceObjectSendPedidos * servicePedidos = [[EMServiceObjectSendPedidos alloc] initWithPendiente:self];
            [servicePedidos startDownloadWithCompletionBlock:^(BOOL successDownload, NSError *error)
             {
                 if(successDownload)
                 {
                     //                    se envio toda la información
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStateSend];
                     
                 }
                 else
                 {
                     //                    no se envio la info
                     self.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
                     
                 }
                 [[EMManagedObject sharedInstance] saveLocalContext];
                 
             }];
            
        }
        
    }
    
    
    
    if([self.estatus integerValue] == EMPendienteStatePrepared)
    {
        self.estatus = [NSNumber numberWithInt:EMPendienteStateSending];
        self.dateSending = [[NSDate alloc] init];
    }
    [[EMManagedObject sharedInstance] saveLocalContext];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendNotificationPendienteChange
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kEMKeyNotificationChangePendiente
     object:nil];
}

@end
