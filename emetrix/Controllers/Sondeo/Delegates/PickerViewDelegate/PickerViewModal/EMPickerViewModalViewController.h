//
//  EMPickerViewModalViewController.h
//  emetrix
//
//  Created by Carlos molina on 15/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPickerViewModalViewController : UIViewController

@property(strong, nonatomic) NSMutableArray * preguntas;
@property(strong, nonatomic) EMPull * pull;
@property (nonatomic) NSInteger index;

@end
