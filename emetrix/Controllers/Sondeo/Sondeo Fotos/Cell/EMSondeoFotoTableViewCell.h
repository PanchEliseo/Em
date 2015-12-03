//
//  EMSondeoFotoTableViewCell.h
//  emetrix
//
//  Created by Patricia Blanco on 10/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMSondeoFotoDelegate<NSObject>
- (void) didPressTakePhoto;
- (void) didPressSelectFromGallery;
@end

@interface EMSondeoFotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtFldComentario;
@property (weak, nonatomic) IBOutlet UISwitch *switchGuardar;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwCamera;
@property (strong, nonatomic) id<EMSondeoFotoDelegate> delegate;
@end
