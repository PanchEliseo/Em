//
//  EMSondeoPickerViewDelegate.m
//  emetrix
//
//  Created by Patricia Blanco on 22/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoPickerViewDelegate.h"
#import "NSObject+EMObjectExtension.h"

@implementation EMSondeoPickerViewDelegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    return arrayRespuestasOrder.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:row];
    return respuesta.respuesta;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:row];
    [EMSondeoPickerViewDelegate sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:pickerView.tag];
}

- (void) selectQuestion:(UIPickerView *)pickerView
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
     NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    NSMutableArray * respuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
     BOOL selected = NO;
    if (respuestasUsuario && respuestasUsuario.count)
    {
        int i = 0;
       
        for (EMRespuesta * respuesta in arrayRespuestasOrder)
        {
            if ([respuesta.idRespuesta isEqualToString:((EMRespuestasUsuario *)[respuestasUsuario objectAtIndex:0]).idRespuesta])
            {
                [pickerView selectRow:i inComponent:0 animated:YES];
                selected = YES;
            }
            i++;
        }

    }
    if (!selected)
    {
        NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
        EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:0];
        [pickerView selectRow:0 inComponent:0 animated:YES];
        [EMSondeoPickerViewDelegate sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:pickerView.tag];
    }

}

#pragma -mark CZPickerView

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    return arrayRespuestasOrder.count;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:row];
    return respuesta.respuesta;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    EMPregunta * pregunta = [self.preguntas objectAtIndex:pickerView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:row];
    [EMSondeoPickerViewDelegate sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:pickerView.tag];
}


@end
