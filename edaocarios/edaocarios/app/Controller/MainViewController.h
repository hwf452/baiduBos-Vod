//
//  ViewController.h
//  edaocarios
//
//  Created by harry on 2017/5/2.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"

#import "VideoViewController.h"
#import "BaiDuVodVideoViewController.h"
#import "BaiDuBosVideoViewController.h"
#import "BaiDuVodVideoPlayViewController.h"
#import "TencentVideoViewController.h"
#import "TencentVideoListViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic,strong)NSArray *arryListData;


@end

