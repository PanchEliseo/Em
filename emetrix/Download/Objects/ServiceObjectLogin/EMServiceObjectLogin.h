//
//  EMServiceObjectLogin.h
//  emetrix
//
//  Created by Patricia Blanco on 14/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectLogin : EMServiceObject

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;

@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) EMUser * user;

- (instancetype)initWithUsername:(NSString *) userName andPassword:(NSString *) password;

@end
