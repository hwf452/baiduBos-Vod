//
//  BaiDuVodVideoViewController.m
//  edaocarios
//
//  Created by harry on 2017/6/5.
//  Copyright © 2017年 edao. All rights reserved.
//


#import "BaiDuBosVideoViewController.h"

@interface BaiDuBosVideoViewController ()
- (NSInteger) getFileSize:(NSString*) path;
- (CGFloat) getVideoDuration:(NSURL*) URL;
- (void) convertFinish;
@end

@implementation BaiDuBosVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"百度bos";
    _qualityType = UIImagePickerControllerQualityTypeHigh;
    _mp4Quality = AVAssetExportPresetHighestQuality;
    _hasVideo = NO;
    _hasMp4 = NO;
    
    
    [self setupMainViews];
    
    _credentials = [BCECredentials new];
    _credentials.accessKey = @"a29fcaec8a704e3386fb23e849484bd8";
    _credentials.secretKey = @"6bf5fd73bc8045f88b6fbfa9ece3636d";
    
    _bosConfig = [[BOSClientConfiguration alloc] init];
    _bosConfig.allowsCellularAccess=YES;
    //_bosConfig.region = [BCERegion region:BCERegionBJ];
    _bosConfig.region = [BCERegion region:BCERegionGZ];
    //_bosConfig.endpoint = @"https://bj.bcebos.com";
    //_bosConfig.endpoint = @"https://bj.bcebos.com";
    _bosConfig.credentials = _credentials;
    
    _bosClient = [[BOSClient alloc] initWithConfiguration:_bosConfig];
    
    VODClientConfiguration* vodConfig = [VODClientConfiguration new];
    vodConfig.credentials = _credentials;
    vodConfig.allowsCellularAccess=YES;
    _vodClient = [[VODClient alloc] initWithConfiguration:vodConfig];

    
    
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
        label.font = [UIFont systemFontOfSize:17];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"Mp4 Quality(转码的mp4视频质量)";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(_videoLenLeft.mas_bottom).offset(10);
            make.width.mas_equalTo(167);
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
        [btn setTitle:@"Encode(视频转码并上传到百度bos)" forState:UIControlStateNormal];
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
        [btn setTitle:@"play Mp4 File(播放转码的mp4)" forState:UIControlStateNormal];
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
    _upLoadVideoProgress = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"% 0";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(30);
            make.top.equalTo(_btnPlay.mas_bottom).offset(10);
            make.width.mas_equalTo(167);
            make.height.mas_equalTo(21);
        }];
        
        label;
    });
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
    //[self baiduVideoUpload];
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    //    _alert = [[UIAlertView alloc] initWithTitle:@"Finish"
    //                                        message:[NSString stringWithFormat:@"Successful, it takes %.2fs", duration]
    //                                       delegate:nil
    //                              cancelButtonTitle:@"OK"
    //                              otherButtonTitles: nil];
    //    [_alert show];
    
    _convertTime.text = [NSString stringWithFormat:@"%.2f s", duration];
    _mp4Size.text = [NSString stringWithFormat:@"%ld kb", [self getFileSize:_mp4Path]];
    _hasMp4 = YES;
    
    //[self bosTest];
    //生成媒资并获取MediaID
    [self bosTest];
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
            _videoURLRecourse=assetURL;
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


