  //
//  EMSondeoViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 21/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoViewController.h"
#import "EMSondeoTableViewCell.h"
#import "UIViewController+STViewControllerExtension.h"
#import "NSObject+EMObjectExtension.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "EMSondeoCollectionViewDelegate.h"
#import "EMSondeoPickerViewDelegate.h"
#import "EMContainerViewController.h"
#import "EMSondeoTextFieldDelegate.h"
#import "JSImagePickerViewController.h"
#import "EMSondeoLocationDelegate.h"
#import "TTCounterLabel.h"
#import "NZAlertView.h"
#import "EMPendiente.h"
#import "EMPendiente+EMExtensions.h"
#import "UIViewController+ECSlidingViewController.h"
#import "EMRespuestasDefault.h"
#import "EMPickerViewModalViewController.h"
#import "EMSondeoPickerViewDelegate.h"
#import <CZPickerView.h>
#import "UIColor+EMColorExtension.h"
#import "NSObject+EMObjectExtension.h"
#import "UIImage+fixOrientation.h"


@interface EMSondeoViewController ()<UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate, JSImagePickerViewControllerDelegate, EMSondeoTableViewCellDelegate>
{
    NSMutableArray * emRespuestasDefaultTienda;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) MWPhotoBrowser * photoBrowser;
@property (strong, nonatomic) EMSondeoCollectionViewDelegate * collectionViewDelegate;
@property (strong, nonatomic) EMSondeoTextFieldDelegate * textFieldDelegate;
@property (strong, nonatomic) EMSondeoLocationDelegate * locationDelegate;
@property (strong, nonatomic) NSMutableArray * arrayPreguntas;
@property (strong, nonatomic) EMPull * pull;
@property (nonatomic) NSInteger indexPhoto;
@property (strong, nonatomic) EMPendiente * pendiente;
@property (strong, nonatomic) EMSondeoPickerViewDelegate * pickerDelegate;

@end

@implementation EMSondeoViewController

- (EMSondeoPickerViewDelegate *)pickerDelegate
{
    if(!_pickerDelegate)
    {
        _pickerDelegate = [[EMSondeoPickerViewDelegate alloc] init];
    }
    return _pickerDelegate;
}

- (void) setSondeo:(EMSondeo *)sondeo
{
    _sondeo = sondeo;
}

- (void)getArrayPreguntas
{
    if (!self.arrayPreguntas || self.arrayPreguntas.count == 0)
    {
        if ([self.sondeo.idSondeo integerValue] == EMSondeoStaticFotos ||
            [self.sondeo.idSondeo integerValue] == EMSondeoStaticFotoGaleria ||
            [self.sondeo.idSondeo integerValue] == EMSondeoStaticNuevaTienda ||
            [self.sondeo.idSondeo integerValue] == EMSondeoStaticAsistencia)
        {
            self.arrayPreguntas = [[EMManagedObject sharedInstance] mutableArrayStaticPreguntasForSondeo:_sondeo cuenta:self.cuenta];
        }
        else
        {
            self.arrayPreguntas = [[EMManagedObject sharedInstance] mutableArrayPreguntasForSondeo:_sondeo];
        }
    }

    NSMutableArray * arrayPreguntas = [self.arrayPreguntas copy];
    if (self.pull)
    {
        NSMutableArray * arrayRespuestasUsuario = [[self.pull.emRespuestasUsuario allObjects] mutableCopy];
        for (EMRespuestasUsuario * respuestasUsuario in arrayRespuestasUsuario)
        {
            BOOL respuesta = [[EMManagedObject sharedInstance] existRespuestaForId:respuestasUsuario.idRespuesta];
            if (respuesta)
            {
                [self verifyNextQuestionToAnswer:[[EMManagedObject sharedInstance] respuestaForId:respuestasUsuario.idRespuesta]];
                if (self.arrayPreguntas.count != arrayPreguntas.count)
                {
                    [self getArrayPreguntas];
                    break;
                }
                
            }
        }
    }
    if (self.arrayPreguntas && [self.sondeo.idSondeo intValue] == EMSondeoStaticNuevaTienda)
    {
        NSString * idPregunta = [EMSondeoViewController idEMPreguntaWithIdPregunta:kEMIdQuestionSelection idCuenta:[self.cuenta.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]];
        if ([[EMManagedObject sharedInstance] existPreguntaForId:idPregunta])
        {

           EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
            if ([self.arrayPreguntas containsObject:pregunta])
            {
                [self.arrayPreguntas removeObject:pregunta];
            }
        }
    }

}

