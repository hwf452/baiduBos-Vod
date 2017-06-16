//
//  TencentVideoViewModelClass.m
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "TencentVideoViewModelClass.h"

@implementation TencentVideoViewModelClass


//获取上传视频到腾讯云端签名
-(void)getUploadTencentVodSign{
    
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    NSString *url=[NSString stringWithFormat:@"%@%@",IPSign,@"/weixinvod/tencentVodSign"];
    NSLog(@"url:%@",url);
    
    NSLog(@"parameter:%@",parameter);
    
    
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        
        [self fetchValueSuccessWithDic:returnValue];
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        NSLog(@"网络异常");
        
    }];

    
}
//获取腾讯云端视频列表
-(void)getTencentCouldVideoList:(NSInteger)pageSize pageNo:(NSInteger)pageNo{
    
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    if (pageSize>=10) {
        [parameter setObject:[NSString stringWithFormat:@"%zi",pageSize] forKey:@"pageSize"];
        [parameter setObject:[NSString stringWithFormat:@"%zi",pageNo] forKey:@"pageNo"];
    }
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",IPSign,@"/weixinvod/getTencentVodVideoList"];
    NSLog(@"url:%@",url);
    
    NSLog(@"parameter:%@",parameter);
    
    
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        
        [self fetchValueSuccessWithDic:returnValue];
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        NSLog(@"网络异常");
        
    }];
}

//获取腾讯云端单条视频
-(void)getTencentCouldVideo:(NSString *)fileId{
    
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    
    [parameter setObject:fileId forKey:@"fileId"];
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",IPSign,@"/weixinvod/getTencentVodVideoByFileId"];
    NSLog(@"url:%@",url);
    
    NSLog(@"parameter:%@",parameter);
    
    
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        
        
        [self fetchValueSuccessWithDic:returnValue];
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        NSLog(@"网络异常");
        
    }];

    
}
#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSArray *) returnValue
{
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    
    
    self.returnBlock(returnValue);
}

#pragma 对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

#pragma 对网路异常进行处理
-(void) netFailure
{
    self.failureBlock();
}

@end
