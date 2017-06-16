//
//  NetRequestClass.m
//  MVVMTest
//
//  Created by 黄文飞 on 15/1/6.
//  Copyright (c) 2015年 黄文飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestClass : NSObject

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

+(BOOL) isConnectionAvailable;

#pragma POST请求
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;

//  统一处理错误
+ (void)POSTWithRequestURL: (NSString *) requestURLString
             WithParameter: (NSDictionary *) parameter
      WithReturnValeuBlock: (ReturnValueBlock) block
        WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
          WithFailureBlock: (FailureBlock) failureBlock;


#pragma GET请求
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;

#pragma GET请求
+ (void) NetRequestGETWithRequestURL1: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;

@end
