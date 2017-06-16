//
//  TencentVideoViewModelClass.h
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModelClass.h"


@interface TencentVideoViewModelClass : ViewModelClass

//获取上传视频到腾讯云端签名
-(void)getUploadTencentVodSign;
//获取腾讯云端视频列表
-(void)getTencentCouldVideoList:(NSInteger)pageSize pageNo:(NSInteger)pageNo;

//获取腾讯云端单条视频
-(void)getTencentCouldVideo:(NSString *)fileId;

@end
