//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by edao on 15-2-27.
//  Copyright (c) 2015年 edao. All rights reserved.
//


#import "TQViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface TQViewController ()

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isInit=YES;
    self.title=self.strTitle;
    
    if (self.strTitle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.strTitle ofType:@"json"];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dictData=[dict objectForKey:@"data"];
        
        NSLog(@"json:%@",dict);
        self.allCarArry=[dictData objectForKey:@"series_list"];
        NSLog(@"allCarArry.count:%zi",self.allCarArry.count);
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (isInit) {
        isInit=NO;
        self.mTableView = [[TQMultistageTableView alloc] initWithFrame:self.view.bounds];
        self.mTableView.dataSource = self;
        self.mTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.delegate   = self;
        [self.view addSubview:self.mTableView];
        [self.mTableView openOrCloseHeaderWithSection:0];
    }
    
}


#pragma mark - TQTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)tableView
{
    return self.allCarArry.count;;
}

- (NSInteger)mTableView:(TQMultistageTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictSection=[self.allCarArry objectAtIndex:section];
    NSArray *arrySection=[dictSection objectForKey:@"series_list"];
    return arrySection.count;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictSection=[self.allCarArry objectAtIndex:indexPath.section];
    NSArray *arrySection=[dictSection objectForKey:@"series_list"];
    NSDictionary *dictCell=[arrySection objectAtIndex:indexPath.row];
    
    
    //static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    TQCarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTQCarSubTableViewCell];
    if (cell == nil)
    {
        cell = [[TQCarSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KTQCarSubTableViewCell];
    }
    [cell loadContent:dictCell index:indexPath.row];
    
    return cell;
}

- (UIView *)mTableView:(TQMultistageTableView *)tableView openCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictSection=[self.allCarArry objectAtIndex:indexPath.section];
    NSArray *arrySection=[dictSection objectForKey:@"series_list"];
    NSDictionary *dictCell=[arrySection objectAtIndex:indexPath.row];
    NSArray *model_list=[dictCell objectForKey:@"model_list"];
    float viewHeight=model_list.count*40;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, viewHeight)];
    view.backgroundColor = [UIColor colorWithRed:187/255.0 green:206/255.0 blue:190/255.0 alpha:1];
    for (int i=0; i<model_list.count; i++) {
        NSDictionary *dictCar=[model_list objectAtIndex:i];
        UIButton *btnCar=[[UIButton alloc] initWithFrame:CGRectMake(30, i*40, ScreenWidth-30, 40)];
        [btnCar setTitle:[dictCar objectForKey:@"model_name"] forState:UIControlStateNormal];
        [btnCar setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        btnCar.titleLabel.font=[UIFont systemFontOfSize:15];
        [btnCar setTag:i];
        btnCar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        objc_setAssociatedObject(btnCar, "firstObject",indexPath,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(btnCar, "secondObject",[dictCar objectForKey:@"model_name"],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [btnCar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnCar];
    }
    return view;
}

-(void)btnClick:(UIButton *)btn{
    NSLog(@"%zi",btn.tag);
    NSIndexPath *indexPath = objc_getAssociatedObject(btn,"firstObject");
    NSLog(@"%zi",indexPath.section);
    NSLog(@"%zi",indexPath.row);
    NSString *carTitle=objc_getAssociatedObject(btn,"secondObject");
    
    NSLog(@"%@",carTitle);
    
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dictSection=[self.allCarArry objectAtIndex:indexPath.section];
//    NSArray *arrySelect=[dictSection objectForKey:@"series_list"];
//    NSDictionary *dictCell=[arrySelect objectAtIndex:indexPath.row];
    return 80;
}

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictSection=[self.allCarArry objectAtIndex:indexPath.section];
    NSArray *arrySection=[dictSection objectForKey:@"series_list"];
    NSDictionary *dictCell=[arrySection objectAtIndex:indexPath.row];
    NSArray *model_list=[dictCell objectForKey:@"model_list"];
    
    return model_list.count*40;
}

- (UIView *)mTableView:(TQMultistageTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.layer.backgroundColor    = UIColorFromRGB(0xdddddd).CGColor;
    header.layer.masksToBounds      = YES;
    //header.layer.borderWidth        = 0.3;
    header.layer.borderColor        = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1].CGColor;
    UILabel *titleLable=[UILabel new];
    titleLable.frame=CGRectMake(15, 7, 200, 15);
    titleLable.font=[UIFont systemFontOfSize:14];
    [header addSubview:titleLable];
    NSDictionary *dict=[self.allCarArry objectAtIndex:section];
    titleLable.text=[dict objectForKey:@"channel_name"];
    
    return header;
}

- (void)mTableView:(TQMultistageTableView *)tableView didSelectHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerClick%d",section);
}

//celll点击
- (void)mTableView:(TQMultistageTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellClick%@",indexPath);
}

//header展开
- (void)mTableView:(TQMultistageTableView *)tableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerOpen%d",section);
}

//header关闭
- (void)mTableView:(TQMultistageTableView *)tableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerClose%d",section);
}

- (void)mTableView:(TQMultistageTableView *)tableView willOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"OpenCell%@",indexPath);
}

- (void)mTableView:(TQMultistageTableView *)tableView willCloseCellAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CloseCell%@",indexPath);
}

@end
