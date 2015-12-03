//
//  EMServiceObjectFecha.h
//  emetrix
//
//  Created by Carlos molina on 22/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectFecha : EMServiceObject

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;


@end
