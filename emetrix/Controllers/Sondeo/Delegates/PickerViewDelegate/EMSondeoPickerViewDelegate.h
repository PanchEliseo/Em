//
//  EMSondeoPickerViewDelegate.h
//  emetrix
//
//  Created by Patricia Blanco on 22/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CZPickerView.h>

@interface EMSondeoPickerViewDelegate : NSObject<UIPickerViewDataSource, UIPickerViewDelegate, CZPickerViewDelegate, CZPickerViewDataSource>
@property(strong, nonatomic) NSMutableArray * preguntas;
@property(strong, nonatomic) EMPull * pull;
- (void)selectQuestion:(UIPickerView *)pickerView;

@end
