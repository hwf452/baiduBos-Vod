//
//  BaiDuMediaPlayerController.m
//  edaocarios
//
//  Created by harry on 2017/6/7.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "BaiDuMediaPlayerController.h"

@interface BaiDuMediaPlayerController ()

@end

@implementation BaiDuMediaPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"百度vod播放";
    [self setupMainViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupMainViews{
    NSLog(@"setupMainViews:%@",self.playerUrl);
//    self.player = [[BDCloudMediaPlayerController alloc] initWithContentString:self.playerUrl];
//    //[self.player reset];
//    //
//    // 将播放器的 view 添加到 self 的 view 中。
//    [self.view addSubview:self.player.view];
//    
////    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.view);
////        make.top.equalTo(self.mas_topLayoutGuideBottom);
////        make.right.equalTo(self.view);
////        make.bottom.equalTo(self.view);
////    }];
//    [self.player prepareToPlay];
//    [self.player play];
//    //self.player.shouldAutoplay = YES;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    if (self.player) {
//        //[self.player reset];
//        [self.player stop];
//        self.player=nil;
//    }
//}

@end
