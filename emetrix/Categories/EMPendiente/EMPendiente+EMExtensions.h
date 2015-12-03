//
//  EMPendiente+EMExtensions.h
//  emetrix
//
//  Created by Patricia Blanco on 30/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMPendiente.h"

@interface EMPendiente (EMExtensions)

- (void)receiveLocation:(NSNotification *) notification;
- (void)sendPendiente;
- (void)sendNotificationPendienteChange;

@end
