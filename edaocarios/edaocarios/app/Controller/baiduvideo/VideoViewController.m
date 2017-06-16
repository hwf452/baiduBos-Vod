//
//  VideoViewController.m
//  edaocarios
//
//  Created by harry on 2017/6/1.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
- (NSInteger) getFileSize:(NSString*) path;
- (CGFloat) getVideoDuration:(NSURL*) URL;
- (void) convertFinish;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"视频录制";
    _qualityType = UIImagePickerControllerQualityTypeHigh;
    _mp4Quality = AVAssetExportPresetHighestQuality;
    _hasVideo = NO;
    _hasMp4 = NO;
    
    
    [self setupMainViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMainViews{
    _lbVideoQuality = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"Video Quality（视频分辨率选择）";
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    _segmentedControlTop= ({
        UISegmentedControl *si = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Low",@"Medium",@"High",@"480",@"540",@"720",nil]];
        si.selectedSegmentIndex=2;
        
        [self.view addSubview:si];
        
        [si mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(5);
            make.right.equalTo(self.view).offset(-5);
            make.top.equalTo(_lbVideoQuality.mas_bottom).offset(10);
            //make.width.mas_equalTo(280);
            make.height.mas_equalTo(30);
        }];
        
        si;
    });
    [_segmentedControlTop addTarget:self action:@selector(videoQualitySgtClick:) forControlEvents:UIControlEventValueChanged];
    _btnPickVideo=({
        UIButton *btn =[UIButton new];
        [btn setTitleColor:UIColorFromRGB(0x0000ff) forState:UIControlStateNormal];
        [btn setTitle:@"PickVideo（拍摄视频）" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_segmentedControlTop.mas_bottom).offset(10);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(30);
        }];
        
        btn;
    });
    [_btnPickVideo addTarget:self action:@selector(pickVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _fileSizeLeft = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"FileSIze:";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_btnPickVideo.mas_bottom).offset(10);
            make.width.mas_equalTo(127);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _fileSize = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"0 kb";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fileSizeLeft.mas_right).offset(30);
            make.top.equalTo(_btnPickVideo.mas_bottom).offset(10);
            make.width.mas_equalTo(67);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _videoLenLeft = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"VideoLength:";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_fileSizeLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(127);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _videoLen = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"0 s";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoLenLeft.mas_right).offset(30);
            make.top.equalTo(_fileSizeLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(67);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _lbMp4Quality = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"Mp4 Quality(转码的mp4视频质量)";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_videoLenLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    _segmentedControlBottom= ({
        UISegmentedControl *si = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Low",@"Medium",@"High",nil]];
        si.selectedSegmentIndex=2;
        
        [self.view addSubview:si];
        
        [si mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_lbMp4Quality.mas_bottom).offset(10);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(30);
        }];
        
        si;
    });
    [_segmentedControlBottom addTarget:self action:@selector(mp4QualitySgtClick:) forControlEvents:UIControlEventValueChanged];
    
    _lbShouldOptimizeForNetworkUse = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"shouldOptimizeForNetworkUse";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_segmentedControlBottom.mas_bottom).offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    _btnSwitch = ({
        UISwitch *btnSwitch = [UISwitch new];
        btnSwitch.on=YES;
        [self.view addSubview:btnSwitch];
        [btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lbShouldOptimizeForNetworkUse.mas_right).offset(10);
            make.top.equalTo(_segmentedControlBottom.mas_bottom).offset(10);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(31);
        }];
        
        btnSwitch;
    });
    [_btnSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    _btnEncode=({
        UIButton *btn =[UIButton new];
        [btn setTitleColor:UIColorFromRGB(0x0000ff) forState:UIControlStateNormal];
        [btn setTitle:@"Encode(mvo视频转码mp4)" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_lbShouldOptimizeForNetworkUse.mas_bottom).offset(10);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(30);
        }];
        
        btn;
    });
    [_btnEncode addTarget:self action:@selector(encodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _convertTimeLeft = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"Convert Time:";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_btnEncode.mas_bottom).offset(10);
            make.width.mas_equalTo(127);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _convertTime = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"0 kb";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_convertTimeLeft.mas_right).offset(30);
            make.top.equalTo(_btnEncode.mas_bottom).offset(10);
            make.width.mas_equalTo(67);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _mp4SizeLeft = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"Mp4 FileSize:";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_convertTimeLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(127);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    
    _mp4Size = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"0 s";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mp4SizeLeft.mas_right).offset(30);
            make.top.equalTo(_convertTimeLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(67);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
    _btnPlay=({
        UIButton *btn =[UIButton new];
        [btn setTitleColor:UIColorFromRGB(0x0000ff) forState:UIControlStateNormal];
        [btn setTitle:@"play Mp4 File" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_mp4SizeLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(30);
        }];
        
        btn;
    });
    [_btnPlay addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)videoQualitySgtClick:(id)sender
{
//    UIImagePickerControllerQualityTypeHigh = 0,       // highest quality
//    UIImagePickerControllerQualityTypeMedium = 1,     // medium quality, suitable for transmission via Wi-Fi
//    UIImagePickerControllerQualityTypeLow = 2,         // lowest quality, suitable for tranmission via cellular network
//    UIImagePickerControllerQualityType640x480 NS_ENUM_AVAILABLE_IOS(4_0) = 3,    // VGA quality
//    UIImagePickerControllerQualityTypeIFrame1280x720 NS_ENUM_AVAILABLE_IOS(5_0) = 4,
//    UIImagePickerControllerQualityTypeIFrame960x540 NS_ENUM_AVAILABLE_IOS(5_0) = 5,
    
    NSLog(@"videoQualitySgtClick");
    
    NSInteger index = [(UISegmentedControl* )sender selectedSegmentIndex];
    
    switch (index) {
        case 0:
            _qualityType = UIImagePickerControllerQualityTypeLow; //30秒：589K  144X192  MOV
            break;
        case 1:
            _qualityType = UIImagePickerControllerQualityTypeMedium; //30秒：40.5m  360X480  MOV
            break;
        case 2:
            _qualityType = UIImagePickerControllerQualityTypeHigh; //30秒：60m 360X480  MOV
            break;
        case 3:
            _qualityType = UIImagePickerControllerQualityType640x480; //30秒:90.1m  480X640  MOV
            break;
        case 4:
            _qualityType = UIImagePickerControllerQualityTypeIFrame960x540; //30秒:111.9m  540X960  MOV
            break;
        case 5:
            _qualityType = UIImagePickerControllerQualityTypeIFrame1280x720; //30秒:149.1m  720X1280  MOV
            break;
        default:
            break;
    }
    NSLog(@"selectedSegmentIndex:%zi",_qualityType);
}

