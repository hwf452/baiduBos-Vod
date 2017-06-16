//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by edao on 15-2-27.
//  Copyright (c) 2015年 edao. All rights reserved.
//


#import "TQViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TQViewController ()

@end

@implementation TQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    isInit=YES;
    
    userDefault=[NSUserDefaults standardUserDefaults];
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    _HUD.dimBackground = NO;
    
    _HUD.labelText=@"数据处理中";
    
    //创建返回按钮
    [self createNavigationLeftButtonByPic:@"icon10yszkmx"];
    //创建标题栏
    [self initNav:@"企业指标"];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    if (isInit) {
        isInit=NO;
        
        //初始化数据
        
        [self initData1:@"2015"];
        
    }
    
    
    
}

//企业体检-企业指标-总览

-(void)initData1:(NSString *)date
{
    
    _url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[userDefault objectForKey:@"IP"],@"mbclient/financialAnalysis/getPhysicalFinancialIndicator"]];
    
    _dataRece=[[NSMutableData alloc] init];
    
    NSLog(@"%@",[_url absoluteString]);
    
    requestType=1;
    _HUD.labelText=@"数据处理中";
    
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    
    
    [_dataRece resetBytesInRange:NSMakeRange(0, [_dataRece length])];
    
    [_dataRece setLength:0];
    
    
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[userDefault objectForKey:@"enterpriseId"] forKey:@"enterpriseId"];
    [dict setObject:[userDefault objectForKey:@"date5"] forKey:@"reportYearMonth"];
    
    NSDictionary *dictt=[NSDictionary dictionaryWithDictionary:dict];
    
    
    //第二个区别点(请求为NSMutableURLRequest)
    NSURLRequest *postRequest =[self HTTPPOSTNormalRequestForURL:_url parameters:dictt];
    
    
    [NSURLConnection connectionWithRequest:postRequest delegate:self];
    
    
}

//网络请求相关，封装request获取

- (NSURLRequest *)HTTPPOSTNormalRequestForURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:NETTIMEOUT];
    NSString *HTTPBodyString = [self HTTPBodyWithParameters:parameters];
    [URLRequest setHTTPBody:[HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [URLRequest setHTTPMethod:@"POST"];
    return URLRequest;
    
}

//网络请求相关，封装post参数
-(NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    
    NSLog(@"%@",[parametersArray componentsJoinedByString:@"&"]);
    
    return [parametersArray componentsJoinedByString:@"&"];
}

//#pragma mark - URLConnection delegate
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"authenticate method:%@",protectionSpace.authenticationMethod);
    
    
    NSLog(@"mmmmmm");
    
    return [protectionSpace.authenticationMethod isEqualToString:
            NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    _challenge=challenge;
    
    
    NSURLCredential *   credential;
    
    NSURLProtectionSpace *  protectionSpace;
    SecTrustRef             trust;
    NSString *              host;
    SecCertificateRef       serverCert;
    assert(_challenge !=nil);
    protectionSpace = [_challenge protectionSpace];
    assert(protectionSpace != nil);
    
    trust = [protectionSpace serverTrust];
    assert(trust != NULL);
    
    credential = [NSURLCredential credentialForTrust:trust];
    assert(credential != nil);
    host = [[_challenge protectionSpace] host];
    if (SecTrustGetCertificateCount(trust) > 0) {
        serverCert = SecTrustGetCertificateAtIndex(trust, 0);
    } else {
        serverCert = NULL;
    }
    [[_challenge sender] useCredential:credential forAuthenticationChallenge:_challenge];
    
    
    
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    
    
    httpResponse = (NSHTTPURLResponse *) response;
    
    NSLog(@"status: %zi", httpResponse.statusCode);
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
    
    NSLog(@"%i",requestType);
    NSLog(@"data:%zi",data.length);
    [_dataRece appendData:data];
    
    
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"connect error :%@", error);
    
    
    _HUD.labelText=@"网络连接失败";
    
    [_HUD removeFromSuperview];
    
    NSString *msg=@"";
    
    if (error.code==-1004) {
        
        NSLog(@"%zi",error.code);
        
        msg=COUNTNOTCONNECTTOSERVER;
        
        
    }else{
        
        msg=NETCONNECTTIMEOUTREMINE;
        
    }
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    
    
    [alertView show];
    
    
}

