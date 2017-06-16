//
//  CarMainTableViewCell.m
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "CarMainTableViewCell.h"

@implementation CarMainTableViewCell

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
    _carLogoImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"craft_tupian"];
        //imageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.width.height.mas_equalTo(50);
        }];
        
        imageView;
    });

    
    _lb_title = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"";
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_carLogoImageView.mas_right).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        
        label;
    });
    
}

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1{
    
    
    NSDictionary *dictCell=(NSDictionary *)cellModel;
    self.lb_title.text=[dictCell objectForKey:@"brand_name"];
//    [self.carLogoImageView sd_setImageWithURL:[NSURL URLWithString:[dictCell objectForKey:@"pic_url"]] placeholderImage:[UIImage imageNamed:@"craft_tupian"] options:SDWebImageCacheMemoryOnly];
    //SDWebImageCacheMemoryOnly
    //SDWebImageContinueInBackground
    UIImage *image=[UIImage imageNamed:[dictCell objectForKey:@"pic_url"]];
    [self.carLogoImageView setImage:image];
    
}


@end
