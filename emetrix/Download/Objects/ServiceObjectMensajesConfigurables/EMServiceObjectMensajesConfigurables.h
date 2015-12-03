//
//  EMServiceObjectMensajesConfigurables.h
//  emetrix
//
//  Created by Patricia Blanco on 31/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectMensajesConfigurables : EMServiceObject

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;

@property (strong, nonatomic) EMUser * user;
@property (strong, nonatomic) EMCuenta * account;

- (instancetype)initWithUser:(EMUser *) user andAccount:(EMCuenta *) account;

@end