//弹出框代理

- (void)willPresentAlertView:(UIAlertView *)alertView{
    
    
}

//网络请求结束后调用

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    if (requestType==1) {
        
        NSString *str=[[NSString alloc] initWithData:_dataRece encoding:NSUTF8StringEncoding];
        
        
        
        NSLog(@"%zi",_dataRece.length);
        
        NSLog(@"企业体检-企业指标-总览:--%@",str);
        
        NSLog(@"%i",requestType);
        
        
        if (httpResponse.statusCode==200) {
            
            if (_dataRece) {
                
                NSError *err = nil;
                NSArray *resultJSON = [NSJSONSerialization JSONObjectWithData:_dataRece options:kNilOptions error:&err];
                
                
                if (err==nil) {
                    
                    allDataArry=[PhysicalFinancialIndicatorDto objectArrayWithKeyValuesArray:resultJSON];
                    
                    
                   // NSLog(@"%zi",allDataArry.count);
                    
                    for (int i=0; i<allDataArry.count; i++) {
                        
                        PhysicalFinancialIndicatorDto *physicalFinancialIndicatorDto=[allDataArry objectAtIndex:i];
                        //NSLog(@"%@",physicalFinancialIndicatorDto.groupName);
                        
                        
                        
                        
                        if (i==0) {
                            
                            listFormulaIndicatorDtoArry1=physicalFinancialIndicatorDto.listFormulaIndicatorDto;
                            
                            description1=physicalFinancialIndicatorDto.description;
                            
                           // NSLog(@":::%zi",listFormulaIndicatorDtoArry1.count);
                            
                        }else if(i==1){
                            
                            listFormulaIndicatorDtoArry2=physicalFinancialIndicatorDto.listFormulaIndicatorDto;
                            
                            description2=physicalFinancialIndicatorDto.description;
                            
                           // NSLog(@"%zi",listFormulaIndicatorDtoArry2.count);
                            
                        }else if(i==2){
                            
                            listFormulaIndicatorDtoArry3=physicalFinancialIndicatorDto.listFormulaIndicatorDto;
                            
                            description3=physicalFinancialIndicatorDto.description;
                            
                           // NSLog(@"%zi",listFormulaIndicatorDtoArry3.count);
                            
                        }else if(i==3){
                            
                            listFormulaIndicatorDtoArry4=physicalFinancialIndicatorDto.listFormulaIndicatorDto;
                            
                            description4=physicalFinancialIndicatorDto.description;
                            
                           // NSLog(@"%zi",listFormulaIndicatorDtoArry4.count);
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    CGRect rect = self.view.bounds;
                    
                    rect.size.height=rect.size.height-31;
                    
                    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:rect];
                    self.mTableView.dataSource = self;
                    self.mTableView.delegate   = self;
                    self.mTableView.backgroundColor = [UIColor clearColor];
                    
                    
                    
                    [self.view addSubview:self.mTableView];
                    
                    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 31)];
                    bottomView.backgroundColor=UIColorFromRGB(0xf7f7f7);
                    
                    [self.view addSubview:bottomView];
                    
                    UIImageView *leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 13, 10)];
                    leftImageView.image=[UIImage imageNamed:@"gszb.png"];
                    [bottomView addSubview:leftImageView];
                    
                    UIImageView *rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-93, 11, 13, 10)];
                    rightImageView.image=[UIImage imageNamed:@"ckzb.png"];
                    [bottomView addSubview:rightImageView];
                    
                    UILabel *leftLb=[[UILabel alloc] initWithFrame:CGRectMake(33, 5, 60, 21)];
                    
                    leftLb.text=@"公司指标";
                    leftLb.font=[UIFont boldSystemFontOfSize:15];
                    leftLb.backgroundColor=[UIColor clearColor];
                    leftLb.textColor=UIColorFromRGB(0x009f78);
                    
                    [bottomView addSubview:leftLb];
                    
                    UILabel *rightLb=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-74, 5, 60, 21)];
                    
                    rightLb.text=@"参考指标";
                    rightLb.font=[UIFont boldSystemFontOfSize:15];
                    rightLb.backgroundColor=[UIColor clearColor];
                    rightLb.textColor=UIColorFromRGB(0xfc3d39);
                    
                    [bottomView addSubview:rightLb];

                    
                    
                    
                    
                    
                    
                    
                    
                    if ([self.openViewIndex intValue]==5) {
                        //[self.mTableView openOrCloseHeaderWithSection:[self.openViewIndex intValue]-2];
                    }else{
                        [self.mTableView openOrCloseHeaderWithSection:[self.openViewIndex intValue]-1];
                    }

                    
                    
                }
                
                
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            
            
            
            
        }else{
            NSString *msg=[NSString stringWithFormat:@"%@",GETSERVERDATAERROR];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        [_HUD removeFromSuperview];
        
        
    }
}






