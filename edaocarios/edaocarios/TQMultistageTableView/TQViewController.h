//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by edao on 15-2-27.
//  Copyright (c) 2015年 edao. All rights reserved.
//  企业指标列表

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"
#import "BaseAllViewController.h"
#import "BlockUIAlertView.h"
#import "XiyezhibiaoTableViewCell.h"
#import "XiyezhibiaoDetailViewController.h"
#import "MBProgressHUD.h"
#import "PhysicalFinancialIndicatorDto.h"


@interface TQViewController : BaseAllViewController <TQTableViewDataSource,TQTableViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>

{
    BOOL isInit;
    
    //进度条
    MBProgressHUD *_HUD;
    
    
    NSUserDefaults *userDefault;
    
    //联网相关
    NSURLConnection *connection;
    NSMutableData *_dataRece;
    
    NSURLAuthenticationChallenge *_challenge;
    int requestType;
    
    //http响应码
    NSHTTPURLResponse * httpResponse;
    
    //理财收益详情上边的数据
    NSDictionary *myFundDataDetail;
    
    //所有列表数据
    NSArray *allDataArry;
    
    //分组数据
    NSArray *listFormulaIndicatorDtoArry1;
    
    NSArray *listFormulaIndicatorDtoArry2;
    
    NSArray *listFormulaIndicatorDtoArry3;
    
    NSArray *listFormulaIndicatorDtoArry4;
    
    NSString *description1;
    
    NSString *description2;
    
    NSString *description3;
    
    NSString *description4;
    
}

@property (nonatomic, strong) TQMultistageTableView *mTableView;

@property (nonatomic, copy) NSString *openViewIndex;

@property(strong,nonatomic) NSMutableURLRequest* request;
@property(strong,nonatomic)NSURL* url,*baseUrl;

@end
