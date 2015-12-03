//
//  EMServiceObjectSondeosRespuestasOnline.h
//  emetrix
//
//  Created by Marco Antonio Flores Lopez on 06/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMServiceObject.h"

@interface EMServiceObjectSondeosRespuestasOnline : EMServiceObject

- (void)startDownloadWithCompletionBlock:(void (^) (BOOL successDownload, NSError * error))block;

@property (strong, nonatomic) EMUser * usuario;
@property (strong, nonatomic) EMCuenta * cuenta;
@property (strong, nonatomic) EMTienda * tienda;

- (instancetype)initWithUsuario:(EMUser *) usuario cuenta:(EMCuenta *) cuenta tienda:(EMTienda *) tienda;

@end
