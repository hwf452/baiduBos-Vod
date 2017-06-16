//
//  MainTableViewCell.m
//  edaocarios
//
//  Created by harry on 2017/5/10.
//  Copyright © 2017年 edao. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

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
    _lb_title = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor =UIColorFromRGB(0x222222);
        label.numberOfLines = 1;
        label.text=@"";
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        
        label;
    });

}

//加载数据
-(void)loadContent:(NSObject *)cellModel index:(NSInteger)index1{
    
    NSString *strTitle=(NSString *)cellModel;
    self.lb_title.text=strTitle;
    
}

@end