- (NSMutableArray *)photos
{
    if(!_photos)
    {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (MWPhotoBrowser *)photoBrowser
{

    _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _photoBrowser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    _photoBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    _photoBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    _photoBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    _photoBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    _photoBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    _photoBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    _photoBrowser.autoPlayOnAppear = NO; // Auto-play first video
    [_photoBrowser setCurrentPhotoIndex:0];
    return _photoBrowser;
}

- (EMSondeoCollectionViewDelegate *) collectionViewDelegate
{
    if(!_collectionViewDelegate)
    {
        _collectionViewDelegate = [[EMSondeoCollectionViewDelegate alloc] init];
    }
    return _collectionViewDelegate;
}

- (EMSondeoTextFieldDelegate *) textFieldDelegate
{
    if(!_textFieldDelegate)
    {
        _textFieldDelegate = [[EMSondeoTextFieldDelegate alloc] init];
    }
    return _textFieldDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self containerParentViewController].cuenta) {
        self.cuenta = [self containerParentViewController].cuenta;
    }
    
    if ([self containerParentViewController].user) {
        self.usuario = [self containerParentViewController].user;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.pull = [self generatePullID];
    self.pull.estado = [NSNumber numberWithInt:EMPullStateIncomplete];
    [self getArrayPreguntas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAnswerUser:)
                                                 name:kEMKeyNotificationUserAnswer
                                               object:nil];
    
    NSPredicate * predicate;
    
    emRespuestasDefaultTienda = [[EMManagedObject sharedInstance] respuestasDefaultForCuenta:self.cuenta tienda:self.tienda sondeo:self.sondeo];
    
    for (EMRespuestasDefault * respuestaDefault in emRespuestasDefaultTienda)
        //for (EMRespuestasDefault * respuestaDefault in self.sondeo.emRespuestasDefault)
    {
        EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:respuestaDefault.idPregunta];
        
        predicate = [NSPredicate predicateWithFormat:@"emPull.idPull==%@", self.pull.idPull];
        NSSet * respuestasUsuarioPull = [pregunta.emRespuestasUsuario filteredSetUsingPredicate:predicate];
        
        if (!respuestasUsuarioPull.count)
        {
            NSInteger index = [self.arrayPreguntas indexOfObject:pregunta];
            if([pregunta.tipo isEqualToString:kEMQuestionTypeAbierta] ||
               [pregunta.tipo isEqualToString:kEMQuestionTypeDecimal] ||
               [pregunta.tipo isEqualToString:kEMQuestionTypeNumerica])
            {
                [EMSondeoViewController sendAnswerUserNotificationWithPregunta:pregunta
                                                               stringRespuesta:respuestaDefault.respuesta
                                                                         index:index];
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeFoto])
            {
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeGPS])
            {
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeImagen])
            {
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeInformativo])
            {
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeMultipleSeleccion])
            {
                NSArray * array = [respuestaDefault.respuesta componentsSeparatedByString:@","];
                for (NSString * idRespuesta in array)
                {
                    NSString * idRespuestaFormat = [EMRespuesta idEMRespuestaWithIdRespuesta:idRespuesta idPregunta:pregunta.idPregunta idSondeo:[self.sondeo.idSondeo stringValue]];
                    if ([[EMManagedObject sharedInstance] existRespuestaForId:idRespuestaFormat])
                    {
                        EMRespuesta * respuesta = [[EMManagedObject sharedInstance] respuestaForId:idRespuestaFormat];
                        [EMSondeoViewController sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:index];
                    }
                    
                }
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
            {
            }
            else if ([pregunta.tipo isEqualToString:kEMQuestionTypeUnicaRadio])
            {
                NSString * idRespuesta = [EMRespuesta idEMRespuestaWithIdRespuesta:respuestaDefault.respuesta idPregunta:pregunta.idPregunta idSondeo:[self.sondeo.idSondeo stringValue]];
                if ([[EMManagedObject sharedInstance] existRespuestaForId:idRespuesta])
                {
                    EMRespuesta * respuesta = [[EMManagedObject sharedInstance] respuestaForId:idRespuesta];
                    [EMSondeoViewController sendAnswerUserNotificationWithPregunta:pregunta respuesta:respuesta index:index];
                }
            }
            
        }
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    self.title = self.sondeo.nombre;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayPreguntas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSondeoTableViewCell * cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoOpenIdentifier forIndexPath:indexPath];
    EMPregunta * pregunta = [self.arrayPreguntas objectAtIndex:indexPath.row];
    if([pregunta.tipo isEqualToString:kEMQuestionTypeAbierta] ||
       [pregunta.tipo isEqualToString:kEMQuestionTypeDecimal] ||
       [pregunta.tipo isEqualToString:kEMQuestionTypeNumerica])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoOpenIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoOpenIdentifier];
        }
        if([self.productSku isEqualToString:@"si"]){
            //aqui poner las preguntas si el producto esta capturado
            NSLog(@"el tipo %d", self.tipo);
            if(self.tipo == 1){
                NSMutableArray * test = [[EMManagedObject sharedInstance] mutableArrayAnswerUser];
                for(int cont=0; cont<[test count]; cont++){
                    EMRespuestasUsuario * test1 = [test objectAtIndex:cont];
                    NSLog(@"que ----- %@", test1.texto);
                }
                NSLog(@"entro aqui %@ -- %@ -- %@", pregunta, self.pull, self.sku);
                // obtener la respuesta del usuario y mostrala solo si es el sondeo capturado
                NSMutableArray * arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForSku:pregunta pull:self.pull producto:self.producto];
                if (arrayAnswerUser && arrayAnswerUser.count)
                {
                    EMRespuestasUsuario * respuestaUsuario = [arrayAnswerUser objectAtIndex:0];
                    cell.txtFldAnswer.text = respuestaUsuario.texto;
                }
                else
                {
                    cell.txtFldAnswer.text = @"";
                }
            }
        }else{
            NSMutableArray * arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
            if (arrayAnswerUser && arrayAnswerUser.count)
            {
                EMRespuestasUsuario * respuestaUsuario = [arrayAnswerUser objectAtIndex:0];
                cell.txtFldAnswer.text = respuestaUsuario.texto;
            }
            else
            {
                cell.txtFldAnswer.text = @"";
            }
        }
        cell.txtFldAnswer.tag = indexPath.row;
        self.textFieldDelegate.pull = self.pull;
        self.textFieldDelegate.preguntas = self.arrayPreguntas;
        cell.txtFldAnswer.delegate = self.textFieldDelegate;
        if([pregunta.tipo isEqualToString:kEMQuestionTypeAbierta])
        {
            cell.txtFldAnswer.keyboardType = UIKeyboardTypeAlphabet;
        }
        else if ([pregunta.tipo isEqualToString:kEMQuestionTypeDecimal])
        {
            cell.txtFldAnswer.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else if ([pregunta.tipo isEqualToString:kEMQuestionTypeNumerica])
        {
            cell.txtFldAnswer.keyboardType = UIKeyboardTypeNumberPad;
        }

    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeFoto])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoFotoIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoFotoIdentifier];
        }
        cell.delegate = self;
        cell.imgVwBackgroundIcon.tag = indexPath.row;
        cell.imgVwIconTouch.tag = indexPath.row;
        __block NSMutableArray * arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
        if (arrayAnswerUser && arrayAnswerUser.count)
        {
            __block UIImage * image;
            __block EMSondeoTableViewCell * cellImage = cell;
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Add code here to do background processing
                //
                //
                image = [self decodeBase64ToImage:((EMRespuestasUsuario *)[arrayAnswerUser objectAtIndex:0]).texto];
                dispatch_async( dispatch_get_main_queue(), ^
                               {
                                   // Add code here to update the UI/send notifications based on the
                                   // results of the background processing
                                   cellImage.imgVwBackgroundIcon.image = image;
                               });
            });
            
            cell.imgVwIconTouch.hidden = YES;
            cell.imgVwBackgroundIcon.hidden = NO;
        }
        else
        {
            cell.imgVwIconTouch.image = [UIImage imageNamed:@"icon_camera"];
            cell.imgVwIconTouch.hidden = NO;
            cell.imgVwBackgroundIcon.hidden = YES;
        }
        
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeGPS])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoGPSIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoGPSIdentifier];
        }
        
        cell.delegate = self;
        NSMutableArray * arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
        cell.imgVwIconTouch.tag = indexPath.row;
        cell.imgVwIconTouch.image = [UIImage imageNamed:@"icon_location"];

        if (arrayAnswerUser && arrayAnswerUser.count)
        {
            NSString * answer = ((EMRespuestasUsuario *)[arrayAnswerUser objectAtIndex:0]).texto;
            NSArray * array = [answer componentsSeparatedByString:kEMSeparatorLocalization];
            cell.lbfLocation.text = [NSString stringWithFormat:@"Latitud:%@ Longitud:%@",[array objectAtIndex:0],[array objectAtIndex:1]];
            cell.lbfLocation.hidden = NO;
        }
        else
        {
            cell.lbfLocation.hidden = YES;
        }

        
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeImagen])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoImagenIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoImagenIdentifier];
        }
        cell.delegate = self;
        cell.imgVwShow.image = [self decodeBase64ToImage:((EMRespuesta *)[[pregunta.emRespuestas allObjects] objectAtIndex:0]).respuesta];
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeInformativo])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoInformIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoInformIdentifier];
        }
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeMultipleSeleccion])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoMultipleIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoMultipleIdentifier];
        }
        cell.collectionView.tag = indexPath.row;
        self.collectionViewDelegate.preguntas = self.arrayPreguntas;
        self.collectionViewDelegate.pull = self.pull;
        cell.collectionView.delegate = self.collectionViewDelegate;
        cell.collectionView.dataSource = self.collectionViewDelegate;
        cell.collectionViewHeightConstraint.constant = (kEMDefaultHeightMultipleCell * [pregunta.emRespuestas allObjects].count + 10 * [pregunta.emRespuestas allObjects].count);
        [self.view updateConstraintsIfNeeded];
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoTiempoIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoTiempoIdentifier];
        }
        cell.delegate = self;
        cell.lbfTimeCounter.tag = indexPath.row;
         NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
        cell.collectionViewHeightConstraint.constant = 0;
        if (arrayRespuestasUsuario && arrayRespuestasUsuario.count)
        {
            cell.collectionViewHeightConstraint.constant = (kEMDefaultHeightLabelTimeCell + 5) * arrayRespuestasUsuario.count;
            self.collectionViewDelegate.pregunta = pregunta;
            self.collectionViewDelegate.respuestasUsuario = arrayRespuestasUsuario;
            cell.collectionView.delegate = self.collectionViewDelegate;
            cell.collectionView.dataSource = self.collectionViewDelegate;
        }
        [cell.contentView updateConstraintsIfNeeded];
        
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeUnicaRadio])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoUnicaIdentifier forIndexPath:indexPath];
        

        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoUnicaIdentifier];
        }
        cell.delegate = self;
        cell.btnShowPickerView.tag = indexPath.row;
        
        NSMutableArray * arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
        
        if (arrayAnswerUser && arrayAnswerUser.count)
        {
            NSString * answer = ((EMRespuestasUsuario *)[arrayAnswerUser objectAtIndex:0]).texto;
            [cell.btnShowPickerView setTitle:answer forState:UIControlStateNormal];
            
        }
        else
        {
            [cell.btnShowPickerView setTitle:@"-Seleccione-" forState:UIControlStateNormal];
        }

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellSondeoOpenIdentifier forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[EMSondeoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEMKeyCellSondeoOpenIdentifier];
        }
    }
    cell.lbfQuestion.text = pregunta.texto;
    CGFloat sizeHeight = [EMSondeoTableViewCell cellSizeForText:pregunta.texto withHeight:22 andWidth:[UIScreen mainScreen].bounds.size.width - 20].height;
    cell.constraintHeightLbfQuestion.constant = sizeHeight;
    cell.contentView.tag = indexPath.row;
    [cell.contentView updateConstraints];
    [self.view updateConstraints];
    
    return cell;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMPregunta * pregunta = [self.arrayPreguntas objectAtIndex:indexPath.row];
    CGSize sizeAnswer = [EMSondeoTableViewCell cellSizeForText:pregunta.texto withHeight:22 andWidth:[UIScreen mainScreen].bounds.size.width - 20];
    if([pregunta.tipo isEqualToString:kEMQuestionTypeAbierta] || [pregunta.tipo isEqualToString:kEMQuestionTypeDecimal] || [pregunta.tipo isEqualToString:kEMQuestionTypeNumerica])
    {
        return 115 + sizeAnswer.height;
        
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeFoto])
    {
        return 250 + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeGPS])
    {
        return 250 + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeImagen])
    {
        return 300 + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeInformativo])
    {
        return 55 + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeMultipleSeleccion])
    {
        return (45 + kEMDefaultHeightMultipleCell * [pregunta.emRespuestas allObjects].count + 10 * [pregunta.emRespuestas allObjects].count) + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
    {
        NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
        if (arrayRespuestasUsuario && arrayRespuestasUsuario.count)
        {
            return (145 + (arrayRespuestasUsuario.count * (kEMDefaultHeightLabelTimeCell + 5))) + sizeAnswer.height;
        }
        return 145 + sizeAnswer.height;
    }
    else if ([pregunta.tipo isEqualToString:kEMQuestionTypeUnicaRadio])
    {
        return 50 + sizeAnswer.height;
    }

    return 0;
}


