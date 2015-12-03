//
//  EMSondeoCollectionViewDelegate.m
//  emetrix
//
//  Created by Patricia Blanco on 22/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoCollectionViewDelegate.h"
#import "EMMultipleOptionCollectionViewCell.h"
#import "NSObject+EMObjectExtension.h"
#import "TTCounterLabel.h"

@interface EMSondeoCollectionViewDelegate()

@end

@implementation EMSondeoCollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == kEMTagCollectionViewLabelTime)
    {
        return self.respuestasUsuario.count;
    }
    EMPregunta * pregunta = [self.preguntas objectAtIndex:collectionView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    
    return arrayRespuestasOrder.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMMultipleOptionCollectionViewCell * cell;
    if (collectionView.tag == kEMTagCollectionViewLabelTime)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEMKeyCellLabelTimeQuesIdentifier forIndexPath:indexPath];
        EMRespuestasUsuario * respuestaUsuario = [self.respuestasUsuario objectAtIndex:indexPath.row];
        
        TTCounterLabel * label = [[TTCounterLabel alloc] init];
        NSString * time = [label timeFormattedStringForValue:[EMSondeoCollectionViewDelegate unsignedLongLongValueFromString:respuestaUsuario.texto]];
        if (indexPath.row == 0)
        {
            cell.lbfRespuesta.text = [NSString stringWithFormat:@"Tiempo %ld = %@ - Restantes %lu",(indexPath.row + 1),time, ([self.pregunta.respuesta integerValue] - self.respuestasUsuario.count)];
        }
        else
        {

            cell.lbfRespuesta.text = [NSString stringWithFormat:@"Tiempo %ld = %@ ",(indexPath.row + 1),time];

        }
        return cell;
    }
    EMPregunta * pregunta = [self.preguntas objectAtIndex:collectionView.tag];
    NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
    EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:indexPath.row];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEMKeyCellMultipleQuesIdentifier forIndexPath:indexPath];
    cell.switchCell.on = ([[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull respuesta:respuesta].count)?YES:NO;
    
    cell.lbfRespuesta.text = respuesta.respuesta;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag != kEMTagCollectionViewLabelTime)
    {
        EMPregunta * pregunta = [self.preguntas objectAtIndex:collectionView.tag];
        NSMutableArray * arrayRespuestasOrder = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]];
        EMRespuesta * respuesta = [arrayRespuestasOrder objectAtIndex:indexPath.row];
        [EMSondeoCollectionViewDelegate sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:collectionView.tag];
        [collectionView reloadData];
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == kEMTagCollectionViewLabelTime)
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, kEMDefaultHeightLabelTimeCell);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, kEMDefaultHeightMultipleCell);
}






@end
