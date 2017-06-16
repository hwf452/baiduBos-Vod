//
//  TQCarSubTableViewCell.m
//  edaocarios
//
//  Created by harry on 2017/5/27.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "TQCarSubTableViewCell.h"

@implementation TQCarSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self loadSubViews];
    }
    
    return self;
}

- (void)loadSubViews {
    _carLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    
    _carLogoImageView.image = [UIImage imageNamed:@"craft_tupian"];
    [self.contentView addSubview:_carLogoImageView];
    
    _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(80, 32,ScreenWidth-100, 15)];
    _lb_title.font=[UIFont systemFontOfSize:15];
    _lb_title.numberOfLines = 0;
    _lb_title.text=@"";
    [self.contentView addSubview:_lb_title];
    _viewLine=[[UIView alloc] initWithFrame:CGRectMake(0, 79, ScreenWidth, 1)];
    _viewLine.backgroundColor=UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:_viewLine];
    
}

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1{
    
    
    NSDictionary *dictCell=(NSDictionary *)cellModel;
    self.lb_title.text=[dictCell objectForKey:@"series_name"];
    [self.carLogoImageView sd_setImageWithURL:[NSURL URLWithString:[dictCell objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"craft_tupian"] options:SDWebImageContinueInBackground];
    //SDWebImageCacheMemoryOnly
    //SDWebImageContinueInBackground
}




@end