#pragma mark - IBActions
- (IBAction)didPressSondeos:(id)sender
{
    NSLog(@"que traeee %d", self.tipo);
    if(self.tipo == 0){
        NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"No se puede volver si no has enviado las respuestas"]];
        [alert show];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didPressSend:(id)sender
{
    [self.view endEditing:YES];
    BOOL questionsComplete = YES;
    for (EMPregunta * pregunta in self.arrayPreguntas)
    {
        if ([pregunta.obligatorio boolValue])
        {
            NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
            if ((!arrayRespuestasUsuario || !arrayRespuestasUsuario.count) || ([pregunta.tipo isEqualToString:kEMQuestionTypeUnicaRadio] && [[EMSondeoViewController idRespuestaToSendWithIdEMRespuesta:((EMRespuestasUsuario *)[arrayRespuestasUsuario objectAtIndex:0]).idRespuesta] isEqualToString:@"3"]))
            {
                questionsComplete = NO;
                NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:[NSString stringWithFormat:@"Es necesario responder la pregunta %@",pregunta.texto]];
                [alert show];
                break;
            }
        }
    }
    if (questionsComplete)
    {
        //        send sondeo
        NSMutableString * stringToSend = [NSMutableString stringWithString:@""];
        
        for(EMPregunta * pregunta in self.arrayPreguntas)
        {
            if(![pregunta.tipo isEqualToString:kEMQuestionTypeInformativo] && ![pregunta.tipo isEqualToString:kEMQuestionTypeImagen] && pregunta.emRespuestasUsuario.count)
            {
                NSMutableArray * arrayAnswerUser;
                if([self.productSku isEqualToString:@"si"]){
                    NSLog(@"a crear %@ -- %@ -- %@", pregunta, self.pull, self.sku);
                    arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForSku:pregunta pull:self.pull producto:self.producto];
                }else{
                    arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
                }
                //arrayAnswerUser = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
                [stringToSend appendString:([self.sondeo.idSondeo intValue] == EMSondeoStaticNuevaTienda ?[EMSondeoViewController idPreguntaWithIdEMPregunta:pregunta.idPregunta] : pregunta.idPregunta)];
                int indexRespuestaUsuario = 0;
                unsigned long long time = 0;
                for(EMRespuestasUsuario * respuestaUsuario in arrayAnswerUser)
                {
                    if([self.productSku isEqualToString:@"si"]){
                        respuestaUsuario.emProducto = self.producto;
                    }
                    
                    if ([[EMManagedObject sharedInstance] existRespuestaForId:respuestaUsuario.idRespuesta])
                    {
                        //                       Contiene respuestas definidas
                        if (indexRespuestaUsuario == 0)
                        {
                            [stringToSend appendString:[NSString stringWithFormat:@"|%@|%@|",respuestaUsuario.texto,[EMSondeoViewController idRespuestaToSendWithIdEMRespuesta:respuestaUsuario.idRespuesta]]];
                            
                        }
                        else
                        {
                            [stringToSend appendString:[NSString stringWithFormat:@"%@|%@|",respuestaUsuario.texto,[EMSondeoViewController idRespuestaToSendWithIdEMRespuesta:respuestaUsuario.idRespuesta]]];
                        }
                        
                    }
                    else
                    {
                        //                    La respuesta la creo el usuario
                        if ([pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
                        {
                            TTCounterLabel * label = [[TTCounterLabel alloc] init];
                            time = time + [EMSondeoViewController unsignedLongLongValueFromString:respuestaUsuario.texto];
                            NSString * timeResponse = [label timeFormattedToSendStringForValue:[EMSondeoViewController unsignedLongLongValueFromString:respuestaUsuario.texto]];
                            NSString * timeFinally = [label timeFormattedToSendStringForValue:time];
                            if (indexRespuestaUsuario == 0)
                            {
                                if (indexRespuestaUsuario + 1 == arrayAnswerUser.count)
                                {
                                    [stringToSend appendString:[NSString stringWithFormat:@"|%@||",timeResponse]];
                                }
                                else
                                {
                                    [stringToSend appendString:[NSString stringWithFormat:@"|%@",timeResponse]];
                                }
                                
                            }
                            else if(indexRespuestaUsuario + 1 == arrayAnswerUser.count)
                            {
                                [stringToSend appendString:[NSString stringWithFormat:@",%@,%@||",timeResponse,timeFinally]];
                            }
                            else
                            {
                                [stringToSend appendString:[NSString stringWithFormat:@",%@",timeResponse]];
                            }
                            
                        }
                        else
                        {
                            [stringToSend appendString:[NSString stringWithFormat:@"|%@||",respuestaUsuario.texto]];
                        }
                        
                    }
                    
                    indexRespuestaUsuario ++;
                }
                [stringToSend appendString:@"|"];
            }
            
        }
        //        Creamos el pendiente del sondeo
        EMPendiente * pendienteSondeo = [[EMManagedObject sharedInstance] newPendiente];
        NSDate * today = [NSDate date];
        pendienteSondeo.date = today;
        pendienteSondeo.idPendiente = [EMSondeoViewController stringServiceFromDate:pendienteSondeo.date];
        pendienteSondeo.determinanteGPS = self.tienda.idTienda;
        pendienteSondeo.idSondeo = self.sondeo.idSondeo;
        pendienteSondeo.cadenaPendiente = stringToSend;
        pendienteSondeo.tipo = [NSNumber numberWithInteger:EMPendienteTypeSendSondeo];
        pendienteSondeo.estatus = [NSNumber numberWithInteger:EMPendienteStatePrepared];
        if(self.sku && self.sku.length)
        {
            pendienteSondeo.sku = self.sku;
        }
        pendienteSondeo.emCuenta = self.cuenta;
        //        Creamos el pendiente de la visita
        if ([self.sondeo.idSondeo intValue] != EMSondeoStaticNuevaTienda)
        {
            EMPendiente * pendienteVisita = [[EMManagedObject sharedInstance] newPendiente];
            pendienteVisita.date = pendienteSondeo.date;
            pendienteVisita.idPendiente = [EMSondeoViewController stringServiceFromDate:pendienteVisita.date];
            pendienteVisita.determinanteGPS = self.tienda.idTienda;
            pendienteVisita.idSondeo = self.sondeo.idSondeo;
            pendienteVisita.cadenaPendiente = stringToSend;
            pendienteVisita.tipo = [NSNumber numberWithInteger:EMPendienteTypeSendVisita];
            pendienteVisita.estatus = [NSNumber numberWithInteger:EMPendienteStateWithOutLocation];
            pendienteVisita.emCuenta = self.cuenta;
        }
        
        [self pendienteLogMovilForTag:kEMPendienteTagSondeo];
        self.sondeo.emPull.estado = [NSNumber numberWithInt:EMStatusTypeVisited];
        if ([self.sondeo.idSondeo intValue] == EMSondeoStaticNuevaTienda)
        {
            NSString * nombreTienda = @"";
            NSArray * locationTienda;
            
            //        creamos el pendiente para la nueva tienda y creamos la nueva tienda
            NSString * idPregunta = [EMSondeoViewController idEMPreguntaWithIdPregunta:kEMIdQuestionSelection idCuenta:[self.cuenta.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]];
            if ([[EMManagedObject sharedInstance] existPreguntaForId:idPregunta])
            {
                EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
                for (EMRespuesta * respuesta in [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:[[pregunta.emRespuestas allObjects] mutableCopy]])
                {

                    NSString * idRespuesta = [EMSondeoViewController idRespuestaToSendWithIdEMRespuesta:respuesta.idRespuesta];
                    NSString * idPreguntaRespuesta = [EMSondeoViewController idEMPreguntaWithIdPregunta:idRespuesta idCuenta:[self.cuenta.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]];
                    if ([[EMManagedObject sharedInstance] existPreguntaForId:idPreguntaRespuesta])
                    {
                        EMPregunta * preguntaText = [[EMManagedObject sharedInstance] preguntaForId:idPreguntaRespuesta];
                        if([preguntaText.emRespuestasUsuario allObjects].count)
                        {
                            EMRespuestasUsuario * respuestaUsuario = [[preguntaText.emRespuestasUsuario allObjects] objectAtIndex:0];
                            if (nombreTienda.length == 0)
                            {
                                nombreTienda = [NSString stringWithFormat:@"%@%@ ",nombreTienda,respuestaUsuario.texto];
                            }
                            else
                            {
                               nombreTienda = [NSString stringWithFormat:@"%@%@",nombreTienda,respuestaUsuario.texto];
                            }
                            
                        }
                        
                    }
                }
            }
            idPregunta = [EMSondeoViewController idEMPreguntaWithIdPregunta:kEMIdQuestionLocation idCuenta:[self.cuenta.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]];
            
            if ([[EMManagedObject sharedInstance] existPreguntaForId:idPregunta])
            {
                EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:idPregunta];
                if (pregunta.emRespuestasUsuario.count)
                {
                    EMRespuestasUsuario * respuestaUsuario = [[pregunta.emRespuestasUsuario allObjects] objectAtIndex:0];
                    locationTienda = [respuestaUsuario.texto componentsSeparatedByString:kEMSeparatorLocalization];
                }
            }
            
            EMTienda * tienda = [[EMManagedObject sharedInstance] tiendaForId:[EMSondeoViewController idNuevaTienda:self.cuenta]];
            tienda.idTienda = [EMSondeoViewController idNuevaTienda:self.cuenta];
            tienda.nombre = nombreTienda;
            if (locationTienda.count)
            {
                tienda.latitud = [NSNumber numberWithDouble:[[locationTienda objectAtIndex:0] doubleValue]];
                tienda.longitud = [NSNumber numberWithDouble:[[locationTienda objectAtIndex:1] doubleValue]];
            }
            [tienda addEmCuentasObject:self.cuenta];
            [tienda addEmProductos:self.cuenta.emProductos];
            [tienda addEmSondeos:self.cuenta.emSondeos];
            [tienda addEmTiendasXdiaObject:[[EMManagedObject sharedInstance] tiendasXdiaForId:[EMSondeoViewController tiendaXDiaIDWithDate:[[NSDate alloc] init] user:self.usuario cuenta:self.cuenta]]];
            pendienteSondeo.idNuevaTienda = tienda.idTienda;
            [[EMManagedObject sharedInstance] saveLocalContext];


        }
        
        [[EMManagedObject sharedInstance] saveLocalContext];
        [[self containerParentViewController] sendPendientes];
        
        if (self.parentViewController.class == [UIPageViewController class]) {
            if(![self.productSku isEqualToString:@"si"]){
                [[EMManagedObject sharedInstance] deleteRespuestasUsuario:[[self.pull.emRespuestasUsuario allObjects] mutableCopy]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^
             {
                 if(![self.productSku isEqualToString:@"si"]){
                     //    Borrar datos
                     [[EMManagedObject sharedInstance] deleteRespuestasUsuario:[[self.pull.emRespuestasUsuario allObjects] mutableCopy]];
                 }
             }];
        }
    }
}

