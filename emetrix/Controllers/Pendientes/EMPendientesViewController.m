//
//  EMPendientesViewController.m
//  emetrix
//
//  Created by Patricia Blanco on 04/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMPendientesViewController.h"
#import "EMPendientesTableViewCell.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import "EMPendiente.h"
#import "EMPendiente+EMExtensions.h"
#import "UIColor+EMColorExtension.h"
#import "NSObject+EMObjectExtension.h"

@interface EMPendientesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * arrayPendientesSondeo;
@property (strong, nonatomic) NSMutableArray * arrayPendientesVisitas;
@property (strong, nonatomic) NSMutableArray * arrayPendientesFotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EMPendientesViewController

- (NSMutableArray *) arrayPendientesSondeo
{
    if(!_arrayPendientesSondeo || !_arrayPendientesSondeo.count)
    {
            _arrayPendientesSondeo = [[EMManagedObject sharedInstance] mutableArrayPendientesSondeoForCuenta:[self containerParentViewController].cuenta];
    }
    return _arrayPendientesSondeo;
}

- (NSMutableArray *) arrayPendientesVisitas
{
    if(!_arrayPendientesVisitas || !_arrayPendientesVisitas.count)
    {
        _arrayPendientesVisitas = [[EMManagedObject sharedInstance] mutableArrayPendientesVisitaForCuenta:[self containerParentViewController].cuenta];
    }
    return _arrayPendientesVisitas;
}

- (NSMutableArray *) arrayPendientesFotos
{
    if(!_arrayPendientesFotos || !_arrayPendientesFotos.count)
    {
        _arrayPendientesFotos = [[EMManagedObject sharedInstance] mutableArrayPendientesFotosForCuenta:[self containerParentViewController].cuenta];
    }
    return _arrayPendientesFotos;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedPendienteChange:)
                                                 name:kEMKeyNotificationChangePendiente
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    if (self.arrayPendientesSondeo.count || self.arrayPendientesVisitas.count)
    {
        UIButton * btnSendAll = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        btnSendAll.tintColor = [UIColor whiteColor];
        [btnSendAll addTarget:self action:@selector(didPressSendAll) forControlEvents:UIControlEventTouchUpInside];
        [btnSendAll setTitle:@"Enviar todo" forState:UIControlStateNormal];
        [self containerParentViewController].navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSendAll];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma -mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case EMPendienteTypeSendSondeo:
            return self.arrayPendientesSondeo.count;
            break;
        case EMPendienteTypeSendVisita:
            return self.arrayPendientesVisitas.count;
            break;
        case EMPendienteTypeSendFoto:
            return self.arrayPendientesFotos.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMPendientesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellPendientes];
    NSMutableArray * arrayToUse;
    switch (indexPath.section)
    {
        case EMPendienteTypeSendSondeo:
            arrayToUse = self.arrayPendientesSondeo;
            break;
        case EMPendienteTypeSendVisita:
            arrayToUse = self.arrayPendientesVisitas;
            break;
        case EMPendienteTypeSendFoto:
            arrayToUse = self.arrayPendientesFotos;
            break;
            
        default:
            break;
    }
    NSString * estado = @"";
    EMPendiente * pendiente = [arrayToUse objectAtIndex:indexPath.row];
    switch([pendiente.estatus integerValue])
    {
        case EMPendienteStateWithOutLocation:
            cell.imgVwIcon.image = [UIImage imageNamed:@"pendiente_state_location"];
            cell.imgVwBackground.backgroundColor = [UIColor emRedColor];
            estado = @"Obteniendo localización...";
            break;
        case EMPendienteStatePrepared:
            cell.imgVwIcon.image = [UIImage imageNamed:@"pendiente_state_prepared"];
            cell.imgVwBackground.backgroundColor = [UIColor emYellowColor];
            estado = @"Preparado para envio...";
            break;
        case EMPendienteStateSending:
            cell.imgVwIcon.image = [UIImage imageNamed:@"pendiente_state_sending"];
            cell.imgVwBackground.backgroundColor = [UIColor emYellowColor];
            estado = @"Enviando..";
            break;
        case EMPendienteStateSend:
            cell.imgVwIcon.image = [UIImage imageNamed:@"pendiente_state_send"];
            cell.imgVwBackground.backgroundColor = [UIColor emGreenColor];
            estado = @"Enviado";
            break;
        default:
            break;
    }
    NSString * stringTitle = @"";
     EMTienda * tienda = [[EMManagedObject sharedInstance] tiendaForId:pendiente.determinanteGPS];
    if(([pendiente.tipo integerValue] == EMPendienteTypeSendSondeo) ||([pendiente.tipo integerValue] == EMPendienteTypeSendVisita && pendiente.cadenaPendiente.length))
    {
        EMSondeo * sondeo = [[EMManagedObject sharedInstance] sondeoForId:[pendiente.idSondeo integerValue]];
       
        stringTitle = [NSString stringWithFormat:@"%@ - %@",tienda.nombre,sondeo.nombre];
    }
    else
    {
        stringTitle = [NSString stringWithFormat:@"%@",tienda.nombre];
    }
    cell.lbfTitle.text = stringTitle;
    cell.lbfSubtitle.text = [NSString stringWithFormat:@"Estado: %@ fecha:%@", estado, [NSDate stringPrintFromDate:pendiente.date]];
    

    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    EMPendientesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEMkeyCellPendientesHeader];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45.0)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = cell.lbfHeaderTitle.font;
    label.backgroundColor = [UIColor emMediumBlueColor];
    
    switch (section)
    {
        case EMPendienteTypeSendFoto:
            label.text = @"Envio de foto";
            break;
        case EMPendienteTypeSendSondeo:
            label.text = @"Envio de Sondeos";
            break;
        case EMPendienteTypeSendVisita:
            label.text = @"Envio de visitas";
            break;
            
        default:
            break;
    }
    
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)didPressSendAll
{
//  Send all pendientes
    [[self containerParentViewController] sendPendientes];
    
}

- (void)receivedPendienteChange:(NSNotificationCenter *) notification
{
    self.arrayPendientesSondeo = [[EMManagedObject sharedInstance] mutableArrayPendientesSondeoForCuenta:[self containerParentViewController].cuenta];
    self.arrayPendientesVisitas = [[EMManagedObject sharedInstance] mutableArrayPendientesVisitaForCuenta:[self containerParentViewController].cuenta];
    self.arrayPendientesFotos = [[EMManagedObject sharedInstance] mutableArrayPendientesFotosForCuenta:[self containerParentViewController].cuenta];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self containerParentViewController].navigationItem.rightBarButtonItem = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
