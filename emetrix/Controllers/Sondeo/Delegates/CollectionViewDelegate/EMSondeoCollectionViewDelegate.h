//
//  EMSondeoCollectionViewDelegate.h
//  emetrix
//
//  Created by Patricia Blanco on 22/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSondeoCollectionViewDelegate : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray * preguntas;
@property (strong, nonatomic) EMPull * pull;
@property (strong, nonatomic) NSMutableArray * respuestasUsuario;
@property (strong, nonatomic) EMPregunta * pregunta;

@end




