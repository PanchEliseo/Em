//
//  EMConstants.h
//  emetrix
//
//  Created by Patricia Blanco on 13/07/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EMPullStateStart = 0,
    EMPullStateIncomplete,
    EMPullStateComplete,
    EMPullStateSending
    
} EMPullState;

typedef enum
{
    EMPendienteTypeSendSondeo = 0,
    EMPendienteTypeSendVisita,
    EMPendienteTypeSendFoto,
    EMPendienteTypeCheckIn,
    EMPendienteTypeCheckOut,
    EMPendienteTypeLogsMovil,
    EMPendienteTypePedido,
    
} EMPendienteType;

typedef enum
{
    EMStatusTypeNotVisit = 0,
    EMStatusTypeInVisit,
    EMStatusTypeVisited,
    EMStatusTypeDefault,
    
} EMStatusType;

typedef enum
{
    EMPendienteStateWithOutLocation = 1,
    EMPendienteStatePrepared = 2,
    EMPendienteStateSending,
    EMPendienteStateSend,
    
} EMPendienteState;


typedef enum
{
    EMMensajeTypeGeneral = 0,
    EMMensajeTypeInformativo,
    EMMensajeTypeAlerta,
    EMMensajeTypeFelicitacion,
    
} EMMensajeType;

typedef enum
{
    EMSondeoStaticFotos = 1,
    EMSondeoStaticFotoGaleria,
    EMSondeoStaticAsistencia,
    EMSondeoStaticNuevaTienda,
    EMSondeoStaticPedidos = 6
    
} EMSondeoStatic;


@interface EMConstants : NSObject

extern float const kEMDefaultBlurred;
extern float const kEMDefaultHeightMultipleCell;
extern int const kEMTagCollectionViewLabelTime;
extern float const kEMDefaultHeightLabelTimeCell;
extern int const kEMDefaultTimeSendPendientes;
extern int const kEMDefaultTimeUpdateDate;
extern float const kEMDefaultWidthResizeImage;
extern float const kEMDefaultHeightResizeImage;

extern NSString * kEMSeparatorLocalization;

//key XML Login
extern NSString * kEMKeyLoginXMLUser;
extern NSString * kEMKeyLoginXMLAccount;
extern NSString * kEMKeyXMLId;
extern NSString * kEMKeyLoginXMLUserDateExpired;
extern NSString * kEMKeyLoginXMLName;
extern NSString * kEMKeyLoginXMLGPS;
extern NSString * kEMKeyLoginXMLFilterCategory;
extern NSString * kEMKeyLoginXMLFilterMarca;
extern NSString * kEMKeyLoginXMLVersion;
extern NSString * kEMKeyXMLTiendas;
extern NSString * kEMKeyLoginXMLProducts;
extern NSString * kEMKeyLoginXMLSondeos;
extern NSString * kEMKeyLoginXMLTiendasXDia;
extern NSString * kEMKeyLoginXMLProductosXTienda;
extern NSString * kEMKeyLoginXMLSondeosXTienda;
extern NSString * kEMKeyLoginXMLRespuestasXSondeo;
extern NSString * kEMKeyLoginXMLNewTienda;
extern NSString * kEMKeyLoginXMLVisitaExtra;
extern NSString * KEMKeyLoginXMLIndicadoresRendimiento;
extern NSString * KEMKeyLoginXMLCapacitaciones;
extern NSString * KEMKeyLoginXMLDescargaSondeosOnline;

//key XML Tiendas
extern NSString * kEMKeyXMLTienda;
extern NSString * kEMKeyXMLDefinirNombre;
extern NSString * kEMKeyXMLIdCadena;
extern NSString * kEMKeyXMLLatitud;
extern NSString * kEMKeyXMLLongitud;
extern NSString * kEMKeyXMLRangoGPS;
extern NSString * kEMKeyXMLCheckGPS;

//key XML Encuestas
extern NSString * kEMKeyXMLEncuesta;
extern NSString * kEMKeyXMLIndice;
extern NSString * kEMKeyXMLPreguntaEncuesta;
extern NSString * kEMKeyXMLRespuesta;
extern NSString * kEMKeyXMLTexto;
extern NSString * kEMKeyXMLTipo;
extern NSString * kEMKeyXMLOpcionEncuesta;
extern NSString * kEMKeyXMLObligatorio;
extern NSString * kEMKeyXMLCapturaSKU;

//key XML Producto
extern NSString * kEMKeyXMLProducto;
extern NSString * kEMKeyXMLCategoria;
extern NSString * kEMKeyXMLMarca;
extern NSString * kEMKeyXMLIdMarca;
extern NSString * kEMKeyXMLIdCategoria;
extern NSString * kEMKeyXMLDescripcion;
extern NSString * kEMKeyXMLPrecioMax;
extern NSString * kEMKeyXMLPrecioMin;
extern NSString * kEMKeyXMLPrecioProm;
extern NSString * kEMKeyXMLSku;
extern NSString * kEMKeyXMLFotoUrl;
extern NSString * kEMKeyXMLPrecioPedido;
extern NSString * kEMKeyXMLIdSondeo;

//key XML TiendasXdia
extern NSString * kEMKeyXMLEstatus;
extern NSString * kEMKeyXMLIcono;
extern NSString * kEMKeyXMLNumFotos;

