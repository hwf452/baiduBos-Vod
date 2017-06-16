//
//  CarSubTableViewCell.h
//  edaocarios
//
//  Created by harry on 2017/5/11.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KCarSubTableViewCell  @"CarSubTableViewCell"


@interface CarSubTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *lb_title;
@property (nonatomic, strong) UIImageView *carLogoImageView;

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1;


@end
