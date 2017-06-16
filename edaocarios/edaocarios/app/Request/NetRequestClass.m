//
//  NetRequestClass.m
//  MVVMTest
//
//  Created by 黄文飞 on 15/1/6.
//  Copyright (c) 2015年 黄文飞. All rights reserved.
//

#import "NetRequestClass.h"
#import "Reachability.h"
#import "AFURLRequestSerialization.h"


@interface NetRequestClass ()

@end


@implementation NetRequestClass

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
                break;
            default:
                
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];

    
    return netState;
}

//检测网络状态
+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach =[Reachability reachabilityForInternetConnection];
    
    //NetworkStatus status = [reach currentReachabilityStatus];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"remind", nil)
//                                                        message:NSLocalizedString(@"nonetworkremine", nil)
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"determine", nil) otherButtonTitles:nil];
//        [alert show];
        
        
        
        
        
        return NO;
    }else{
        
        NSLog(@"有网络");
        
        
    }
    
    return isExistenceNetwork;
}

/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    
    if ([self isConnectionAvailable]) {
        
        
        NSURL *URL = [NSURL URLWithString:requestURLString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy = securityPolicy;
//
        
//        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
//        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", nil];
//        manager.responseSerializer = serializer;
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

        
        [manager GET:URL.absoluteString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            block(responseObject);
          
          
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock();
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"remind", nil)
//                                                            message:NSLocalizedString(@"serverNoResponse", nil)
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"determine", nil) otherButtonTitles:nil];
//            [alert show];
        }];
        
        
        
      
    }
    
    
}

#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL1: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    
    if ([self isConnectionAvailable]) {
        
        
        NSURL *URL = [NSURL URLWithString:requestURLString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", nil];
        manager.responseSerializer = serializer;
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        
        [manager GET:URL.absoluteString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           // NSLog(@"%@",responseObject);
            block(responseObject);
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock();
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"remind", nil)
//                                                            message:NSLocalizedString(@"serverNoResponse", nil)
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"determine", nil) otherButtonTitles:nil];
//            [alert show];
        }];
        
        
        
        
    }
    
    
}



#pragma --mark POST请求方式

+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    
//    if ([self isConnectionAvailable]) {
        
        
        NSURL *URL = [NSURL URLWithString:requestURLString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy = securityPolicy;

        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:URL.absoluteString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            block(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock();
        }];
//    }
    
}


+ (void)POSTWithRequestURL: (NSString *) requestURLString
             WithParameter: (NSDictionary *) parameter
      WithReturnValeuBlock: (ReturnValueBlock) block
        WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
          WithFailureBlock: (FailureBlock) failureBlock
{
  
  if ([self isConnectionAvailable]) {
    
    
    NSURL *URL = [NSURL URLWithString:requestURLString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //        securityPolicy.allowInvalidCertificates = YES;
    //        manager.securityPolicy = securityPolicy;
    
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:URL.absoluteString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
      
      NSDictionary *result = responseObject;
      NSInteger success = [result[@"success"] integerValue];

      if (success == 0 && errorBlock) {
        errorBlock(responseObject);
        
      }else{
        NSDictionary *root = result[@"root"];
        if (block) {
            block(root);
        }
      }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
      if (failureBlock) {
        failureBlock();
      }
    }];
    
  }
}



/*
 "remind"="提示";
 "determine"="确定";
 "nonetworkremine"="当前网络不可用，请检查网络设置";
 "netshowstate"="数据处理中";
 
 */


@end
