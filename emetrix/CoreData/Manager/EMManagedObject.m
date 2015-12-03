//
//  STManagedObject.m
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz   on 11/11/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import "EMManagedObject.h"
#import "AppDelegate.h"
#import "EMPendiente.h"
#import "NSObject+EMObjectExtension.h"
#import "EMRespuestasDefault.h"


@interface EMManagedObject ()

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@end

@implementation EMManagedObject
- (NSManagedObjectContext *) managedObjectContext
{

    _managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    return _managedObjectContext;
}

+ (instancetype)sharedInstance
{
    static EMManagedObject * shared = nil;
    if (!shared)
    {
        
        shared = [[self alloc] initPrivate];
    }
//    if(![NSThread isMainThread])
//    {
//        
//        [shared sendException];
//    }
    return shared;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"This class is a singleton" reason:@"Use +[STManagedObject sharedInstance]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}



#pragma - mark Delete entity
- (void) deleteEntity:(NSManagedObject *) object
{
    [self.managedObjectContext deleteObject:object];
}

#pragma -mark Save local context
- (void)saveLocalContext
{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}
#pragma -mark Request entity


//
- (NSMutableArray *) mutableArrayPreguntasForSondeo:(EMSondeo *) sondeo
{
     NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPregunta withPredicate:[NSPredicate predicateWithFormat:@"emSondeo=%@ AND idParent=nil",sondeo]];
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray *sortedArray = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    if (sortedArray.count)
    {
        return sortedArray;
        
    }
    else
    {
        return nil;
    }

}

- (NSMutableArray *) mutableArrayStaticPreguntasForSondeo:(EMSondeo *) sondeo cuenta:(EMCuenta *) cuenta
{
//    Esto se hizo así por que se envian sondeos con id iguales 1, 2, 3, 4 para diferentes cuentas. Al parsear se pueden agregar preguntas de otras cuentas en el sondeo tambien se puede modificar el id del sondeo, pero se desconose el alcanze de problemas que pueda llegar a tener en toda la app, se opta por esta solución.
    
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPregunta withPredicate:[NSPredicate predicateWithFormat:@"emSondeo=%@ AND idParent=nil",sondeo]];
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray *sortedArray = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    int i = 0;
    NSMutableArray * indexToRemove = [[NSMutableArray alloc] init];
//    se obtienen los indices de las preguntas que no corresponden a la misma cuenta
    for (EMPregunta * pregunta in sortedArray)
    {
        if (![pregunta.idPregunta hasPrefix:[cuenta.idCuenta stringValue]])
        {
            [indexToRemove addObject:pregunta];
        }
        i++;
    }
    //    se remueven los indices de las preguntas que no corresponden a la misma cuenta
    for (EMPregunta * pregunta in indexToRemove)
    {

        [sortedArray removeObject:pregunta];
    }
    
    if (sortedArray.count)
    {
        return sortedArray;
        
    }
    else
    {
        return nil;
    }
    
}



- (NSMutableArray *) mutableArrayPreguntasForRespuesta:(EMRespuesta *) respuesta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPregunta withPredicate:[NSPredicate predicateWithFormat:@"idParent=%@",respuesta.idRespuesta]];
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray *sortedArray = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    if (sortedArray.count)
    {
        return sortedArray;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) orderMutableArrayPreguntasOrRespuestas:(NSMutableArray *) preguntas
{
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    return [[preguntas sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (NSMutableArray *) mutableArrayAnswerUserForPregunta:(EMPregunta *) pregunta pull:(EMPull *) pull
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestaUsuario withPredicate:[NSPredicate predicateWithFormat:@"emPregunta=%@ AND emPull=%@",pregunta,pull]];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayAnswerUserForPregunta:(EMPregunta *) pregunta pull:(EMPull *) pull respuesta:(EMRespuesta *) respuesta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestaUsuario withPredicate:[NSPredicate predicateWithFormat:@"emPregunta=%@ AND emPull=%@ AND idRespuesta =%@",pregunta,pull,respuesta.idRespuesta]];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayAnswerUserForSku:(EMPregunta *) pregunta pull:(EMPull *) pull producto:(EMProducto *)producto
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestaUsuario withPredicate:[NSPredicate predicateWithFormat:@"emPregunta=%@ AND emPull=%@ AND emProducto=%@",pregunta,pull, producto]];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayAnswerUser{
    
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestaUsuario withPredicate:nil];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayPendientes
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPendiente withPredicate:nil];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}


