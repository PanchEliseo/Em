//
//  UIImage+fixOrientation.h
//  emetrix
//
//  Created by Patricia Blanco on 16/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end
