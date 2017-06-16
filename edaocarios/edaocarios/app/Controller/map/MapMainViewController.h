//
//  MapMainViewController.h
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapMainTableViewCell.h"

@interface MapMainViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate>

@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)MAMapView *mapView;

@property(nonatomic,assign)BOOL isLocationInit;

@end
