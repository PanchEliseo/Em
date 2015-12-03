//
//  EMServiceObjectSendPedidos.h
//  emetrix
//
//  Created by Carlos molina on 20/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectSendPedidos : EMServiceObject

- (instancetype)initWithPendiente:(EMPendiente *)pendiente;
- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;
@property (strong, nonatomic) EMPendiente * pendiente;

@end
