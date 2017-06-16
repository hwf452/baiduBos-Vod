//
//  BaiDuVodVideoListTableViewCell.m
//  edaocarios
//
//  Created by harry on 2017/6/16.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "BaiDuVodVideoListTableViewCell.h"


@implementation BaiDuVodVideoListTableViewCell

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
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        
        imageView;
    });
    
    
    _lb_fileId = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"";
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_carLogoImageView.mas_right).offset(15);
            make.top.equalTo(_carLogoImageView).offset(5);
        }];
        
        label;
    });
    _lb_fileName = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 0;
        label.text=@"";
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_carLogoImageView.mas_right).offset(15);
            make.top.equalTo(_lb_fileId.mas_bottom).offset(15);
        }];
        
        label;
    });
    
    
}




//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1{
    
    NSDictionary *dict=(NSDictionary *)cellModel;
    NSDictionary *dict1=[dict objectForKey:@"attributes"];
    NSArray *arryThumbnailList=[dict objectForKey:@"thumbnailList"];
    
    _lb_fileId.text=[dict objectForKey:@"mediaId"];
    _lb_fileName.text=[dict1 objectForKey:@"title"];
    [_carLogoImageView sd_setImageWithURL:[NSURL URLWithString:[arryThumbnailList objectAtIndex:0]]];
    
}




@end
