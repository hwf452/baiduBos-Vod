//
//  CarSubViewController.m
//  edaocarios
//
//  Created by harry on 2017/5/11.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "CarSubViewController.h"

@interface CarSubViewController ()

@end

@implementation CarSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xa44dee);
    self.title=self.strTitle;
    
    
    [self setupMainViews];
    [self getdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getdata{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.strTitle ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"json:%@",dict);
    NSDictionary *dict1=[dict objectForKey:@"data"];
    NSArray *arry1=[dict1 objectForKey:@"series_list"];
    NSLog(@"arry1.count:%zi",arry1.count);
    NSLog(@"%@", dict);
    
    NSMutableArray *arryAll=[NSMutableArray array];
    
    for (int i=0; i<arry1.count; i++) {
        NSDictionary *dict2=[arry1 objectAtIndex:i];
        NSArray *arry2=[dict2 objectForKey:@"series_list"];
        NSLog(@"arry2.count:%zi",arry2.count);
        for (int j=0; j<arry2.count; j++) {
            NSDictionary *dict3=[arry2 objectAtIndex:j];
            [arryAll addObject:dict3];
            NSLog(@"logo:%@",[dict3 objectForKey:@"logo"]);
            
            NSArray *arry3=[dict3 objectForKey:@"model_list"];
            NSLog(@"arry3.count:%zi",arry3.count);
//            for (int k=0; k<arry3.count; k++) {
//                NSDictionary *dict4=[arry3 objectAtIndex:k];
//                NSLog(@"dict4:%@",dict4);
//            }
            
        }
        
    }
    self.arrySubCarListData=[NSArray arrayWithArray:arryAll];
    NSLog(@"count:%zi",arryAll.count);
    
    [self.tableView reloadData];

    
    
}

- (void)setupMainViews{
    self.tableView = ({
        UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [aTableView registerClass:[CarSubTableViewCell class] forCellReuseIdentifier:KCarSubTableViewCell];
        
        
        
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
    return self.arrySubCarListData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSDictionary *dictCell=[self.arrySubCarListData objectAtIndex:indexPath.section];
    
    
    CarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCarSubTableViewCell forIndexPath:indexPath];
    
    [cell loadContent:dictCell index:indexPath.section];
    
    return cell;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictCell=[self.arrySubCarListData objectAtIndex:indexPath.section];
    
    
    
    return [tableView fd_heightForCellWithIdentifier:KCarSubTableViewCell configuration:^(id cell) {
        [cell loadContent:dictCell index:indexPath.row];
    }];
    
    
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
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1) {
        
    }
}


@end