- (NSMutableArray *) mutableArrayPendientesForIdSondeo:(NSString *)idSondeo idTienda:(NSString *)idTienda
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"idSondeo == %@ AND determinanteGPS == %@", idSondeo, idTienda];
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPendiente withPredicate:predicate];
    
    if (array)
        return array;
    else
        return nil;
}


- (NSMutableArray *) mutableArrayPendientesSondeoForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPendiente withPredicate:[NSPredicate predicateWithFormat:@"emCuenta=%@ AND tipo=%u",cuenta,EMPendienteTypeSendSondeo]];
    
    array = [self orderArray:array withKey:@"estatus"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
}


- (NSMutableArray *) mutableArrayPendientesVisitaForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPendiente withPredicate:[NSPredicate predicateWithFormat:@"emCuenta=%@ AND tipo=%u",cuenta,EMPendienteTypeSendVisita]];
    
    array = [self orderArray:array withKey:@"estatus"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray *) mutableArrayPendientesFotosForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataPendiente withPredicate:[NSPredicate predicateWithFormat:@"emCuenta=%@ AND tipo=%u",cuenta,EMPendienteTypeSendFoto]];
    
    array = [self orderArray:array withKey:@"estatus"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray *) mutableArraySondeosPorCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataSondeo withPredicate:[NSPredicate predicateWithFormat:@"ANY emCuentas == %@", cuenta]];
    
    if (array)
        return array;
    else
        return nil;
}

- (NSMutableArray *) mutableArrayTiendas
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:nil];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}


- (NSMutableArray *) mutableArrayTiendasPorCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:[NSPredicate predicateWithFormat:@"ANY emCuentas == %@", cuenta]];
    
    if (array)
        return array;
    else
        return nil;
}


- (NSMutableArray *) mutableArrayCuentas
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataCuenta withPredicate:nil];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayCategoria
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataCategoria withPredicate:nil];
    
    array = [self orderArray:array withKey:@"nombre"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}


- (NSMutableArray *) mutableArrayMarcaWithCategoria:(EMCategoria *) categoria
{
    if (categoria)
    {
        NSMutableArray * array = array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emCategoria == %@",categoria]];
        NSMutableArray * marcas = [[NSMutableArray alloc] init];
        if (array)
        {
            for (EMProducto * producto in array)
            {
                for (EMMarca * marca in producto.emMarcas)
                {
                    if (![marcas containsObject:marca])
                    {
                        [marcas addObject:marca];
                    }
                }
                
            }
            marcas = [self orderArray:marcas withKey:@"nombre"];
            return marcas;
            
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataMarca withPredicate:nil];
        
        array = [self orderArray:array withKey:@"nombre"];
        
        if (array)
        {
            return array;
            
        }
        else
        {
            return nil;
        }
    }
    return nil;

}

- (NSMutableArray *) mutableArrayProductosForTienda:(EMTienda *) tienda cuenta:(EMCuenta *) cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emTiendas == %@ AND ANY emCuentas == %@",tienda, cuenta]];
    if (!array.count)
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emCuentas == %@",cuenta]];

    }
    array = [self orderArray:array withKey:@"nombre"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}


