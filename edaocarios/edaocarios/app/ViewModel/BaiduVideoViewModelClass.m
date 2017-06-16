//
//  BaiduVideoViewModelClass.m
//  edaocarios
//
//  Created by harry on 2017/6/16.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "BaiduVideoViewModelClass.h"

@implementation BaiduVideoViewModelClass

//获取百度云端视频列表

-(void)getBaiduCouldVideoList:(NSInteger)pageSize pageNo:(NSInteger)pageNo{
    
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    if (pageSize>=10) {
        [parameter setObject:[NSString stringWithFormat:@"%zi",pageSize] forKey:@"pageSize"];
        [parameter setObject:[NSString stringWithFormat:@"%zi",pageNo] forKey:@"pageNo"];
    }
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",IPSign,@"/baiduserver/getBaiduMediaResourceList"];
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
