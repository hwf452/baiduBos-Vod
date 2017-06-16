//
//  CarMainViewController.m
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "CarMainViewController.h"

@interface CarMainViewController ()

@end

@implementation CarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xa44dee);
    self.title=@"汽车品牌列表";
    
    
    [self setupMainViews];
    [self showProgress];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getdata];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getdata{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"car" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"json:%@",dict);
    
    NSDictionary *dict1=[dict objectForKey:@"data"];
    NSArray *arry1=[dict1 objectForKey:@"car_brand_list"];
    NSMutableArray *arryAll=[NSMutableArray array];
    
    for (int i=0; i<arry1.count; i++) {
        NSDictionary *dict2=[arry1 objectAtIndex:i];
        NSArray *arry2=[dict2 objectForKey:@"brand_list"];
        //NSLog(@"arry2.count:%zi",arry2.count);
        for (int j=0; j<arry2.count; j++) {
            NSDictionary *dict3=[arry2 objectAtIndex:j];
            [arryAll addObject:dict3];
            //NSLog(@"pic_url:%@",[dict3 objectForKey:@"pic_url"]);
            
        }
        
    }
    self.arryListData=[NSArray arrayWithArray:arryAll];
    //NSLog(@"count:%zi",arryAll.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self closeProgress];
        [self.tableView reloadData];
    });
    
    
    

    
    //http://23.105.208.7:8080/spring5/findAllUserJson.action
    //http://youhao.api.autohello.com/car/getCarBrand
    
//    NSURL *URL = [NSURL URLWithString:@"http://youhao.api.autohello.com/car/getCarBrand"];
//    
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    // 创建同步链接
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    NSDictionary *dict1=[list objectForKey:@"data"];
//    NSArray *arry1=[dict1 objectForKey:@"car_brand_list"];
//    NSLog(@"%@", list);
//    NSMutableArray *arryAll=[NSMutableArray array];
//    
//    for (int i=0; i<arry1.count; i++) {
//        NSDictionary *dict2=[arry1 objectAtIndex:i];
//        NSArray *arry2=[dict2 objectForKey:@"brand_list"];
//        for (int j=0; j<arry2.count; j++) {
//            NSDictionary *dict3=[arry2 objectAtIndex:j];
//            [arryAll addObject:[dict3 objectForKey:@"pic_url"]];
//            NSLog(@"pic_url:%@",[dict3 objectForKey:@"pic_url"]);
//            
//        }
//        
//    }
//    self.arryListData=[NSArray arrayWithArray:arryAll];
//    NSLog(@"count:%zi",arryAll.count);
//    
    
    
    
    
    
//    NSURL *URL = [NSURL URLWithString:@"http://youhao.api.autohello.com/car/getCarBrand"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 10.0f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    //self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
//    
//    
//    [manager POST:URL.absoluteString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //NSLog(@"responseObject:%@",responseObject);
//        
//        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        
//        
//        
//        NSError *error = nil;
//        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
//        //NSLog(@"%@", list);
//        
////        NSString *home = NSHomeDirectory();//获取沙盒路径
////        NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
////        NSString *filePath = [docPath stringByAppendingPathComponent:@"car.json"];
////        [str writeToFile:filePath atomically:YES];
//        
//        
//        
//        NSDictionary *dict1=[list objectForKey:@"data"];
//        NSArray *arry1=[dict1 objectForKey:@"car_brand_list"];
//        NSMutableArray *arryAll=[NSMutableArray array];
//        
//        for (int i=0; i<arry1.count; i++) {
//            NSDictionary *dict2=[arry1 objectAtIndex:i];
//            NSArray *arry2=[dict2 objectForKey:@"brand_list"];
//            //NSLog(@"arry2.count:%zi",arry2.count);
//            for (int j=0; j<arry2.count; j++) {
//                NSDictionary *dict3=[arry2 objectAtIndex:j];
//                [arryAll addObject:dict3];
//                //NSLog(@"pic_url:%@",[dict3 objectForKey:@"pic_url"]);
//                
//            }
//            
//        }
//        self.arryListData=[NSArray arrayWithArray:arryAll];
//        //NSLog(@"count:%zi",arryAll.count);
//        
//        [self.tableView reloadData];
//        
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            NSLog(@"%@", error);
//        }
//        
//    }];
//
    
    
    
    
    
}

- (void)setupMainViews{
    self.tableView = ({
        UITableView *aTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [aTableView registerClass:[CarMainTableViewCell class] forCellReuseIdentifier:KCarMainTableViewCell];
        
        
        
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
    
    
    
    NSDictionary *dictCell=[self.arryListData objectAtIndex:indexPath.section];
    
    
    CarMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCarMainTableViewCell forIndexPath:indexPath];
    
    [cell loadContent:dictCell index:indexPath.section];
    
    return cell;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictCell=[self.arryListData objectAtIndex:indexPath.section];
    
    
    
    return [tableView fd_heightForCellWithIdentifier:KCarMainTableViewCell configuration:^(id cell) {
        [cell loadContent:dictCell index:indexPath.row];
    }];;
    
    
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
    NSDictionary *dictCell=[self.arryListData objectAtIndex:indexPath.section];
    NSString *strTitle=[dictCell objectForKey:@"brand_name"];
    
//    CarSubViewController *carSubViewController=[CarSubViewController new];
//    carSubViewController.strTitle=strTitle;
    
    
    
    TQViewController *tQViewController=[TQViewController new];
    tQViewController.strTitle=strTitle;
    
    
//    [self.navigationController pushViewController:carSubViewController animated:YES];
    [self.navigationController pushViewController:tQViewController animated:YES];
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