- (NSMutableArray *) mutableArrayProductsForMarca:(EMMarca *) marca forCategoria:(EMCategoria *) categoria capturado:(BOOL)capturado tienda:(EMTienda *) tienda cuenta:(EMCuenta *) cuenta
{
    NSMutableArray * array;
    if(!marca && !categoria)
    {
//        valida por tienda
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado == %@ AND ANY emTiendas == %@ AND ANY emCuentas == %@",[NSNumber numberWithBool:capturado],tienda, cuenta]];
        
//        valida sin tienda
        if (!array.count)
        {
            array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado == %@  AND ANY emCuentas == %@",[NSNumber numberWithBool:capturado],cuenta]];
        }
        
    }
    if(marca && !categoria)
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emMarcas == %@ AND capturado == %@ AND ANY emTiendas == %@ AND ANY emCuentas == %@",marca,[NSNumber numberWithBool:capturado], tienda, cuenta]];
        if (!array.count)
        {
            array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emMarcas == %@ AND capturado == %@ AND ANY emCuentas == %@",marca,[NSNumber numberWithBool:capturado], cuenta]];
        }
        
        
    }
    if(!marca && categoria)
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emCategoria == %@ AND capturado == %@ AND ANY emTiendas == %@ AND ANY emCuentas == %@",categoria,[NSNumber numberWithBool:capturado], tienda, cuenta]];
        if (!array.count)
        {
           array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emCategoria == %@ AND capturado == %@ AND ANY emCuentas == %@",categoria,[NSNumber numberWithBool:capturado],cuenta]];
        }
        
    }
    if(marca && categoria)
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emMarcas == %@ AND ANY emCategoria == %@ AND capturado == %@ AND ANY emTiendas == %@ AND ANY emCuentas == %@",marca,categoria,[NSNumber numberWithBool:capturado], tienda, cuenta]];
        if (!array.count)
        {
            array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emMarcas == %@ AND ANY emCategoria == %@ AND capturado == %@ AND ANY emCuentas == %@",marca,categoria,[NSNumber numberWithBool:capturado], cuenta]];

        }
    }
    
    
    
    array = [self orderArray:array withKey:@"nombre"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *)mutableArrayProductosForCaptura:(int)capturado valor:(NSString *)valor idSondeo:(NSString *)idSondeo tipo:(NSString *)tipo tienda:(EMTienda *)tienda{
    
    NSMutableArray * array;
    if(!tienda){
        if([valor isEqualToString:@""]){
            array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado = %d AND idSondeo = %@", capturado, idSondeo]];
            //array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"idSondeo = %@", idSondeo]];
        }else{
            array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado = %d AND idSondeo = %@ AND (sku CONTAINS[cd] %@ OR nombre CONTAINS[cd] %@)", capturado, idSondeo, valor, valor]];
        }
    }else{
        NSLog(@"el ide de tienda que tiene %@", tienda.idTienda);
       array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"emTiendas.@min.idTienda = %@", tienda.idTienda]];
    }
    
    if(array){
        if([tipo isEqualToString:@"Cadena"]){
            array = [self orderArray:array withKey:@"emCategoria.@min.nombre"];
        }else if([tipo isEqualToString:@"Marca"]){
            array = [self orderArray:array withKey:@"emMarcas.@min.nombre"];
        }
        return array;
    }else
        return nil;
}

- (NSMutableArray *) mutableArrayProductosWithContainsString:(NSString *) name
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"nombre CONTAINS[cd] %@",name]];
    
    array = [self orderArray:array withKey:@"nombre"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

- (NSMutableArray *) mutableArrayCapacitacionesForCategoria:(EMCategoriaCapacitacion *) categoriaCapacitacion forCuenta:(EMCuenta *) cuenta
{
    NSMutableArray * array;
    if (categoriaCapacitacion)
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataCapacitacion withPredicate:[NSPredicate predicateWithFormat:@"emCuenta == %@ AND emCategoriaCapacitacion == %@",cuenta,categoriaCapacitacion]];
    }
    else
    {
        array = [self fetchResultsForEntityName:kEMKeyCoreDataCapacitacion withPredicate:[NSPredicate predicateWithFormat:@"emCuenta == %@",cuenta]];
    }
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray *) mutableArrayCategoriaCapacitacion
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataCategoriaCapacitacion withPredicate:nil];
    array = [self orderArray:array withKey:@"categoria"];
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray *) mutableArrayProductosWithCuentaAndHaveCantidad:(EMCuenta *) cuenta
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"ANY emCuentas == %@ AND cantidad != nil AND cantidad != %@",cuenta, [NSNumber numberWithDouble:0]]];
    
    array = [self orderArray:array withKey:@"nombre"];
    
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}


- (NSMutableArray *) fetchResultsForEntityName:(NSString *) entityName withPredicate: (NSPredicate *) predicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    // Execute the fetch -- create a mutable copy of the result.
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    return mutableFetchResults;
}

- (NSMutableArray *)tiendasXdiaForTiendaXDia:(EMTiendasXdia *)tiendaXDia withFilterText:(NSString *)text
{
    if (!text || !text.length)
    {
        NSMutableArray * array;
        array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:[NSPredicate predicateWithFormat:@"ANY emTiendasXdia==%@",tiendaXDia]];
        if (array.count)
        {
            return array;
            
        }
        return nil;
    }
    else
    {
        NSMutableArray * array;
        array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:[NSPredicate predicateWithFormat:@"nombre CONTAINS[cd] %@ AND ANY emTiendasXdia==%@",text, tiendaXDia]];
        if (array.count)
        {
            return array;
            
        }
        return nil;
    }
    return nil;
}