#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    
    PhysicalFinancialIndicatorDto *physicalFinancialIndicatorDto=[allDataArry objectAtIndex:section];
    
    return [physicalFinancialIndicatorDto.listFormulaIndicatorDto count];
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSLog(@"%zi",indexPath.section);
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"XiyezhibiaoTableViewCell" owner:self options:nil];//加载自定义
    
    
    XiyezhibiaoTableViewCell *cell = [array objectAtIndex:0];
    
    //NSLog(@"%zi",indexPath.row);
    
    if (indexPath.section==0) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry1 objectAtIndex:indexPath.row];
        
        [cell loadContentFinancialIndicatorDto:financialIndicatorDto];
        
        
    }else if (indexPath.section==1) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry2 objectAtIndex:indexPath.row];
        
        [cell loadContentFinancialIndicatorDto:financialIndicatorDto];
        
    }else if (indexPath.section==2) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry3 objectAtIndex:indexPath.row];
        
        [cell loadContentFinancialIndicatorDto:financialIndicatorDto];
        
    }else if (indexPath.section==3) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry4 objectAtIndex:indexPath.row];
        
        [cell loadContentFinancialIndicatorDto:financialIndicatorDto];
        
    }
    
    
    

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return allDataArry.count;
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    
    header.tag=section;
    
    header.layer.backgroundColor    = UIColorFromRGB(0xf7f7f7).CGColor;
    header.layer.masksToBounds      = YES;
    //header.layer.borderWidth        = 0.3;
    header.layer.borderColor        = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1].CGColor;
    
    PhysicalFinancialIndicatorDto *physicalFinancialIndicatorDto=[allDataArry objectAtIndex:section];
    
    UILabel *lbLeft=[[UILabel alloc] initWithFrame:CGRectMake(15, 14, 100, 22)];
    lbLeft.font=[UIFont boldSystemFontOfSize:16];
    lbLeft.backgroundColor=[UIColor clearColor];
    lbLeft.text=physicalFinancialIndicatorDto.groupName;
    
    [header addSubview:lbLeft];
    
    UIButton *btnYiWen=[[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    btnYiWen.tag=section;
    [btnYiWen setImage:[UIImage imageNamed:@"yiwen.png"] forState:UIControlStateNormal];
    [btnYiWen addTarget:self action:@selector(btnYiWenClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btnYiWen];
    
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-25, 20, 17, 10)];
    imageview.image=[UIImage imageNamed:@"kuozhan.png"];
    imageview.tag=section+100;
    [header addSubview:imageview];
    
    UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
    imageview1.image=[UIImage imageNamed:@"qitjmxline.png"];
    imageview1.tag=section+300;
    [header addSubview:imageview1];
    
    
    
    return header;
}

//疑问按钮的点击事件

