//
//  EMConstants.m
//  emetrix
//
//  Created by Patricia Blanco on 13/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMConstants.h"

@implementation EMConstants

float const kEMDefaultBlurred = 1.0;
int const kEMTagCollectionViewLabelTime = -1;
float const kEMDefaultHeightMultipleCell = 60.0;
float const kEMDefaultHeightLabelTimeCell = 25.0;
int const kEMDefaultTimeSendPendientes = 600;
int const kEMDefaultTimeUpdateDate = 600;
float const kEMDefaultWidthResizeImage = 480.0;
float const kEMDefaultHeightResizeImage = 640.0;


NSString * kEMSeparatorLocalization           = @",";

//key XML Login
NSString * kEMKeyLoginXMLUser                 = @"usuario";
NSString * kEMKeyLoginXMLAccount              = @"cuenta";
NSString * kEMKeyXMLId                        = @"id";
NSString * kEMKeyLoginXMLUserDateExpired      = @"fecha_vencimiento";
NSString * kEMKeyLoginXMLName                 = @"nombre";
NSString * kEMKeyLoginXMLGPS                  = @"gps";
NSString * kEMKeyLoginXMLFilterCategory       = @"filtroCategoria";
NSString * kEMKeyLoginXMLFilterMarca          = @"filtroMarca";
NSString * kEMKeyLoginXMLVersion              = @"versiones";
NSString * kEMKeyXMLTiendas                   = @"tiendas";
NSString * kEMKeyLoginXMLProducts             = @"productos";
NSString * kEMKeyLoginXMLSondeos              = @"sondeos";
NSString * kEMKeyLoginXMLTiendasXDia          = @"tiendasxdia";
NSString * kEMKeyLoginXMLProductosXTienda     = @"productosxtienda";
NSString * kEMKeyLoginXMLSondeosXTienda       = @"sondeosxtienda";
NSString * kEMKeyLoginXMLRespuestasXSondeo    = @"respuestaxsondeo";
NSString * kEMKeyLoginXMLNewTienda            = @"nuevaTienda";
NSString * kEMKeyLoginXMLVisitaExtra          = @"visitaExtra";
NSString * KEMKeyLoginXMLIndicadoresRendimiento = @"indicadoresRendimiento";
NSString * KEMKeyLoginXMLCapacitaciones = @"capacitaciones";
NSString * KEMKeyLoginXMLDescargaSondeosOnline = @"descargaSondeosOnline";


//key XML Tiendas
NSString * kEMKeyXMLTienda                    = @"tienda";
NSString * kEMKeyXMLDefinirNombre             = @"definirNombre";
NSString * kEMKeyXMLIdCadena                  = @"idCadena";
NSString * kEMKeyXMLLatitud                   = @"latitud";
NSString * kEMKeyXMLLongitud                  = @"longitud";
NSString * kEMKeyXMLRangoGPS                  = @"rangoGPS";
NSString * kEMKeyXMLCheckGPS                  = @"checkGPS";

//key XML Encuestas
NSString * kEMKeyXMLEncuesta                  = @"encuesta";
NSString * kEMKeyXMLIndice                    = @"indice";
NSString * kEMKeyXMLPreguntaEncuesta          = @"preguntaEncuesta";
NSString * kEMKeyXMLRespuesta                 = @"respuesta";
NSString * kEMKeyXMLTexto                     = @"texto";
NSString * kEMKeyXMLTipo                      = @"tipo";
NSString * kEMKeyXMLOpcionEncuesta            = @"opcionEncuesta";
NSString * kEMKeyXMLObligatorio               = @"obligatorio";
NSString * kEMKeyXMLCapturaSKU                = @"capturaSKU";

//key XML Producto
NSString * kEMKeyXMLProducto                  = @"producto";
NSString * kEMKeyXMLCategoria                 = @"categoria";
NSString * kEMKeyXMLMarca                     = @"marca";
NSString * kEMKeyXMLIdMarca                   = @"idMarca";
NSString * kEMKeyXMLIdCategoria               = @"idCategoria";
NSString * kEMKeyXMLDescripcion               = @"descripcion";
NSString * kEMKeyXMLPrecioMax                 = @"precioMax";
NSString * kEMKeyXMLPrecioMin                 = @"precioMin";
NSString * kEMKeyXMLPrecioProm                = @"precioProm";
NSString * kEMKeyXMLSku                       = @"sku";
NSString * kEMKeyXMLFotoUrl                   = @"fotoUrl";
NSString * kEMKeyXMLPrecioPedido              = @"precioPedido";
NSString * kEMKeyXMLIdSondeo                  = @"idSondeo";

