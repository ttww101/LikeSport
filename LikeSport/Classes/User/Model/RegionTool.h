//
//  RegionTool.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/27.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionTool : NSObject

+ (RegionTool *)manager;

- (NSArray *)getRegionWithParent:(NSInteger)parent;

- (NSArray *)getParent;

@end
