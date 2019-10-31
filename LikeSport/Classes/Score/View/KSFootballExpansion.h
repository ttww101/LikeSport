//
//  KSFootballExpansion.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/14.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSMore;
@class KSLive;
@interface KSFootballExpansion : UIImageView

@property (nonatomic, strong) NSArray<KSMore *> *more;
@property (nonatomic, strong) KSLive *live;


@end