//key XML TiendasXdia
NSString * kEMKeyXMLEstatus                   = @"estatus";
NSString * kEMKeyXMLIcono                     = @"icono";
NSString * kEMKeyXMLNumFotos                  = @"num_fotos";

//key XML ProductoXTienda
NSString * kEMKeyXMLProductoCadena            = @"productocadena";

//key XML sendSondeos
NSString * kEMKeyXMLOK                        = @"ok";

//Core Data
NSString * kEMKeyCoreDataUser                 = @"EMUser";
NSString * kEMKeyCoreDataRespuestaUsuario     = @"EMRespuestasUsuario";
NSString * kEMKeyCoreDataPregunta             = @"EMPregunta";
NSString * kEMKeyCoreDataProducto             = @"EMProducto";
NSString * kEMKeyCoreDataMarca                = @"EMMarca";
NSString * kEMKeyCoreDataCuenta               = @"EMCuenta";
NSString * kEMKeyCoreDataSondeo               = @"EMSondeo";
NSString * kEMKeyCoreDataPull                 = @"EMPull";
NSString * kEMKeyCoreDataTienda               = @"EMTienda";
NSString * kEMKeyCoreDataTiendasXdia          = @"EMTiendasXdia";
NSString * kEMKeyCoreDataRespuesta            = @"EMRespuesta";
NSString * kEMKeyCoreDataCategoria            = @"EMCategoria";
NSString * kEMKeyCoreDataPendiente            = @"EMPendiente";
NSString * kEMKeyCoreDataMensaje              = @"EMMensajes";
NSString * kEMKeyCoreDataVersion              = @"EMVersion";
NSString * kEMKeyCoreDataCapacitacion         = @"EMCapacitacion";
NSString * kEMKeyCoreDataCategoriaCapacitacion= @"EMCategoriaCapacitacion";
NSString * kEMKeyCoreDataRespuestasDefault    = @"EMRespuestasDefault";



//Cell Identifiers
NSString * kEMKeyCellMenuAvatarIdentifier     = @"EMMenuTableViewCellAvatar";
NSString * kEMKeyCellMenuOptionIdentifier     = @"EMMenuTableViewCellOption";
NSString * kEMKeyCellRutaDelDiaIdentifier     = @"EMRutaDelDiaTableViewCell";
NSString * kEMKeyCellListSondeoIdentifier     = @"EMListSondeoTableViewCell";
NSString * kEMKeyCellSondeoTiempoIdentifier   = @"CellTiempo";
NSString * kEMKeyCellSondeoMultipleIdentifier = @"CellMultipleSeleccion";
NSString * kEMKeyCellSondeoImagenIdentifier   = @"CellImagen";
NSString * kEMKeyCellSondeoOpenIdentifier     = @"CellOpenQuestion";
NSString * kEMKeyCellSondeoFotoIdentifier     = @"CellFoto";
NSString * kEMKeyCellSondeoUnicaIdentifier    = @"CellUnicaRadio";
NSString * kEMKeyCellSondeoGPSIdentifier      = @"CellGPS";
NSString * kEMKeyCellSondeoInformIdentifier   = @"CellInformativo";
NSString * kEMKeyCellMultipleQuesIdentifier   = @"EMMultipleOptionCollectionViewCell";
NSString * kEMKeyCellLabelTimeQuesIdentifier  = @"EMMultipleOptionCollectionViewCellText";
NSString * kEMkeyCellPendientesHeader         = @"EMPendientesTableViewCellHeader";
NSString * kEMkeyCellPendientes               = @"EMPendientesTableViewCell";
NSString * kEMkeyCellProductSKU               = @"EMProductSKUTableViewCellSKU";
NSString * kEMkeyCellProductSKUButton         = @"EMProductSKUTableViewButton";
NSString * kEMkeyCellProductPicker            = @"EMProductSKUTableViewCellPicker";
NSString * kEMkeyCellProductList              = @"EMProductListTableViewCell";
NSString * kEMKeyCellFotoPickerView           = @"EMSondeoFotoTableViewCellPickerView";
NSString * kEMKeyCellFotoTextField            = @"EMSondeoFotoTableViewCellTextField";
NSString * kEMKeyCellFotoCamera               = @"EMSondeoFotoTableViewCellCamera";
NSString * kEMKeyCellFotoGallery              = @"EMSondeoFotoTableViewCellGallery";
NSString * kEMKeyCellFotoGuardar              = @"EMSondeoFotoTableViewCellGuardar";
NSString * kEMKeyCellPedidos                  = @"EMPedidosTableViewCell";
NSString * kEMKeyCellGalleryCapacitaciones    = @"EMGalleryCapacitacionesCollectionViewCell";
NSString * kEMKeyCellFiltersCapacitaciones    = @"EMFiltersCapacitacionesTableViewCell";


