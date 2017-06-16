//
//  TencentTakeVideoViewController.h
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXRTMPSimpleSDK/TXUGCRecord.h>

@interface TencentTakeVideoViewController : UIViewController<TXVideoRecordListener>


@property (nonatomic, strong)UIButton *btnBack;

@property (nonatomic, strong)UIButton *btnChangeCamara;

@property (nonatomic, strong)UIButton *startTakeVideoOrFinish;

@property (nonatomic, strong)UIButton *useVideo;

@property (nonatomic, strong)UIButton *btnFlashChange;

@property (nonatomic, strong)TXUGCSimpleConfig *config;

@property (nonatomic, strong)UILabel *lbVideoLeng;

@property (nonatomic, assign)BOOL isFlashOpen;

@property (nonatomic, assign)BOOL isFrontOpen;

@property (nonatomic, assign)BOOL isRecording;

@property (nonatomic, copy)NSString *videoMp4;

@property (nonatomic, strong)UIImage *tencentCoverVideo;

@property(nonatomic, copy)void(^mp4UrlBlock)(NSString *mp4Url,UIImage *tencentCoverVideo);

@end
