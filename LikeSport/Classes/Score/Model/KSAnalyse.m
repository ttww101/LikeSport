//
//  KSAnalyse.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/20.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSAnalyse.h"

@implementation KSAnalyse



@end

@implementation TeamStageResult

+ (NSDictionary *)objectClassInArray{
    return @{@"teamResult" : [Pk_Data class]};
}

@end
@implementation AnalyseResult

+ (NSDictionary *)objectClassInArray{
    return @{@"h_result_data" : [Pk_Data class], @"c_fixtures_data" : [Pk_Data class], @"h_fixtures_data" : [Pk_Data class], @"c_result_data" : [Pk_Data class], @"pk_data" : [Pk_Data class],@"x_score" : [X_Score class]};
}


@end


@implementation O_H

@end




@implementation A_H

@end


@implementation I_H

@end

@implementation X_Score

@end

@implementation Score_Full

@end


@implementation N_H

@end



@implementation Pk_Data

@end


