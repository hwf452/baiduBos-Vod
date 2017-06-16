//
//  TencentVideoListViewController.m
//  edaocarios
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "TencentVideoListViewController.h"
#import "TencentVideoViewModelClass.h"



@interface TencentVideoListViewController ()

@end

@implementation TencentVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xa44dee);
    self.title=@"腾讯视频云端列表";
//    self.arryListData=[NSArray arrayWithObjects:@"视频拍摄，保存到像册，转码mp4",@"百度视频托管上传点播Vod",@"百度存储Bos",@"百度Vod播放",@"腾讯视频托管上传点播Vod", nil];
    [self setupMainViews];
    [self getTencentVideoList];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMainViews{
    self.tableView = ({
        UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [aTableView registerClass:[TencentVideoListCell class] forCellReuseIdentifier:KTencentVideoListCell];
        
        
        
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
    
    
    TencentVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:KTencentVideoListCell forIndexPath:indexPath];
    
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
    [self getTencentVideoAndPlayVideo:dict];
    
}

-(void)getTencentVideoList{
    [self showProgress];
    TencentVideoViewModelClass *tencentVideoViewModelClass=[[TencentVideoViewModelClass alloc] init];
    [tencentVideoViewModelClass setBlockWithReturnBlock:^(id returnValue) {
        [self closeProgress];
        NSLog(@"returnValue:%@",returnValue);
        NSDictionary *dict=returnValue;
        _arryListData=[dict objectForKey:@"fileSet"];
        NSLog(@"%@",[_arryListData objectAtIndex:0]);
        [self.tableView reloadData];
        
        
        
    } WithErrorBlock:^(id errorCode) {
        [self closeProgress];
    } WithFailureBlock:^{
        [self closeProgress];
    }];
    
    [tencentVideoViewModelClass getTencentCouldVideoList:100 pageNo:1];

}

-(void)getTencentVideoAndPlayVideo:(NSDictionary *)dict{
    [self showProgress];
    TencentVideoViewModelClass *tencentVideoViewModelClass=[[TencentVideoViewModelClass alloc] init];
    [tencentVideoViewModelClass setBlockWithReturnBlock:^(id returnValue) {
        [self closeProgress];
        NSLog(@"returnValue:%@",returnValue);
        NSDictionary *dict=returnValue;
        NSDictionary *dict1=[dict objectForKey:@"basicInfo"];
        NSDictionary *dict2=[dict objectForKey:@"transcodeInfo"];
        NSArray *arry=[dict2 objectForKey:@"transcodeList"];
        NSDictionary *dict3=[arry objectAtIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
            play.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:[dict1 objectForKey:@"sourceVideoUrl"]]];
            [self.navigationController presentViewController:play animated:YES completion:^{
                
            }];
        });
        
        
        
    } WithErrorBlock:^(id errorCode) {
        [self closeProgress];
    } WithFailureBlock:^{
        [self closeProgress];
    }];
    
    [tencentVideoViewModelClass getTencentCouldVideo:[dict objectForKey:@"fileId"]];
    
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

@end
