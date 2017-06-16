//
//  TencentVideoListCell.h
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KTencentVideoListCell  @"TencentVideoListCell"


@interface TencentVideoListCell : UITableViewCell

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1;

@property (strong, nonatomic) UILabel *lb_fileId;
@property (strong, nonatomic) UILabel *lb_fileName;
@property (nonatomic, strong) UIImageView *carLogoImageView;



@end
