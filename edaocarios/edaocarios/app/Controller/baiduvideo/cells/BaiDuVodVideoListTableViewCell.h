//
//  BaiDuVodVideoListTableViewCell.h
//  edaocarios
//
//  Created by harry on 2017/6/16.
//  Copyright © 2017年 edao. All rights reserved.
//


#import <UIKit/UIKit.h>
#define KBaiDuVodVideoListTableViewCell  @"BaiDuVodVideoListTableViewCell"


@interface BaiDuVodVideoListTableViewCell : UITableViewCell

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1;

@property (strong, nonatomic) UILabel *lb_fileId;
@property (strong, nonatomic) UILabel *lb_fileName;
@property (nonatomic, strong) UIImageView *carLogoImageView;



@end