- (NSMutableArray *) mutableArrayProductos:(int)captura valor:(NSString *)valor tipo:(NSString *)tipo
{
    NSMutableArray * array;
    if([valor isEqualToString:@""]){
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado = %d", captura]];
    }else{
        array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"capturado = %d AND (sku CONTAINS[cd] %@ OR nombre CONTAINS[cd] %@)", captura, valor, valor]];
    }
    
    if([tipo isEqualToString:@"Cadena"]){
        array = [self orderArray:array withKey:@"emCategoria.@min.nombre"];
    }else if([tipo isEqualToString:@"Marca"]){
        array = [self orderArray:array withKey:@"emMarcas.@min.nombre"];
    }
    if (array)
    {
        return array;
        
    }
    else
    {
        return nil;
    }
    
}

#pragma -mark Get Entity for id


- (EMUser *) userWithUsername:(NSString *) userName password:(NSString *) password
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataUser withPredicate:[NSPredicate predicateWithFormat:@"usuario = %@ AND password = %@",userName,password]];
    
    if (array && array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return nil;
    }
    
}

- (EMUser *)userForId:(NSInteger)userId
{
    NSMutableArray * array;
    
   
    array = [self fetchResultsForEntityName:kEMKeyCoreDataUser withPredicate:[NSPredicate predicateWithFormat:@"idUsuario=%u",userId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMUser *)[self newEntityForName:kEMKeyCoreDataUser];
    }

}

- (EMPull *)pullForId:(NSString *)pullId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataPull withPredicate:[NSPredicate predicateWithFormat:@"idPull=%@",pullId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        EMPull * pull = (EMPull *)[self newEntityForName:kEMKeyCoreDataPull];
        pull.idPull = pullId;
        pull.estado = [NSNumber numberWithInt: EMPullStateStart];
        
        return pull;
    }
    
}

- (EMCuenta *)accountForId:(NSInteger)accountId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataCuenta withPredicate:[NSPredicate predicateWithFormat:@"idCuenta=%u",accountId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMCuenta *)[self newEntityForName:kEMKeyCoreDataCuenta];
    }
    
}

- (EMCuenta *)accountActive
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataCuenta withPredicate:[NSPredicate predicateWithFormat:@"activa == %@",[NSNumber numberWithBool:YES]]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return nil;
    }
    
}




- (EMTienda *)tiendaForId:(NSString *)tiendaId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:[NSPredicate predicateWithFormat:@"idTienda=%@",tiendaId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMTienda *)[self newEntityForName:kEMKeyCoreDataTienda];
    }
}


- (NSMutableArray *)tiendasForIdCadena:(NSInteger)idCadena
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataTienda withPredicate:[NSPredicate predicateWithFormat:@"idCadena=%u",idCadena]];
    
    if (array.count)
    {
        return array;
        
    }
    return nil;
}

- (EMTiendasXdia *)tiendasXdiaForId:(NSString *)tiendaXdiaId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataTiendasXdia withPredicate:[NSPredicate predicateWithFormat:@"idTiendasXdia=%@",tiendaXdiaId]];
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMTiendasXdia *)[self newEntityForName:kEMKeyCoreDataTiendasXdia];
    }
}



- (EMProducto *)productForId:(NSString *)productId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"sku=%@",productId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMProducto *)[self newEntityForName:kEMKeyCoreDataProducto];
    }
}

- (EMCategoria *)categoryForId:(NSString *)categoryId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataCategoria withPredicate:[NSPredicate predicateWithFormat:@"idCategoria=%@",categoryId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMCategoria *)[self newEntityForName:kEMKeyCoreDataCategoria];
    }
}

- (EMPregunta *)preguntaForId:(NSString *)preguntaId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataPregunta withPredicate:[NSPredicate predicateWithFormat:@"idPregunta=%@",preguntaId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMPregunta *)[self newEntityForName:kEMKeyCoreDataPregunta];
    }
}

