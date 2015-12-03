//
//  EMServiceObjectSendSondeos.h
//  emetrix
//
//  Created by Patricia Blanco on 29/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@class EMPendiente;

@interface EMServiceObjectSendSondeos : EMServiceObject

- (instancetype)initWithPendiente:(EMPendiente *)pendiente;
- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;
@property (strong, nonatomic) EMPendiente * pendiente;


@end