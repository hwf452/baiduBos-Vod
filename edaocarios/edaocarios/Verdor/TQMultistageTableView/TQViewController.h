//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by edao on 15-2-27.
//  Copyright (c) 2015年 edao. All rights reserved.
//  企业指标列表

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"
#import "TQCarSubTableViewCell.h"


@interface TQViewController : UIViewController <TQTableViewDataSource,TQTableViewDelegate>
{
    BOOL isInit;
}


@property (nonatomic, strong) TQMultistageTableView *mTableView;
//所有列表数据
@property (nonatomic, copy) NSArray *allCarArry;

@property(nonatomic,copy)NSString *strTitle;


@end
