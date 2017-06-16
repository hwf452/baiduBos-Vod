//
//  CarMainViewController.h
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarMainTableViewCell.h"
#import "CarSubViewController.h"
#import "TQViewController.h"



@interface CarMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic,strong)NSArray *arryListData;


@end
