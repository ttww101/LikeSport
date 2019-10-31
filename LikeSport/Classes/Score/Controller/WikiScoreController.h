//
//  WikiScoreController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/9.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
#import "Wiki.h"
#import "WikiParam.h"
@interface WikiScoreController : BaseViewController
@property (nonatomic, strong) WikiParam *wikiParam;
@property (nonatomic, strong) WikiResult *wiki;
@property (nonatomic, assign) NSInteger mtype;
@property (nonatomic, assign) NSInteger mid;


@end
