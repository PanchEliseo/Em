//
//  EMServiceObjectCheckIn-Out.h
//  emetrix
//
//  Created by Patricia Blanco on 11/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectCheckIn_Out : EMServiceObject

- (instancetype)initWithPendiente:(EMPendiente *)pendiente;
- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;
@property (strong, nonatomic) EMPendiente * pendiente;


@end
