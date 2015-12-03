//
//  EMSondeoFotoViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 10/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMSondeoFotoViewController.h"
#import "JSImagePickerViewController.h"
#import "EMSondeoFotoTableViewCell.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import "NSObject+EMObjectExtension.h"
#import "EMPendiente.h"
#import "NZAlertView.h"
#import "EMStatusPhone.h"


typedef enum
{
    EMFotosCellCateoria = 0,
    EMFotosCellComentarios,
    EMFotosCellGuardar,
    EMFotosCellCamera,
    EMFotosCellGallery
    
} EMFotosCell;


@interface EMSondeoFotoViewController ()<UITableViewDataSource, UITableViewDelegate, JSImagePickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, EMSondeoFotoDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray * arrayFotos;
@property (strong, nonatomic) NSMutableArray * arrayRespuestas;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) EMRespuesta * respuestaSelected;
@property (strong, nonatomic) NSString * comment;

@end

@implementation EMSondeoFotoViewController

-(NSMutableArray * ) arrayRespuestas
{
    if (!_arrayRespuestas || !_arrayRespuestas.count)
    {
        EMPregunta * pregunta = [[EMManagedObject sharedInstance] preguntaForId:[EMSondeoFotoViewController idEMPreguntaWithIdPregunta:@"1" idCuenta:[[self containerParentViewController].cuenta.idCuenta stringValue] idSondeo:[self.sondeo.idSondeo stringValue]]];
        _arrayRespuestas = [[pregunta.emRespuestas allObjects] mutableCopy];
        _arrayRespuestas = [[EMManagedObject sharedInstance] orderMutableArrayPreguntasOrRespuestas:_arrayRespuestas];
    }
    return _arrayRespuestas;
}

- (EMRespuesta *) respuestaSelected
{
    if(!_respuestaSelected)
    {
        _respuestaSelected = [self.arrayRespuestas objectAtIndex:0];
    }
    return _respuestaSelected;
}

- (NSMutableArray *) arrayFotos
{
    if (!_arrayFotos)
    {
        _arrayFotos = [[NSMutableArray alloc] init];
    }
    return _arrayFotos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFotoGaleria)
    {
        return 3 + self.arrayFotos.count;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSondeoFotoTableViewCell * cell;
    if (!self.isFotoGaleria)
    {
        switch (indexPath.row)
        {
            case EMFotosCellCateoria:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoPickerView];
                cell.pickerView.dataSource = self;
                cell.pickerView.delegate = self;
                break;
            case EMFotosCellComentarios:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoTextField];
                cell.txtFldComentario.delegate = self;
                break;
            case EMFotosCellGuardar:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoGuardar];
                break;
            case EMFotosCellCamera:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoCamera];
                if (self.arrayFotos.count)
                {
                    cell.imgVwSelect.image = [self.arrayFotos objectAtIndex:0];
                    cell.imgVwCamera.hidden = YES;
                    cell.imgVwSelect.hidden = NO;
                }
                else
                {
                    cell.imgVwCamera.hidden = NO;
                    cell.imgVwSelect.hidden = YES;
                }
                break;

            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case EMFotosCellCateoria:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoPickerView];
                cell.pickerView.dataSource = self;
                cell.pickerView.delegate = self;
                break;
            case EMFotosCellComentarios:
                cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoTextField];
                cell.txtFldComentario.delegate = self;
                break;
            default:
            {
                NSInteger index = indexPath.row - 2;
                if (index < self.arrayFotos.count)
                {
                     cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoCamera];
                    cell.imgVwCamera.hidden = YES;
                    cell.imgVwSelect.hidden = NO;
                    cell.imgVwSelect.image = [self.arrayFotos objectAtIndex:index];

                }
                else
                {
                   cell = [tableView dequeueReusableCellWithIdentifier:kEMKeyCellFotoGallery];
                }
            }
                break;
        }
        
    }
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isFotoGaleria)
    {
        switch (indexPath.row)
        {
            case EMFotosCellCateoria:
                return 160;
                break;
            case EMFotosCellComentarios:
                return 105;
                break;
            case EMFotosCellGuardar:
                return 45;
                break;
            case EMFotosCellCamera:
                return 265;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case EMFotosCellCateoria:
                return 160;
                break;
            case EMFotosCellComentarios:
                return 105;
                break;
            default:
            {
                NSInteger index = indexPath.row - 2;
                if (index < self.arrayFotos.count)
                {
                    return 265;
                    
                }
                else
                {
                    return 100;
                }
            }
                break;
        }
        
    }

    return 0;
}

