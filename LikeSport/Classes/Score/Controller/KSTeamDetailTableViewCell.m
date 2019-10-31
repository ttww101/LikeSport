//
//  KSTeamDetailTableViewCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 2017/4/8.
//  Copyright © 2017年 swordfish. All rights reserved.
//

#import "KSTeamDetailTableViewCell.h"

@implementation KSTeamDetailTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titlelabel=[[UIButton alloc]init];
        self.titlelabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titlelabel.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [self.titlelabel setTitleColor:KSBlue forState:UIControlStateNormal];
        [self.titlelabel addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titlelabel];
        [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        self.lolview=[[UIView alloc]init];
        //[self.lolview setBackgroundColor:[UIColor yellowColor]];
      // [[UIApplication sharedApplication].keyWindow addSubview:self.lolview];
      //  [self.contentView addSubview:self.lolview];
       // [self.contentView bringSubviewToFront:self.lolview];
    }
    return self;
}
-(void)push:(UIButton*)sender{
    
    if (self.pushAction) {
        
        self.pushAction();
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titlelabel.frame=CGRectMake(0,2.0f,self.frame.size.width, 26);
    self.lolview.frame=CGRectMake(0,self.frame.size.height-2.0f, self.frame.size.width, 2.0f) ;
    self.lolview.transform=CGAffineTransformMakeTranslation(0, 1.25f);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
