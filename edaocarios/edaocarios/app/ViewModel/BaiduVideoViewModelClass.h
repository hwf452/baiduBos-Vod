//
//  BaiduVideoViewModelClass.h
//  edaocarios
//
//  Created by harry on 2017/6/16.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "ViewModelClass.h"

@interface BaiduVideoViewModelClass : ViewModelClass

//获取百度云端视频列表
-(void)getBaiduCouldVideoList:(NSInteger)pageSize pageNo:(NSInteger)pageNo;


@end
