//
//  NetRequestClass.m
//  MVVMTest
//
//  Created by 黄文飞 on 15/1/6.
//  Copyright (c) 2015年 黄文飞. All rights reserved.
//

#ifndef MVVMTest_Config_h
#define MVVMTest_Config_h

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);



//#define IP @"http://192.168.1.166:8080/scct"

//#define IP @"http://192.168.1.208:8082/scc"

//#define IP @"http://scctest.skyinno.com:8082/scc"

#define IP @"https://vod.api.qcloud.com"

#define IPSign @"http://23.105.208.7:8080"





#endif
