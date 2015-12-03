//
//  EMSondeoTextFieldDelegate.m
//  emetrix
//
//  Created by Patricia Blanco on 24/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoTextFieldDelegate.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMSondeoTextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:textField.tag];
    NSString * respuesta = textField.text;
    NSInteger index = textField.tag;
    [EMSondeoTextFieldDelegate sendAnswerUserNotificationWithPregunta:pregunta stringRespuesta:respuesta index:index];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
