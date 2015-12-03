//
//  EMSondeoTextFieldDelegate.h
//  emetrix
//
//  Created by Patricia Blanco on 24/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSondeoTextFieldDelegate : NSObject<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray * preguntas;
@property (strong, nonatomic) EMPull * pull;

@end