- (EMRespuesta *)respuestaForId:(NSString *)respuestaId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuesta withPredicate:[NSPredicate predicateWithFormat:@"idRespuesta=%@",respuestaId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMRespuesta *)[self newEntityForName:kEMKeyCoreDataRespuesta];
    }
}

- (EMMarca *)marcaForId:(NSString *)marcaId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataMarca withPredicate:[NSPredicate predicateWithFormat:@"idMarca=%@",marcaId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMMarca *)[self newEntityForName:kEMKeyCoreDataMarca];
    }
}


- (EMSondeo *)sondeoForId:(NSInteger)sondeoId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataSondeo withPredicate:[NSPredicate predicateWithFormat:@"idSondeo=%u",sondeoId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMSondeo *)[self newEntityForName:kEMKeyCoreDataSondeo];
    }
}

- (EMCapacitacion *)capacitacionForId:(NSString *)capacitacionId
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataCapacitacion withPredicate:[NSPredicate predicateWithFormat:@"urlArchivo=%@",capacitacionId]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMCapacitacion *)[self newEntityForName:kEMKeyCoreDataCapacitacion];
    }
}

- (BOOL)existsRespuestasDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestasDefault withPredicate:[NSPredicate predicateWithFormat:@"idCuenta == %@ AND idTienda==%@",cuenta.idCuenta, tienda.idTienda]];
    
    if (array.count > 0)
        return YES;
    else
        return NO;
}

- (NSMutableArray *)respuestasDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda sondeo:(EMSondeo *)sondeo
{
    return [self fetchResultsForEntityName:kEMKeyCoreDataRespuestasDefault withPredicate:[NSPredicate predicateWithFormat:@"idCuenta==%@ AND idTienda==%@ AND idSondeo==%@",cuenta.idCuenta.stringValue, tienda.idTienda, sondeo.idSondeo.stringValue]];
}

- (EMRespuestasDefault *)respuestaDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda pregunta:(EMPregunta *)pregunta sondeo:(EMSondeo *)sondeo
{
    NSMutableArray * array;

    array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestasDefault withPredicate:[NSPredicate predicateWithFormat:@"idCuenta==%@ AND idTienda ==%@ AND idSondeo==%@ AND idPregunta==%@",cuenta.idCuenta.stringValue, tienda.idTienda, sondeo.idSondeo.stringValue, pregunta.idPregunta]];
             
    if (array.count > 0)
        return [array objectAtIndex:0];
    else
        return (EMRespuestasDefault *)[self newEntityForName:kEMKeyCoreDataRespuestasDefault];
}
- (EMCategoriaCapacitacion *)categoriaCapacitacionForId:(NSString *)categoriaCapacitacion
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataCategoriaCapacitacion withPredicate:[NSPredicate predicateWithFormat:@"categoria=%@",categoriaCapacitacion]];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMCategoriaCapacitacion *)[self newEntityForName:kEMKeyCoreDataCategoriaCapacitacion];
    }
}

- (EMRespuestasUsuario *)respuestasUsuario
{
    NSMutableArray * array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestaUsuario withPredicate:nil];
    
    if (array.count)
    {
        return [array objectAtIndex:0];
        
    }
    else
    {
        return (EMRespuestasUsuario *)[self newEntityForName:kEMKeyCoreDataRespuestaUsuario];
    }
    
}

#pragma -mark entity exist

- (BOOL)existRespuestaForId:(NSString *)respuestaId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuesta withPredicate:[NSPredicate predicateWithFormat:@"idRespuesta=%@",respuestaId]];
    
    if (array.count)
    {
        return YES;
        
    }
    return NO;
    
}

- (BOOL)existPreguntaForId:(NSString *)preguntaID;
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataPregunta withPredicate:[NSPredicate predicateWithFormat:@"idPregunta=%@",preguntaID]];
    
    if (array.count)
    {
        return YES;
        
    }
    return NO;
    
}

- (BOOL)existProductForId:(NSString *)productId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataProducto withPredicate:[NSPredicate predicateWithFormat:@"sku=%@",productId]];
    
    if (array.count)
    {
        return YES;
        
    }
    else
    {
        return NO;
    }
    
}

- (BOOL)existTiendaXDiaForId:(NSString *)tiendaXDiaId
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataTiendasXdia withPredicate:[NSPredicate predicateWithFormat:@"idTiendasXdia=%@",tiendaXDiaId]];
    
    if (array.count)
    {
        return YES;
        
    }
    else
    {
        return NO;
    }
    
}

