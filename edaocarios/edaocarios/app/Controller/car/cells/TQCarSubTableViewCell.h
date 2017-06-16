//
//  TQCarSubTableViewCell.h
//  edaocarios
//
//  Created by harry on 2017/5/27.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KTQCarSubTableViewCell  @"TQCarSubTableViewCell"

@interface TQCarSubTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *lb_title;
@property (nonatomic, strong) UIImageView *carLogoImageView;
@property (nonatomic, strong) UIView *viewLine;

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1;



@end
