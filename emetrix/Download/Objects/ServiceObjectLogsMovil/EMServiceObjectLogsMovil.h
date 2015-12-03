//
//  EMServiceObjectLogsMovil.h
//  emetrix
//
//  Created by Patricia Blanco on 14/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectLogsMovil : EMServiceObject

- (instancetype)initWithPendiente:(EMPendiente *)pendiente;
- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;
@property (strong, nonatomic) EMPendiente * pendiente;

@end
