//
//  CarSubViewController.h
//  edaocarios
//
//  Created by harry on 2017/5/11.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarSubTableViewCell.h"

@interface CarSubViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;



@property(nonatomic,strong)NSArray *arrySubCarListData;
@property(nonatomic,copy)NSString *strTitle;

@end
