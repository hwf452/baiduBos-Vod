//
//  TencentTakeVideoViewController.m
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "TencentTakeVideoViewController.h"

@interface TencentTakeVideoViewController ()

@end

@implementation TencentTakeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFlashOpen=NO;
    _isFrontOpen=NO;
    _isRecording=NO;
    [self setupMainViews];
    
    
    [self takeVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMainViews{
    _btnBack=({
        UIButton *btn =[UIButton new];
        [btn setImage:[UIImage imageNamed:@"live_ic_back"] forState:UIControlStateNormal];
        
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        btn;
    });
    [_btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnChangeCamara=({
        UIButton *btn =[UIButton new];
        [btn setImage:[UIImage imageNamed:@"live_ic_change"] forState:UIControlStateNormal];
        
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-5);
            make.top.equalTo(self.view).offset(20);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        btn;
    });
    [_btnChangeCamara addTarget:self action:@selector(btnChangeCamaraClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnFlashChange=({
        UIButton *btn =[UIButton new];
        [btn setImage:[UIImage imageNamed:@"live_ic_send"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"set_ic_right"] forState:UIControlStateSelected];
        btn.selected=NO;
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(20);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        btn;
    });
    [_btnFlashChange addTarget:self action:@selector(btnFlashChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    _startTakeVideoOrFinish=({
        UIButton *btn =[UIButton new];
        [btn setImage:[UIImage imageNamed:@"map_ic_button"] forState:UIControlStateNormal];
        
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
        
        btn;
    });
    [_startTakeVideoOrFinish addTarget:self action:@selector(btnVideoTakeClick:) forControlEvents:UIControlEventTouchUpInside];
    _useVideo=({
        UIButton *btn =[UIButton new];
        [btn setImage:[UIImage imageNamed:@"map_ic_confirm"] forState:UIControlStateNormal];
        btn.hidden=YES;
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        btn;
    });
    [_useVideo addTarget:self action:@selector(btnUseVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    _lbVideoLeng = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0xffffff);
        label.numberOfLines = 0;
        label.text=@"00:00:00";
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30);
            make.centerX.equalTo(self.view);
        }];
        
        label;
    });
    
    
}
- (void)btnBackClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)btnChangeCamaraClick:(UIButton *)sender{
    if (_isFrontOpen==YES) {
        // 切换前后摄像头 参数 isFront 代表是否前置摄像头 默认前置
        [[TXUGCRecord shareInstance] switchCamera:NO];
        _isFrontOpen =NO;
    }else{
        // 切换前后摄像头 参数 isFront 代表是否前置摄像头 默认前置
        [[TXUGCRecord shareInstance] switchCamera:YES];
        _isFrontOpen =YES;
    }
    
}
- (void)btnFlashChangeClick:(UIButton *)sender{
    sender.selected=!sender.selected;
    if(_isFlashOpen){
        // 是否打开闪光灯
        [[TXUGCRecord shareInstance] toggleTorch: NO];
        _isFlashOpen=NO;
    }else{
        // 是否打开闪光灯
        [[TXUGCRecord shareInstance] toggleTorch: YES];
        _isFlashOpen=YES;
    }
    
}
- (void)btnVideoTakeClick:(UIButton *)sender{
    if (_isRecording) {
        [[TXUGCRecord shareInstance] stopRecord];
        _isRecording=NO;
        _useVideo.hidden=NO;
    }else{
        [[TXUGCRecord shareInstance] startRecord];
        _isRecording=YES;
        _useVideo.hidden=YES;
    }
}
- (void)btnUseVideoClick:(UIButton *)sender{
    if (_videoMp4) {
        if (self.mp4UrlBlock) {
            self.mp4UrlBlock(_videoMp4,_tencentCoverVideo);
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

-(void)takeVideo{
    _config = [[TXUGCSimpleConfig alloc] init];
    //config.videoQuality = VIDEO_QUALITY_LOW;       // 360p, 10秒钟视频大约0.75M
    _config.videoQuality   = VIDEO_QUALITY_HIGH;    // 540p, 10秒钟视频大约 1.5M （编码参数同微信iOS版小视频）
    //config.videoQuality = VIDEO_QUALITY_HIGH;      // 720p, 10秒钟视频大约   3M
    //config.watermark      = image;                   // 水印图片(要用背景透明的 PNG 图片)
    //config.watermarkPos   = pos;                     // 水印图片的位置
    _config.frontCamera    = YES;                     //是否前置摄像头，使用 switchCamera 可以切换
    [TXUGCRecord shareInstance].recordDelegate = self;     //self 实现了 TXVideoPublishListener 接口
    [[TXUGCRecord shareInstance] startCameraSimple:_config preview:self.view];
    [[TXUGCRecord shareInstance] switchCamera:NO];
}

/**
 * 短视频录制进度
 */
-(void) onRecordProgress:(NSInteger)milliSecond{
    NSLog(@"videoLeng:%zi",milliSecond/1000);
    NSInteger second=milliSecond/1000;
    
    if ((milliSecond/1000)<60) {
        if (second<10) {
            _lbVideoLeng.text=[NSString stringWithFormat:@"00:00:0%zi",milliSecond/1000];
        }else{
            _lbVideoLeng.text=[NSString stringWithFormat:@"00:00:%zi",milliSecond/1000];
        }
    }else if ((milliSecond/1000)<3600) {
        NSInteger minute=(milliSecond/1000)/60;
        NSInteger second=(milliSecond/1000)%60;
        if (second<10) {
            _lbVideoLeng.text=[NSString stringWithFormat:@"00:%zi:0%zi",minute,second];
        }else{
            _lbVideoLeng.text=[NSString stringWithFormat:@"00:%zi:%zi",minute,second];
        }
    }else{
        
    }
}

/**
 * 短视频录制完成
 */
-(void) onRecordComplete:(TXRecordResult*)result{
    NSLog(@"videoPath:%@",result.videoPath);
    _videoMp4=result.videoPath;
    _tencentCoverVideo=result.coverImage;
    //NSLog(@"coverImage:%@",result.coverImage);
}

/**
 * 短视频录制事件通知
 */
-(void) onRecordEvent:(NSDictionary*)evt{
    
}


@end
