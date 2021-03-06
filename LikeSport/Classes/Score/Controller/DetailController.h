//
//  DetailController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/18.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
#import "KSBasketballBase.h"

@interface DetailController : BaseViewController
@property (nonatomic, assign) NSInteger matchID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) BasketResult *basketResult;

@end