-(void)btnYiWenClick:(UIButton *)btn{
    
    
    NSLog(@"%zi",btn.tag);
    
    NSString *strMsg=@"";
    
    if (btn.tag==0) {
        
        strMsg=[NSString stringWithFormat:@"%@%@%@",@"     ",description1,@""];
        
    }else if (btn.tag==1) {
        
        strMsg=[NSString stringWithFormat:@"%@%@%@",@"     ",description2,@""];
        
        
    }else if (btn.tag==2) {
    
        strMsg=[NSString stringWithFormat:@"%@%@%@",@"     ",description3,@""];
        
    }else if (btn.tag==3) {
        
        strMsg=[NSString stringWithFormat:@"%@%@%@",@"     ",description4,@""];
        
    }
    
    NSLog(@"%zi",[strMsg length]);
    
//    strMsg=@"        盈利能力是指企业获取利润的能力，也称为企业的资金或资本增值能力，通常表现为一定时期内企业收益数额的多少及其水平的高低。盈利能力指标主要包括营业利润率，成本费用利润率，盈余现金保障倍数，总资产报酬率，净资产收益率和资本收益率六项。实务中，上市公司经常采用每股收益，每股股利，市盈率，每股净资产等指标评价其获利能力。";
    
    BlockUIAlertView *alertview=[[BlockUIAlertView alloc] initWithTitle:nil message:strMsg cancelButtonTitle:@"确定" otherButtonTitles:nil buttonBlock:^(NSInteger index) {
        
        if (index==0) {
            
            NSLog(@"取消");
        }else if(index==1){
            NSLog(@"1");
            
            
        }
        
        
    }];

    
//    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    for(UIView *subview in alertview.subviews)
        
    {
        
        if([[subview class] isSubclassOfClass:[UILabel class]])
            
        {
            
            UILabel *label = (UILabel*)subview;
            
            label.textAlignment = UITextAlignmentLeft;
            
        }
        
    }
    
    [alertview show];

        
}

//点击进入对比详细页面

- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow ----%zi",indexPath.row);
    
    XiyezhibiaoDetailViewController *xdvc=[[XiyezhibiaoDetailViewController alloc] initWithNibName:@"XiyezhibiaoDetailViewController" bundle:nil];
    
    
    
    
    if (indexPath.section==0) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry1 objectAtIndex:indexPath.row];
        
        xdvc.indicatorKey=financialIndicatorDto.indicatorKey;
        NSLog(@"%@",financialIndicatorDto.init);
        
        
    }else if (indexPath.section==1) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry2 objectAtIndex:indexPath.row];
        
        xdvc.indicatorKey=financialIndicatorDto.indicatorKey;
        NSLog(@"%@",financialIndicatorDto.init);
        
        
    }else if (indexPath.section==2) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry3 objectAtIndex:indexPath.row];
        
        xdvc.indicatorKey=financialIndicatorDto.indicatorKey;
        NSLog(@"%@",financialIndicatorDto.init);
        
    }else if (indexPath.section==3) {
        
        FinancialIndicatorDto *financialIndicatorDto=[listFormulaIndicatorDtoArry4 objectAtIndex:indexPath.row];
        
        xdvc.indicatorKey=financialIndicatorDto.indicatorKey;
        NSLog(@"%@",financialIndicatorDto.init);
        
    }

    
    [self.navigationController pushViewController:xdvc animated:YES];
    
    
}

#pragma mark - Header Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"Open Header ----%d",section);
    
    UIView *header=[mTableView viewWithTag:section];
    UIImageView *imageview=(UIImageView *)[header viewWithTag:section+100];
    imageview.image=[UIImage imageNamed:@"shouqi.png"];
    
    
    
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"Close Header ---%d",section);
    
    UIView *header=[mTableView viewWithTag:section];
    UIImageView *imageview=(UIImageView *)[header viewWithTag:section+100];
    imageview.image=[UIImage imageNamed:@"kuozhan.png"];
    
}

#pragma mark - Row Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Open Row ----%d",indexPath.row);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Close Row ----%d",indexPath.row);
}



@end