//key XML ProductoXTienda
extern NSString * kEMKeyXMLProductoCadena;

//key XML sendSondeos
extern NSString * kEMKeyXMLOK;

//Core Data
extern NSString * kEMKeyCoreDataUser;
extern NSString * kEMKeyCoreDataRespuestaUsuario;
extern NSString * kEMKeyCoreDataPregunta;
extern NSString * kEMKeyCoreDataProducto;
extern NSString * kEMKeyCoreDataMarca;
extern NSString * kEMKeyCoreDataCuenta;
extern NSString * kEMKeyCoreDataSondeo;
extern NSString * kEMKeyCoreDataPull;
extern NSString * kEMKeyCoreDataTienda;
extern NSString * kEMKeyCoreDataTiendasXdia;
extern NSString * kEMKeyCoreDataRespuesta;
extern NSString * kEMKeyCoreDataCategoria;
extern NSString * kEMKeyCoreDataPendiente;
extern NSString * kEMKeyCoreDataMensaje;
extern NSString * kEMKeyCoreDataVersion;
extern NSString * kEMKeyCoreDataCapacitacion;
extern NSString * kEMKeyCoreDataCategoriaCapacitacion;
extern NSString * kEMKeyCoreDataRespuestasDefault;




//Cell Identifiers
extern NSString * kEMKeyCellMenuAvatarIdentifier;
extern NSString * kEMKeyCellMenuOptionIdentifier;
extern NSString * kEMKeyCellRutaDelDiaIdentifier;
extern NSString * kEMKeyCellListSondeoIdentifier;
extern NSString * kEMKeyCellSondeoTiempoIdentifier;
extern NSString * kEMKeyCellSondeoMultipleIdentifier;
extern NSString * kEMKeyCellSondeoImagenIdentifier;
extern NSString * kEMKeyCellSondeoOpenIdentifier;
extern NSString * kEMKeyCellSondeoFotoIdentifier;
extern NSString * kEMKeyCellSondeoUnicaIdentifier;
extern NSString * kEMKeyCellSondeoGPSIdentifier;
extern NSString * kEMKeyCellSondeoInformIdentifier;
extern NSString * kEMKeyCellMultipleQuesIdentifier;
extern NSString * kEMKeyCellLabelTimeQuesIdentifier;
extern NSString * kEMkeyCellPendientesHeader;
extern NSString * kEMkeyCellPendientes;
extern NSString * kEMkeyCellProductSKU;
extern NSString * kEMkeyCellProductSKUButton;
extern NSString * kEMkeyCellProductPicker;
extern NSString * kEMkeyCellProductList;
extern NSString * kEMKeyCellFotoPickerView;
extern NSString * kEMKeyCellFotoTextField;
extern NSString * kEMKeyCellFotoCamera;
extern NSString * kEMKeyCellFotoGallery;
extern NSString * kEMKeyCellFotoGuardar;
extern NSString * kEMKeyCellPedidos;
extern NSString * kEMKeyCellGalleryCapacitaciones;
extern NSString * kEMKeyCellFiltersCapacitaciones;



//NSUserDefaultsKey
extern NSString * kEMKeyUserDefaultProfileImage;
extern NSString * kEMKeyUserDateOld;
extern NSString * kEMKeyUserSendVisitaPendiente;


//EMTypeQuestions
extern NSString * kEMQuestionTypeTiempo;
extern NSString * kEMQuestionTypeMultipleSeleccion;
extern NSString * kEMQuestionTypeImagen;
extern NSString * kEMQuestionTypeDecimal;
extern NSString * kEMQuestionTypeNumerica;
extern NSString * kEMQuestionTypeFoto;
extern NSString * kEMQuestionTypeUnicaRadio;
extern NSString * kEMQuestionTypeAbierta;
extern NSString * kEMQuestionTypeGPS;
extern NSString * kEMQuestionTypeInformativo;

//NSNotificationCenterKey
extern NSString * kEMKeyNotificationUserAnswer;
extern NSString * kEMKeyNotificationChangePendiente;
extern NSString * kEMKeyNotificationLocation;
extern NSString * kEMKeyNotificationIndex;
extern NSString * kEMKeyNotificationMessage;
extern NSString * kEMKeyNotificationErrorLocation;



//Segue Identifier
extern NSString * kEMSegueScanCodeIdentifier;
extern NSString * kEMSegueEMProductListIdentifier;
extern NSString * kEMSegueListPedidosSegueIdentifier;

//EMPendiente logs movil tags
extern NSString * kEMPendienteTagLogin;
extern NSString * kEMPendienteTagCheckIn;
extern NSString * kEMPendienteTagCheckOut;
extern NSString * kEMPendienteTagFoto;
extern NSString * kEMPendienteTagSondeo;
extern NSString * kEMPendienteTagTienda;
extern NSString * kEMPendienteTagDate;

//id question newStore
extern NSString * kEMIdQuestionSelection;
extern NSString * kEMIdQuestionLocation;

//StoryBoard Identifiers
extern NSString * kEMStoryBoardFiltersCapacitaciones;
extern NSString * kEMStoryBoardWebViewCapacitaciones;
extern NSString * kEMStoryBoardPedidos;
extern NSString * kEMStoryBoardPickerModal;
@end