- (BOOL)existRespuestaDefaultForCuenta:(EMCuenta *)cuenta tienda:(EMTienda *)tienda pregunta:(EMPregunta *)pregunta sondeo:(EMSondeo *)sondeo
{
    NSMutableArray * array;
    
    
    array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestasDefault withPredicate:[NSPredicate predicateWithFormat:@"emSondeo=%@ AND emPregunta=%@ AND emTienda=%@ AND emCuenta=%@",sondeo,pregunta,tienda,cuenta]];
    
    if (array.count)
    {
        return YES;
        
    }
    else
    {
        return NO;
    }
}



#pragma -mark new Entity

- (NSManagedObject *) newEntityForName:(NSString *) name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext
            ];
}

- (EMRespuestasUsuario *) newRespuestaUsuario
{
    return (EMRespuestasUsuario *)[self newEntityForName:kEMKeyCoreDataRespuestaUsuario];
}

- (EMPendiente *)newPendiente
{
    return (EMPendiente *)[self newEntityForName:kEMKeyCoreDataPendiente];
}

- (EMMensajes *)newMensaje
{
    return (EMMensajes *)[self newEntityForName:kEMKeyCoreDataMensaje];
}

- (EMVersion *)newVersion
{
    return (EMVersion *)[self newEntityForName:kEMKeyCoreDataVersion];
}

#pragma -mark SendException
- (void) sendException
{
   @throw [NSException exceptionWithName:@"Operation in other thread" reason:@"Operations with WDManagerObject must be in main thread" userInfo:nil];
}
#pragma -mark Delete Entity

- (void)deleteRespuestaUsuario:(EMRespuestasUsuario *) respuestaUsuario
{
    [self.managedObjectContext deleteObject:respuestaUsuario];
    [self saveLocalContext];
}

- (void)deleteRespuestasUsuario:(NSMutableArray *) answerUser
{
    for (NSManagedObject * object in answerUser)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    [self saveLocalContext];
}

- (void)deleteAllMensajesForCuenta:(EMCuenta *) cuenta
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataMensaje withPredicate:[NSPredicate predicateWithFormat:@"emCuenta=%@",cuenta]];
    for (NSManagedObject * mensaje in [cuenta.emMensajes allObjects])
    {
        [self.managedObjectContext deleteObject:mensaje];

    }
    [self saveLocalContext];
}

- (void)deleteAllSondeosForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array;
    array = [[cuenta.emSondeos allObjects] mutableCopy];
    for (NSManagedObject * object in array)
    {
        [self.managedObjectContext deleteObject:object];
        
    }
    [self saveLocalContext];
}

- (void)deleteAllProductsForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array;
    array = [[cuenta.emProductos allObjects] mutableCopy];
    for (NSManagedObject * object in array)
    {
        [self.managedObjectContext deleteObject:object];
        
    }
    [self saveLocalContext];
}


- (void)deleteAllTiendasForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array;
    array = [[cuenta.emTiendas allObjects] mutableCopy];
    for (NSManagedObject * object in array)
    {
        [self.managedObjectContext deleteObject:object];
        
    }
    [self saveLocalContext];
}

- (void)deleteTiendasXdiaForCuenta:(EMCuenta *)cuenta
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataTiendasXdia withPredicate:nil];
    for (EMTiendasXdia * object in array)
    {
        if ([EMManagedObject isTiendaXDiaId:object.idTiendasXdia inCuenta:cuenta])
        {
            [self.managedObjectContext deleteObject:object];
        }
    }
    [self saveLocalContext];
}

- (void)deleteAllRespuestasDefault
{
    NSMutableArray * array;
    array = [self fetchResultsForEntityName:kEMKeyCoreDataRespuestasDefault withPredicate:nil];
    for (EMRespuestasDefault * object in array)
        [self.managedObjectContext deleteObject:object];
    [self saveLocalContext];
}

#pragma -mark Delete Entity
- (NSMutableArray *) orderArray:(NSMutableArray *) array withKey:(NSString *) key
{
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray *sortArray = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return sortArray;
}

- (NSArray*)showData:(NSString*)name{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:name inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        // Controlamos los posibles errores
    }
    return array;
}

@end