-(void) bosTest{
    //新建Bucket
//    BCETask* task = [_bosClient putBucket:@"vodsave1"];
//    
//    // 任务可以异步执行。
//    task.then(^(BCEOutput* output) {
//        // 可以在block内判断任务执行的结果。
//        if (output.response) {
//            // 任务执行成功。
//            NSLog(@"新建Bucket成功");
//        }
//        
//        if (output.error) {
//            // 任务执行失败。
//            NSLog(@"error:%@",output.error);
//            NSLog(@"新建Bucket失败，Bucket己存在");
//        }
//        
//        if (output.progress) {
//            // 任务执行进度。
//            NSLog(@"progress:%@",output.progress);
//        }
//    });
    
    
    //查看Bucket列表
    BCETask* task1 = [_bosClient listBuckets];
    task1.then(^(BCEOutput* output) {
        if (output.response) {
            BOSListBucketResponse *response = (BOSListBucketResponse*)output.response;
            NSLog(@"%zi",response.buckets.count);
            // 获取Owner 如下代码可以列出Bucket的Owner：
            BOSBucketOwner* owner = response.owner;
            NSLog(@"the buckets owner is %@", owner.ownerID);
            
            // 获取Bucket信息
            NSArray<BOSBucketSummary*>* buckets = response.buckets;
            for (BOSBucketSummary* bucket in buckets) {
                NSLog(@"bucket name: %@", bucket.name);
                NSLog(@"bucket location: %@", bucket.location);
                NSLog(@"bucket create date: %@", bucket.createDate);
            }
            
        }
        
        if (output.error) {
            NSLog(@"error:%@",output.error);
        }
    });
    
    //判断Bucket是否存在，以及是否有权限访问
    BCETask* task2 = [_bosClient headBucket:@"videosave"];
    task2.then(^(BCEOutput* output) {
        if (output.response) {
            //BOSHeadBucketResponse* response = (BOSHeadBucketResponse*)output.response;
            NSLog(@"head bucket success!");
            NSLog(@"Bucket 存在");
            
        }
        
        if (output.error) {
            NSLog(@"Bucket not exist or no permission!");
        }
    });
    
    //删除Bucket
    //    BCETask* task3 = [_bosClient deleteBucket:@"vodsave2"];
    //    task3.then(^(BCEOutput* output) {
    //        if (output.response) {
    //            BOSHeadBucketResponse *response = (BOSDeleteBucketResponse*)output.response;
    //            NSLog(@"delete bucket success!");
    //        }
    //
    //        if (output.error) {
    //            NSLog(@"delete bucket failure");
    //        }
    //    });
    
    
    
    //上传视频到百度bos
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        // 主要方法
        [assetLibrary assetForURL:_videoURLRecourse resultBlock:^(ALAsset *asset) {
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
            _movPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.MOV", [formater stringFromDate:[NSDate date]]];
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            [data writeToFile:_movPath atomically:YES];
            
            
            BOSObjectContent* content = [[BOSObjectContent alloc] init];
            // 以文件方式
            //content.objectData.file = _movPath;
            
            // 或者以二进制数据方式
            content.objectData.data = data;
            
            NSString *key=[NSString stringWithFormat:@"output-%@.MOV",[formater stringFromDate:[NSDate date]]];
            
            BOSPutObjectRequest* request = [[BOSPutObjectRequest alloc] init];
            request.bucket = @"videosave";
            request.key =key;
            request.objectContent = content;
            NSLog(@"上传视频之前key:%@",key);
            
            BCETask* task4 = [_bosClient putObject:request];
            task4.then(^(BCEOutput* output) {
                if (output.progress) {
                    NSLog(@"put object progress is %@", output.progress);
                }
                
                if (output.response) {
                    BOSPutObjectResponse* response = (BOSPutObjectResponse*)output.response;
                    BCEResponseMetadata* metadata=response.metadata;
                    NSString* eTag=metadata.eTag;
                    NSString* requestID=metadata.requestID;
                    NSLog(@"NSString* requestID:%@",requestID);
                    NSLog(@"put object success!");
                    
                    
                    [self getBOSObjectContentWithKey:key bucket:@"videosave"];
                }
                
                if (output.error) {
                    NSLog(@"put object failure");
                }
            });
            
            
            
            
        } failureBlock:nil];
        
    });
    
    //查看Bucket中Object列表。
    BOSListObjectsRequest* listObjRequest = [[BOSListObjectsRequest alloc] init];
    listObjRequest.bucket = @"videosave";
    
    
    BCETask* task5 = [_bosClient listObjects:listObjRequest];
    task5.then(^(BCEOutput* output) {
        if (output.response) {
            BOSListObjectsResponse* listObjResponse = (BOSListObjectsResponse*)output.response;
            for (int i=0; i<listObjResponse.contents.count; i++) {
                BOSObjectInfo* object=[listObjResponse.contents objectAtIndex:i];
                NSLog(@"the object key is %@", object.key);
//                NSLog(@"the object lastModified is %@", object.lastModified);
//                NSLog(@"the object eTag is %@", object.eTag);
//                NSLog(@"the object size is %llu", object.size);
//                NSLog(@"the object owner id is %@", object.owner.ownerID);
                
//                if (i==0) {
//                    [self getBOSObjectContent:object bucket:@"videosave"];
//                }
                
            }
            
                    }
        
        if (output.error) {
            NSLog(@"list objects failure");
        }
    });
    
    
}
//获取云端存储的单个Object文件
-(void)getBOSObjectContent:(BOSObjectInfo *)object bucket:(NSString *)bucket{
    
    BOSGetObjectRequest* getObjRequest = [[BOSGetObjectRequest alloc] init];
    getObjRequest.bucket = bucket;
    getObjRequest.key = object.key;
    BCETask* task = [_bosClient getObject:getObjRequest];
    task.then(^(BCEOutput* output) {
        if (output.response) {
            BOSGetObjectResponse *response = (BOSGetObjectResponse*)output.response;
            BOSObjectData* objectData=response.objectData;
            NSData* data=objectData.data;
//            NSLog(@"data size is %lu", data.length);
//            NSLog(@"get object success!");
        }
        
        if (output.error) {
            NSLog(@"get object failure with %@", output.error);
        }
        
        if (output.progress) {
            NSLog(@"the get object progress is %@", output.progress);
        }
    });
}

//获取云端存储的单个Object文件
-(void)getBOSObjectContentWithKey:(NSString *)key bucket:(NSString *)bucket{
    
    BOSGetObjectRequest* getObjRequest = [[BOSGetObjectRequest alloc] init];
    getObjRequest.bucket = bucket;
    getObjRequest.key = key;
    BCETask* task = [_bosClient getObject:getObjRequest];
    task.then(^(BCEOutput* output) {
        if (output.response) {
            BOSGetObjectResponse *response = (BOSGetObjectResponse*)output.response;
            BOSObjectData* objectData=response.objectData;
            NSData* data=objectData.data;
            NSLog(@"getBOSObjectContentWithKey data size is %lu", data.length);
            NSLog(@"get object success!");
        }
        
        if (output.error) {
            NSLog(@"get object failure with %@", output.error);
        }
        
        if (output.progress) {
            NSLog(@"the get object progress is %@", output.progress);
        }
    });
}

@end