#pragma - mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayRespuestas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return ((EMRespuesta *)[self.arrayRespuestas objectAtIndex:row]).respuesta;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.respuestaSelected = [self.arrayRespuestas objectAtIndex:row];
}

#pragma - mark JSImagePickerViewControllerDelegate
- (void)imagePickerDidSelectImage:(UIImage *)image
{
    if (!self.isFotoGaleria)
    {
        [self.arrayFotos removeAllObjects];
        [self.arrayFotos addObject:image];
    }
    else
    {
        [self.arrayFotos addObject:image];
    }
    [self.tableView reloadData];
}

#pragma -mark EMSondeoFotoDelegate
- (void) didPressTakePhoto
{
    if(!self.isFotoGaleria)
    {
        JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
        imagePicker.delegate = self;
        imagePicker.showCamera = YES;
        [imagePicker showImagePickerInController:self animated:YES];
    }
}

- (void)didPressSelectFromGallery
{
    JSImagePickerViewController *imagePicker = (JSImagePickerViewController *)[self viewControllerForStoryBoardName:@"CameraSelection"];
    imagePicker.delegate = self;
    imagePicker.showGallery = YES;
    [imagePicker showImagePickerInController:self animated:YES];
}
#pragma -mark Actions

- (IBAction)didPressCancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressSend:(id)sender
{
    //    logs
    [self pendienteLogMovilForTag:kEMPendienteTagFoto];

    //       send sondeo

    if (self.arrayFotos.count && self.respuestaSelected)
    {
    
        if (!self.isFotoGaleria)
        {
                EMSondeoFotoTableViewCell * cell = (EMSondeoFotoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:EMFotosCellGuardar inSection:0]];
            //            Guardar imagen en galeria
            if (cell.switchGuardar.on)
            {
                for (UIImage * image in self.arrayFotos)
                {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
                }
            }
            EMPendiente * pendiente = [[EMManagedObject sharedInstance] newPendiente];
            //        Creamos el pendiente del sondeo
            pendiente.date = [[NSDate alloc] init];
            pendiente.idPendiente = [EMSondeoFotoViewController stringServiceFromDate:pendiente.date];
            pendiente.determinanteGPS = self.tienda.idTienda;
            pendiente.tipo = [NSNumber numberWithInteger:EMPendienteTypeSendFoto];
            pendiente.estatus = [NSNumber numberWithInteger:EMPendienteStateWithOutLocation];
            pendiente.emCuenta = [self containerParentViewController].cuenta;
            pendiente.idCategoriaFoto = [EMSondeoFotoViewController idRespuestaToSendWithIdEMRespuesta:self.respuestaSelected.idRespuesta];
            pendiente.comentariosFoto = self.comment;
            pendiente.cadenaPendiente = [self encodeToBase64String:[self.arrayFotos objectAtIndex:0]];
            [[EMManagedObject sharedInstance] saveLocalContext];
            [[self containerParentViewController] sendPendientes];
           
        }
        else
        {
            int i = 0;
            for (UIImage * image in self.arrayFotos)
            {
                EMPendiente * pendiente = [[EMManagedObject sharedInstance] newPendiente];
                //        Creamos el pendiente del sondeo
                pendiente.date = [[NSDate alloc] init];
                pendiente.idPendiente = [EMSondeoFotoViewController stringServiceFromDate:pendiente.date];
                pendiente.determinanteGPS = self.tienda.idTienda;
                pendiente.tipo = [NSNumber numberWithInteger:EMPendienteTypeSendFoto];
                pendiente.estatus = [NSNumber numberWithInteger:EMPendienteStateWithOutLocation];
                pendiente.emCuenta = [self containerParentViewController].cuenta;
                pendiente.idCategoriaFoto = [EMSondeoFotoViewController idRespuestaToSendWithIdEMRespuesta:self.respuestaSelected.idRespuesta];
                pendiente.comentariosFoto = self.comment;
                pendiente.cadenaPendiente = [self encodeToBase64String:image];
                pendiente.consecutivo = [NSNumber numberWithInt:i];
                [[EMManagedObject sharedInstance] saveLocalContext];
                [[self containerParentViewController] sendPendientes];
                i++;
            }
        }
        self.sondeo.emPull.estado = [NSNumber numberWithInt:2];
        [[EMManagedObject sharedInstance] saveLocalContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NZAlertView * alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleError title:@"Lo sentimos" message:@"Aún tiene preguntas sin contestar"];
        [alert show];
    }
}

#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.comment = textField.text;
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