- (void) mp4QualitySgtClick:(id)sender
{
    NSLog(@"mp4QualitySgtClick");
    NSInteger index = [(UISegmentedControl* )sender selectedSegmentIndex];
    switch (index) {
        case 0:
            _mp4Quality = AVAssetExportPresetLowQuality;
            break;
        case 1:
            _mp4Quality = AVAssetExportPresetMediumQuality;
            break;
        case 2:
            _mp4Quality = AVAssetExportPresetHighestQuality;
        default:
            break;
    }
}

- (void)pickVideoBtnClick:(id)sender
{
    if (_hasVideo)
    {
        _mp4Path = nil;
        _videoURL = nil;
        _startDate = nil;
    }
    UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    
    pickerView.videoQuality =_qualityType ;
    
    [self presentViewController:pickerView animated:YES completion:^{
        
    }];
    pickerView.videoMaximumDuration = 30;
    pickerView.delegate = self;
}

- (void) switchChanged:(id)sender
{
    NSLog(@"switchChanged");
    _networkOpt = ((UISwitch*) sender).on;
}

- (void)encodeBtnClick:(id)sender
{
    if (!_hasVideo)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                         message:@"Please record a video first"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:_mp4Quality])
        
    {
        _alert = [[UIAlertView alloc] init];
        [_alert setTitle:@"Waiting.."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(_alert.frame),
                                    CGRectGetHeight(_alert.frame));
        [_alert addSubview:activity];
        [activity startAnimating];
        [_alert show];
        _startDate = [NSDate date];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        _mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        exportSession.shouldOptimizeForNetworkUse = _networkOpt;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [_alert dismissWithClickedButtonIndex:0 animated:NO];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [_alert dismissWithClickedButtonIndex:0
                                                 animated:YES];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void) playBtnClick:(id)sender
{
    if (!_hasMp4)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Now mp4 file found"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@", _mp4Path]]];
    NSLog(@"%@",[NSString stringWithFormat:@"file://localhost/private%@", _mp4Path]);
    [self presentViewController:playerView animated:YES completion:^{
        
    }];
}

#pragma mark - private Method

- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

- (void) convertFinish
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    _alert = [[UIAlertView alloc] initWithTitle:@"Finish"
                                        message:[NSString stringWithFormat:@"Successful, it takes %.2fs", duration]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
    [_alert show];
    
    _convertTime.text = [NSString stringWithFormat:@"%.2f s", duration];
    _mp4Size.text = [NSString stringWithFormat:@"%ld kb", [self getFileSize:_mp4Path]];
    _hasMp4 = YES;
}


- (void) viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _videoURL = info[UIImagePickerControllerMediaURL];
    _fileSize.text = [NSString stringWithFormat:@"%zi kb", [self getFileSize:[[_videoURL absoluteString] substringFromIndex:16]]];
    _videoLen.text = [NSString stringWithFormat:@"%.0f s", [self getVideoDuration:_videoURL]];
    _hasVideo = YES;
    NSLog(@"_videoURL:%@",_videoURL);
    
    //创建ALAssetsLibrary对象并将视频保存到媒体库
    ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:_videoURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            NSLog(@"video saved with success.");
            NSLog(@"assetURL:%@",assetURL);
            _videoURL=assetURL;
        }else
        {
            NSLog(@"while saving the video error:%@", error);
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
