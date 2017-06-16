//
//  BaiDuVodVideoViewController.m
//  edaocarios
//
//  Created by harry on 2017/6/5.
//  Copyright © 2017年 edao. All rights reserved.
//


#import "BaiDuVodVideoPlayViewController.h"

@interface BaiDuVodVideoPlayViewController ()

@end

@implementation BaiDuVodVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"百度云端视频列表&Vod播放";
//    _qualityType = UIImagePickerControllerQualityTypeHigh;
//    _mp4Quality = AVAssetExportPresetHighestQuality;
//    _hasVideo = NO;
//    _hasMp4 = NO;
    
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

    [self setupMainViews];
    
    [self getBaiduVideoList];
    
    //[self getMedia:nil mediaId:@"mda-hffpa8tcf2mhsggj"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMainViews{
    self.tableView = ({
        UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [aTableView registerClass:[BaiDuVodVideoListTableViewCell class] forCellReuseIdentifier:KBaiDuVodVideoListTableViewCell];
        
        
        
        //        aTableView.tableHeaderView = self.headView;
        //        aTableView.tableFooterView = [UIView new];
        aTableView.dataSource = self;
        aTableView.delegate = self;
        aTableView.backgroundColor = UIColorFromRGB(0xffffff);
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:aTableView];
        
        [aTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        
        
        aTableView;
    });
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arryListData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSDictionary *dict =[self.arryListData objectAtIndex:indexPath.section];
    
    
    BaiDuVodVideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBaiDuVodVideoListTableViewCell forIndexPath:indexPath];
    
    [cell loadContent:dict index:indexPath.section];
    
    return cell;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSString *title=[self.arryListData objectAtIndex:indexPath.section];
    //
    //
    //
    //    return [tableView fd_heightForCellWithIdentifier:KTencentVideoListCell configuration:^(id cell) {
    //        [cell loadContent:title index:indexPath.row];
    //    }];;
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.0f;
}

- (UIView *)tableView:(UITableView *)mTableView viewForHeaderInSection:(NSInteger)section{
    
    //    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    //
    //    header.backgroundColor=UIColorFromRGB(0xff00ff);
    
    UIView *header = [UIView new];
    
    header.backgroundColor=UIColorFromRGB(0xeeeeee);
    
    
    
    return header;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if (section==3) {
    //       return 4.0f;
    //    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *header = [UIView new];
    
    header.backgroundColor=UIColorFromRGB(0xeeeeee);
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict =[self.arryListData objectAtIndex:indexPath.section];
    [self getMedia:nil mediaId:[dict objectForKey:@"mediaId"]];
    
}

-(void)getBaiduVideoList{
    [self showProgress];
    BaiduVideoViewModelClass *baiduVideoViewModelClass=[[BaiduVideoViewModelClass alloc] init];
    [baiduVideoViewModelClass setBlockWithReturnBlock:^(id returnValue) {
        [self closeProgress];
        NSLog(@"returnValue:%@",returnValue);
        _arryListData=returnValue;
        NSLog(@"%@",[_arryListData objectAtIndex:0]);
        [self.tableView reloadData];
        
        
        
    } WithErrorBlock:^(id errorCode) {
        [self closeProgress];
    } WithFailureBlock:^{
        [self closeProgress];
    }];
    
    [baiduVideoViewModelClass getBaiduCouldVideoList:100 pageNo:1];
    
}


-(void)closeProgress{
    
    [SVProgressHUD dismiss];
    
}

-(void)showProgress{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD show];
}




//查询媒资状态
-(void)getMedia:(VODGenerateMediaIDResponse *)res mediaId:(NSString *)mediaId{
    
    [self showProgress];
    BCETask *task = [_vodClient getMedia:mediaId];
    task.then(^(BCEOutput* output) {
        [self closeProgress];
        if (output.response) {
            //通过返回的response获取mediaId等相关字段
            VODGetMediaResponse* response = (VODGetMediaResponse*)output.response;
            //RUNNING   PUBLISHED
            NSLog(@"status:%@",response.status);
            NSLog(@"playableUrlList:%zi",response.playableUrlList.count);
            NSLog(@"thumbnailList:%zi",response.thumbnailList.count);
            for (int i=0; i<response.playableUrlList.count;i++) {
                VODPlayableURL *vODPlayableURL=[response.playableUrlList objectAtIndex:i];
                NSLog(@"url:%@",vODPlayableURL.url);
                if (i==0) {
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            BaiDuMediaPlayerController *play=[BaiDuMediaPlayerController new];
//                                            play.playerUrl=vODPlayableURL.url;
//                                            [self.navigationController pushViewController:play animated:YES];
//                    
//                                        });
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
                        play.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:vODPlayableURL.url]];
                        [self.navigationController presentViewController:play animated:YES completion:^{
                            
                        }];
                    });
                    
                    
                }
            }
            for (int i=0; i<response.thumbnailList.count;i++) {
                NSString *thumbnailurl=[response.thumbnailList objectAtIndex:i];
                NSLog(@"thumbnailurl:%@",thumbnailurl);
            }
            
            
            
        }
        
        if (output.error) {//处理媒资请求错误
            //处理相关业务逻辑
            NSLog(@"error:%@",output.error);
            
        }
    });
    
}


@end
