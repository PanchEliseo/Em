//
//  STDownloadServiceManager.m
//  Todo2day
//
//  Created by Carlos Alberto Molina Saenz   on 11/11/14.
//  Copyright (c) 2014 Sferea. All rights reserved.
//

#import "EMDownloadServiceManager.h"
#import <CoreLocation/CoreLocation.h>
#import "EMServiceObject.h"


@interface EMDownloadServiceManager ()<CLLocationManagerDelegate>

@end

@implementation EMDownloadServiceManager

//- (CLLocationManager *) locationManager
//{
//   
//    
//    return _locationManager;
//}

+ (instancetype)sharedInstance
{
    static EMDownloadServiceManager * shared = nil;
    if (!shared)
    {
        shared = [[self alloc] initPrivate];
    }
    return shared;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"This class is a singleton" reason:@"Use +[EMDownloadServiceManager sharedInstance]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}


#pragma -mark Download Json


- (void)downloadJsonGETWithServiceObject:(EMServiceObject *)object
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    [[session dataTaskWithURL:object.urlService completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          //Handle response
          if (!error)
          {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
              
              if (httpResponse.statusCode == 200)
              {
                  
                 
                  
                  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  
                  NSData *utfData = [string dataUsingEncoding:NSUTF8StringEncoding];
                  
                  NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utfData];
                  [object parserJsonReponse:parser withError:nil xmlString:string];
                  
                  
              }
              else
              {
                  // EL JSON viene mal formado
                  NSLog(@"EL JSON viene mal formado");
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:@"Server response bad" forKey:NSLocalizedDescriptionKey];
                  // populate the error object with the details
                  NSError * error = [NSError errorWithDomain:@"Download problem" code:-2 userInfo:details];
                  [object parserJsonReponse:nil withError:error xmlString:nil];
                  
              }
              
          }
          else
          {
              //No se pudo realizar la conexion exitosamente
              NSLog(@"No se pudo realizar la conexion exitosamente para descargar el JSON.");
              [object parserJsonReponse:nil withError:error xmlString:nil];
              
              
          }
          
          
          
      }] resume];
    
}


- (void)downloadJsonPOSTWithServiceObject:(EMServiceObject *)object
{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = object.urlService;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    
    [request setHTTPMethod:@"POST"];

    NSString * stringTosend = [[NSString alloc] init];
    int i = 0;
    for (NSString * key in object.jsonRequest)
    {
        i ++;
        if (i ==[object.jsonRequest allKeys].count)
        {
            stringTosend = [NSString stringWithFormat:@"%@%@=%@",stringTosend,key,[object.jsonRequest objectForKey:key]];
        }
        else
        {
            stringTosend = [NSString stringWithFormat:@"%@%@=%@&",stringTosend,key,[object.jsonRequest objectForKey:key]];
        }
        
    }
    NSLog(@"Body: %@",stringTosend);
//    NSData *myRequestData = [ NSData dataWithBytes: [ stringTosend UTF8String ] length: [ stringTosend length ] ];
    NSData *myRequestData = [stringTosend dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:myRequestData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        //Handle response

        if (!error)
        {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            
            if (httpResponse.statusCode == 200)
            {
                
                
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                NSLog(@"Response %@ : %@",request.URL.absoluteString,string);
                
                NSData *utfData = [string dataUsingEncoding:NSUTF8StringEncoding];
                
                NSXMLParser * parser = [[NSXMLParser alloc] initWithData:utfData];
                [object parserJsonReponse:parser withError:error xmlString:string];
                
                
            }
            else
            {
                // EL JSON viene mal formado
                NSLog(@"EL JSON viene mal formado");
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Server response bad" forKey:NSLocalizedDescriptionKey];
                // populate the error object with the details
                NSError * error = [NSError errorWithDomain:@"Download problem" code:-2 userInfo:details];
                [object parserJsonReponse:nil withError:error xmlString:nil];
                
                
            }
            
        }
        else
        {
            //No se pudo realizar la conexion exitosamente
            NSLog(@"No se pudo realizar la conexion exitosamente para descargar el JSON.");
            NSLog(@"Error: %@",error.localizedDescription);
            [object parserJsonReponse:nil withError:error xmlString:nil];
            
        }

        
    }];
    
    [postDataTask resume];
}


#pragma -mark Parser

- (void) parserJson:(NSDictionary *) json
{
}

- (void)parserCategories:(NSDictionary *) json
{
}
@end