- (IBAction)tapImage:(UIImage *)sender
{
    [self.photos removeAllObjects];
    [self. photos addObject:[MWPhoto photoWithImage: sender]];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
}

- (void)didTapShowPickerView:(UIButton *)sender
{
//    EMPickerViewModalViewController * modal = [self.storyboard instantiateViewControllerWithIdentifier:kEMStoryBoardPickerModal];
//    modal.pull = self.pull;
//    modal.preguntas = self.arrayPreguntas;
//    modal.index = sender.tag;
//    
//    [UIApplication sharedApplication].delegate.window.rootViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    modal.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:modal animated:YES completion:nil];
//    EMPregunta * pregunta = [self.arrayPreguntas objectAtIndex:sender.tag];
    
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Seleccione una opción"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.headerBackgroundColor = [UIColor emDarkBlueColor];
    picker.tag = sender.tag;
    self.pickerDelegate.pull = self.pull;
    self.pickerDelegate.preguntas = self.arrayPreguntas;
//    [self.pickerViewDelegate selectQuestion:self.pickerView];
    picker.delegate = self.pickerDelegate;
    picker.dataSource = self.pickerDelegate;
    [picker show];
    
}


- (void)didPressGallery:(UIButton *)sender
{
    self.indexPhoto = sender.tag;
    JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (void)didPressLocation:(UIButton *)sender
{
    self.locationDelegate = [[EMSondeoLocationDelegate alloc] initWithPreguntas:self.arrayPreguntas index:sender.tag];
    [self.locationDelegate getCurrentLocation];
}

- (void)didPressTime:(TTCounterLabel *)label
{
    if (label.isRunning)
    {
        EMPregunta * pregunta = [self.arrayPreguntas objectAtIndex:label.tag];
        [label stop];
        NSString *strTime = [NSString stringWithFormat:@"%llu", label.value];
        [EMSondeoViewController sendAnswerUserNotificationWithPregunta:pregunta stringRespuesta:strTime index:label.tag];
    }
    else
    {
        [label reset];
        [label start];
    }

}

#pragma -mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma -mark EMSondeosVerifyAnswers

- (void)verifyNextQuestionToAnswer:(EMRespuesta *) respuesta
{
//    Se suma uno para insertar despues de la pregunta que dispara las subpreguntas
//    index++;
    NSMutableArray * array = [[EMManagedObject sharedInstance] mutableArrayPreguntasForRespuesta:respuesta];
    if(array)
    {
//        NSMutableArray * arrayIndexPath = [[NSMutableArray alloc] init];
        for(EMPregunta * pregunta in array)
        {
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            [arrayIndexPath addObject:indexPath];
            if (![self.arrayPreguntas containsObject:pregunta])
            {
                [self.arrayPreguntas addObject:pregunta];
            }

//            index++;
        }
        self.arrayPreguntas = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:self.arrayPreguntas];
//        [self.tableView insertRowsAtIndexPaths:arrayIndexPath withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)verifyPreviusQuestionToAnswer:(EMRespuesta *) respuesta
{
    NSMutableArray * array = [[EMManagedObject sharedInstance] mutableArrayPreguntasForRespuesta:respuesta];

    if (array && array.count && respuesta.idRespuesta)
    {
        for (EMPregunta * pregunta in array)
        {
            NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
            for (EMRespuestasUsuario * respuestaUsuario in arrayRespuestasUsuario)
            {
                 BOOL respuesta = [[EMManagedObject sharedInstance] existRespuestaForId:respuestaUsuario.idRespuesta];
                if (respuesta)
                {
                    [self verifyPreviusQuestionToAnswer:[[EMManagedObject sharedInstance] respuestaForId:respuestaUsuario.idRespuesta]];

                }
                [[EMManagedObject sharedInstance] deleteEntity:respuestaUsuario];
                
            }
            if ([self.arrayPreguntas containsObject:pregunta])
            {
                [self.arrayPreguntas removeObject:pregunta];
            }
            
        }
    }
}

- (void)verifyAnswerUserFromQuestion:(EMPregunta *) pregunta answer:(EMRespuesta *) answer answerUser:(NSString *) answerUser indexQuestion:(NSInteger) index;
{
    NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
    
    if (arrayRespuestasUsuario && arrayRespuestasUsuario.count)
    {
//        ya contiene respuestas
        if([pregunta.tipo isEqualToString:kEMQuestionTypeAbierta] || [pregunta.tipo isEqualToString:kEMQuestionTypeDecimal] || [pregunta.tipo isEqualToString:kEMQuestionTypeNumerica] || [pregunta.tipo isEqualToString:kEMQuestionTypeFoto] || [pregunta.tipo isEqualToString:kEMQuestionTypeGPS] || [pregunta.tipo isEqualToString:kEMQuestionTypeImagen] || [pregunta.tipo isEqualToString:kEMQuestionTypeInformativo] || [pregunta.tipo isEqualToString:kEMQuestionTypeUnicaRadio])
        {
//            Traer la respuesta anterior
            EMRespuestasUsuario * respuestaUsuario = [arrayRespuestasUsuario objectAtIndex:0];
            [self verifyPreviusQuestionToAnswer:[[EMManagedObject sharedInstance] respuestaForId:respuestaUsuario.idRespuesta]];
            respuestaUsuario.idRespuesta = answer.idRespuesta;
            respuestaUsuario.texto = answerUser;
            respuestaUsuario.emPregunta = pregunta;
            respuestaUsuario.emPull = self.pull;
            [[EMManagedObject sharedInstance] saveLocalContext];
            [self verifyNextQuestionToAnswer:answer];
            

            
            
        }
        else if ([pregunta.tipo isEqualToString:kEMQuestionTypeMultipleSeleccion] || [pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
        {
//            Contiene varias respuestas
            BOOL isAdd = NO;
            for (EMRespuestasUsuario * respuestaUsuario in arrayRespuestasUsuario)
            {
                if ([respuestaUsuario.idRespuesta isEqualToString:answer.idRespuesta])
                {
                    isAdd = YES;
//                    Se encontraba la respuesta por lo tanto borrarla
                    [self verifyPreviusQuestionToAnswer:[[EMManagedObject sharedInstance] respuestaForId:respuestaUsuario.idRespuesta]];
                    [[EMManagedObject sharedInstance] deleteRespuestaUsuario:respuestaUsuario];
                }
            }
//            la respuesta no estaba por lo tanto hay que agregarla
            if (!isAdd)
            {
                EMRespuestasUsuario * respuestaUsuario = [[EMManagedObject sharedInstance] newRespuestaUsuario];
                respuestaUsuario.idRespuesta = answer.idRespuesta;
                respuestaUsuario.texto = answerUser;
                respuestaUsuario.emPregunta = pregunta;
                respuestaUsuario.emPull = self.pull;
                [[EMManagedObject sharedInstance] saveLocalContext];
                [self verifyNextQuestionToAnswer:answer];
            }
            
        }
    }
    else
    {
//        la respuesta es nueva
        EMRespuestasUsuario * respuestaUsuario = [[EMManagedObject sharedInstance] newRespuestaUsuario];
        respuestaUsuario.idRespuesta = answer.idRespuesta;
        respuestaUsuario.texto = answerUser;
        respuestaUsuario.emPregunta = pregunta;
        respuestaUsuario.emPull = self.pull;
        [[EMManagedObject sharedInstance] saveLocalContext];
        [self verifyNextQuestionToAnswer:answer];
    }

}

#pragma -mark NSNotificationCenter

- (void)receiveAnswerUser:(NSNotification *) notification
{
    NSDictionary * dictionary = notification.object;
    EMPregunta * pregunta = [dictionary objectForKey:kEMKeyCoreDataPregunta];
    NSInteger index = [[dictionary objectForKey:kEMKeyNotificationIndex] integerValue];
    if ([[dictionary objectForKey:kEMKeyCoreDataRespuesta] isKindOfClass:[EMRespuesta class]])
    {
        EMRespuesta * respuesta = [dictionary objectForKey:kEMKeyCoreDataRespuesta];
        [self verifyAnswerUserFromQuestion:pregunta answer:respuesta answerUser:respuesta.respuesta indexQuestion:index];
    }
    else
    {
//        la pregunta no contiene ninguna respuesta
        if ([pregunta.tipo isEqualToString:kEMQuestionTypeTiempo])
        {
            NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
            EMRespuestasUsuario * respuestaUsuario;
            if (arrayRespuestasUsuario && arrayRespuestasUsuario.count && arrayRespuestasUsuario.count == [pregunta.respuesta integerValue])
            {
//                el count ya es igual al numero de respuestas
//                borrar las antiguas
                [[EMManagedObject sharedInstance] deleteRespuestasUsuario:arrayRespuestasUsuario];
            }
            respuestaUsuario = [[EMManagedObject sharedInstance] newRespuestaUsuario];
            respuestaUsuario.idRespuesta = pregunta.idPregunta;
            respuestaUsuario.texto = [dictionary objectForKey:kEMKeyCoreDataRespuesta];
            respuestaUsuario.emPregunta = pregunta;
            respuestaUsuario.emPull = self.pull;
            [[EMManagedObject sharedInstance] saveLocalContext];

        }
        else
        {
            NSMutableArray * arrayRespuestasUsuario = [[EMManagedObject sharedInstance] mutableArrayAnswerUserForPregunta:pregunta pull:self.pull];
            EMRespuestasUsuario * respuestaUsuario;
            if (arrayRespuestasUsuario && arrayRespuestasUsuario.count)
            {
                respuestaUsuario = [arrayRespuestasUsuario objectAtIndex:0];
            }
            else
            {
                respuestaUsuario = [[EMManagedObject sharedInstance] newRespuestaUsuario];
            }
            respuestaUsuario.idRespuesta = pregunta.idPregunta;
            respuestaUsuario.texto = [dictionary objectForKey:kEMKeyCoreDataRespuesta];
            respuestaUsuario.emPregunta = pregunta;
            respuestaUsuario.emPull = self.pull;
            [[EMManagedObject sharedInstance] saveLocalContext];
            if (!respuestaUsuario.texto || !respuestaUsuario.texto.length)
            {
                [[EMManagedObject sharedInstance] deleteRespuestaUsuario:respuestaUsuario];
            }
        }

    }
    [self.tableView reloadData];
}

#pragma -mark EMPull

- (EMPull *) generatePullID
{
    NSString * pullId = [EMPull pullIdWhitUser:self.usuario cuenta:self.cuenta sondeo:self.sondeo tienda:self.tienda];
    EMPull * pull = [[EMManagedObject sharedInstance] pullForId:pullId];
    pull.idPull = pullId;
//    if ([pull.estado integerValue] == EMPullStateComplete || [pull.estado integerValue] == EMPullStateSending)
//    {
////        validar si crear un nuevo pull
//    }
//    else
//    {
//        pull.estado = [NSNumber numberWithInteger:EMPullStateIncomplete];
//    }
    pull.emSondeo = self.sondeo;
    [[EMManagedObject sharedInstance] saveLocalContext];
    return pull;
}

#pragma -mark JSImagePickerViewControllerDelegate

- (void)imagePickerDidSelectImage:(UIImage *)image
{
    if(image)
    {
        
        
        __block EMPregunta * pregunta = [self.arrayPreguntas objectAtIndex:self.indexPhoto];
        __block NSString * respuesta;
        __block NSInteger index = self.indexPhoto;
        __block UIImage * imageSelected = [image imageWithImage:image convertToSize:CGSizeMake(480, 640)];
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            //
            //
            respuesta = [self encodeToBase64String:imageSelected];
            dispatch_async( dispatch_get_main_queue(), ^
            {
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                [EMSondeoViewController sendAnswerUserNotificationWithPregunta:pregunta stringRespuesta:respuesta index:index];
            });
        });
        

        
        
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