//NSUserDefaultsKey
NSString * kEMKeyUserDefaultProfileImage      = @"EMCuentaProfileImage";
NSString * kEMKeyUserDateOld                  = @"EMKeyUserDateOld";
NSString * kEMKeyUserSendVisitaPendiente      = @"EMKeyUserSendVisitaPendiente";


//EMTypeQuestions
NSString * kEMQuestionTypeTiempo              = @"tiempo";
NSString * kEMQuestionTypeMultipleSeleccion   = @"multipleSeleccion";
NSString * kEMQuestionTypeImagen              = @"imagen";
NSString * kEMQuestionTypeDecimal             = @"decimal";
NSString * kEMQuestionTypeNumerica            = @"numerica";
NSString * kEMQuestionTypeFoto                = @"foto";
NSString * kEMQuestionTypeUnicaRadio          = @"unicaRadio";
NSString * kEMQuestionTypeAbierta             = @"abierta";
NSString * kEMQuestionTypeGPS                 = @"gps";
NSString * kEMQuestionTypeInformativo         = @"informativo";

//NSNotificationCenterKey
NSString * kEMKeyNotificationUserAnswer       = @"kEMKeyNotificationUserAnswer";
NSString * kEMKeyNotificationChangePendiente  = @"kEMKeyNotificationChangePendiente";
NSString * kEMKeyNotificationLocation         = @"kEMKeyNotificationLocation";
NSString * kEMKeyNotificationIndex            = @"kEMKeyNotificationIndex";
NSString * kEMKeyNotificationMessage          = @"kEMKeyNotificationMessage";
NSString * kEMKeyNotificationErrorLocation    = @"kEMKeyNotificationErrorLocation";



//Segue Identifier
NSString * kEMSegueScanCodeIdentifier         = @"kEMSegueScanCodeIdentifier";
NSString * kEMSegueEMProductListIdentifier    = @"kEMProductListIdentifier";
NSString * kEMSegueListPedidosSegueIdentifier = @"EMListPedidosSegueIdentifier";

//EMPendiente logs movil tags
NSString * kEMPendienteTagLogin               = @"LOGIN";
NSString * kEMPendienteTagCheckIn             = @"SEND FOTO ASISTENSIA ENTRADA";
NSString * kEMPendienteTagCheckOut            = @"SEND FOTO ASISTENSIA SALIDA";
NSString * kEMPendienteTagFoto                = @"SEND FOTO";
NSString * kEMPendienteTagSondeo              = @"SONDEO:";
NSString * kEMPendienteTagTienda              = @"ACCESO TIENDA";
NSString * kEMPendienteTagDate                = @"DATE/TIME/TIMEZONE changed. New time is";

//id question newStore
NSString * kEMIdQuestionSelection             = @"99";
NSString * kEMIdQuestionLocation              = @"14";

//StoryBoard Identifiers
NSString * kEMStoryBoardFiltersCapacitaciones = @"EMCapacitacionesFilters";
NSString * kEMStoryBoardWebViewCapacitaciones = @"EMCapacitacionesWebViewViewController";
NSString * kEMStoryBoardPedidos               = @"EMListPedidosViewController";
NSString * kEMStoryBoardPickerModal           = @"EMPickerViewModalViewController";









//Medida fotos 640 * 480

@end
