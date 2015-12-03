//
//  EMServiceObjectValidaApp.h
//  emetrix
//
//  Created by Marco Antonio Flores Lopez on 21/10/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectValidaApp : EMServiceObject

@property (strong, nonatomic) NSString * response;

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;

@end
