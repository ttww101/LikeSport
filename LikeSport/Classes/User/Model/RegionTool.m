//
//  RegionTool.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/27.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "RegionTool.h"
#import "Region.h"

@implementation RegionTool

+ (RegionTool *)manager
{
    static RegionTool * manager = nil;
    if (manager == nil)
    {
        manager = [[RegionTool alloc]init];
    }
    return manager;
}

- (NSArray *)getParent {
    NSMutableArray *parentArray = [[NSMutableArray alloc] init];
    [parentArray addObject:[self regionWithReionID:5 withParent:0 withSingCode:@"EU"]];
    [parentArray addObject:[self regionWithReionID:6 withParent:0 withSingCode:@"AS"]];
    [parentArray addObject:[self regionWithReionID:7 withParent:0 withSingCode:@"AF"]];
    [parentArray addObject:[self regionWithReionID:8 withParent:0 withSingCode:@"OA"]];
    [parentArray addObject:[self regionWithReionID:9 withParent:0 withSingCode:@"NA"]];
    [parentArray addObject:[self regionWithReionID:10 withParent:0 withSingCode:@"SA"]];

    return parentArray;
}

- (NSArray *)getRegionWithParent:(NSInteger)parent {
    NSMutableArray *regionArray = [[NSMutableArray alloc] init];
    switch (parent) {
        case 5:
            [regionArray addObject:[self regionWithReionID:109 withParent:5 withSingCode:@"ALB"]];
            [regionArray addObject:[self regionWithReionID:110 withParent:5 withSingCode:@"AND"]];
            [regionArray addObject:[self regionWithReionID:111 withParent:5 withSingCode:@"ARM"]];
            [regionArray addObject:[self regionWithReionID:112 withParent:5 withSingCode:@"AUT"]];
            [regionArray addObject:[self regionWithReionID:113 withParent:5 withSingCode:@"AZE"]];
            [regionArray addObject:[self regionWithReionID:114 withParent:5 withSingCode:@"BLR"]];
            [regionArray addObject:[self regionWithReionID:115 withParent:5 withSingCode:@"BEL"]];
            [regionArray addObject:[self regionWithReionID:116 withParent:5 withSingCode:@"BIH"]];
            [regionArray addObject:[self regionWithReionID:117 withParent:5 withSingCode:@"BUL"]];
            [regionArray addObject:[self regionWithReionID:118 withParent:5 withSingCode:@"CRO"]];
            [regionArray addObject:[self regionWithReionID:119 withParent:5 withSingCode:@"CYP"]];
            [regionArray addObject:[self regionWithReionID:120 withParent:5 withSingCode:@"CZE"]];
            [regionArray addObject:[self regionWithReionID:121 withParent:5 withSingCode:@"DEN"]];
            [regionArray addObject:[self regionWithReionID:122 withParent:5 withSingCode:@"ENG"]];
            [regionArray addObject:[self regionWithReionID:123 withParent:5 withSingCode:@"EST"]];
            [regionArray addObject:[self regionWithReionID:124 withParent:5 withSingCode:@"FRO"]];
            [regionArray addObject:[self regionWithReionID:125 withParent:5 withSingCode:@"FIN"]];
            [regionArray addObject:[self regionWithReionID:126 withParent:5 withSingCode:@"FRA"]];
            [regionArray addObject:[self regionWithReionID:127 withParent:5 withSingCode:@"GEO"]];
            [regionArray addObject:[self regionWithReionID:128 withParent:5 withSingCode:@"GER"]];
            [regionArray addObject:[self regionWithReionID:129 withParent:5 withSingCode:@"GRE"]];
            [regionArray addObject:[self regionWithReionID:233 withParent:5 withSingCode:@"GIB"]];
            [regionArray addObject:[self regionWithReionID:130 withParent:5 withSingCode:@"HUN"]];
            [regionArray addObject:[self regionWithReionID:131 withParent:5 withSingCode:@"ISL"]];
            [regionArray addObject:[self regionWithReionID:132 withParent:5 withSingCode:@"IRL"]];
            [regionArray addObject:[self regionWithReionID:133 withParent:5 withSingCode:@"ISR"]];
            [regionArray addObject:[self regionWithReionID:134 withParent:5 withSingCode:@"ITA"]];
            [regionArray addObject:[self regionWithReionID:135 withParent:5 withSingCode:@"KAZ"]];
            [regionArray addObject:[self regionWithReionID:247 withParent:5 withSingCode:@"YK"]];
            [regionArray addObject:[self regionWithReionID:136 withParent:5 withSingCode:@"LVA"]];
            [regionArray addObject:[self regionWithReionID:137 withParent:5 withSingCode:@"LIE"]];
            [regionArray addObject:[self regionWithReionID:138 withParent:5 withSingCode:@"LTU"]];
            [regionArray addObject:[self regionWithReionID:139 withParent:5 withSingCode:@"LUX"]];
            [regionArray addObject:[self regionWithReionID:140 withParent:5 withSingCode:@"MKD"]];
            [regionArray addObject:[self regionWithReionID:141 withParent:5 withSingCode:@"MLT"]];
            [regionArray addObject:[self regionWithReionID:142 withParent:5 withSingCode:@"MDA"]];
            [regionArray addObject:[self regionWithReionID:226 withParent:5 withSingCode:@"MON"]];
            [regionArray addObject:[self regionWithReionID:143 withParent:5 withSingCode:@"NED"]];
            [regionArray addObject:[self regionWithReionID:144 withParent:5 withSingCode:@"NIR"]];
            [regionArray addObject:[self regionWithReionID:145 withParent:5 withSingCode:@"NOR"]];
            [regionArray addObject:[self regionWithReionID:146 withParent:5 withSingCode:@"POL"]];
            [regionArray addObject:[self regionWithReionID:148 withParent:5 withSingCode:@"ROM"]];
            [regionArray addObject:[self regionWithReionID:147 withParent:5 withSingCode:@"POR"]];
            [regionArray addObject:[self regionWithReionID:149 withParent:5 withSingCode:@"RUS"]];
            [regionArray addObject:[self regionWithReionID:150 withParent:5 withSingCode:@"SMR"]];
            [regionArray addObject:[self regionWithReionID:151 withParent:5 withSingCode:@"SCO"]];
            [regionArray addObject:[self regionWithReionID:152 withParent:5 withSingCode:@"SRB"]];
            [regionArray addObject:[self regionWithReionID:153 withParent:5 withSingCode:@"SVK"]];
            [regionArray addObject:[self regionWithReionID:154 withParent:5 withSingCode:@"SVN"]];
            [regionArray addObject:[self regionWithReionID:155 withParent:5 withSingCode:@"ESP"]];
            [regionArray addObject:[self regionWithReionID:156 withParent:5 withSingCode:@"SWE"]];
            [regionArray addObject:[self regionWithReionID:157 withParent:5 withSingCode:@"SUI"]];
            [regionArray addObject:[self regionWithReionID:158 withParent:5 withSingCode:@"TUR"]];
            [regionArray addObject:[self regionWithReionID:159 withParent:5 withSingCode:@"UKR"]];
            [regionArray addObject:[self regionWithReionID:160 withParent:5 withSingCode:@"WAL"]];

            return regionArray;
            break;
            
        case 6:
 
            [regionArray addObject:[self regionWithReionID:12 withParent:6 withSingCode:@"AFG"]];
            [regionArray addObject:[self regionWithReionID:163 withParent:6 withSingCode:@"AUS"]];
            [regionArray addObject:[self regionWithReionID:13 withParent:6 withSingCode:@"BHR"]];
            [regionArray addObject:[self regionWithReionID:14 withParent:6 withSingCode:@"BAN"]];
            [regionArray addObject:[self regionWithReionID:15 withParent:6 withSingCode:@"BHU"]];
            [regionArray addObject:[self regionWithReionID:16 withParent:6 withSingCode:@"BRU"]];
            [regionArray addObject:[self regionWithReionID:17 withParent:6 withSingCode:@"CAM"]];
            [regionArray addObject:[self regionWithReionID:18 withParent:6 withSingCode:@"CHN"]];
            [regionArray addObject:[self regionWithReionID:20 withParent:6 withSingCode:@"GUM"]];
            [regionArray addObject:[self regionWithReionID:222 withParent:6 withSingCode:@"hk"]];
            [regionArray addObject:[self regionWithReionID:22 withParent:6 withSingCode:@"IND"]];
            [regionArray addObject:[self regionWithReionID:23 withParent:6 withSingCode:@"IDN"]];
            [regionArray addObject:[self regionWithReionID:24 withParent:6 withSingCode:@"IRN"]];
            [regionArray addObject:[self regionWithReionID:25 withParent:6 withSingCode:@"IRQ"]];
            [regionArray addObject:[self regionWithReionID:26 withParent:6 withSingCode:@"JPN"]];
            [regionArray addObject:[self regionWithReionID:27 withParent:6 withSingCode:@"JOR"]];
            [regionArray addObject:[self regionWithReionID:28 withParent:6 withSingCode:@"PRK"]];
            [regionArray addObject:[self regionWithReionID:29 withParent:6 withSingCode:@"KOR"]];
            [regionArray addObject:[self regionWithReionID:30 withParent:6 withSingCode:@"KUW"]];
            [regionArray addObject:[self regionWithReionID:31 withParent:6 withSingCode:@"KGZ"]];
            [regionArray addObject:[self regionWithReionID:32 withParent:6 withSingCode:@"LAO"]];
            [regionArray addObject:[self regionWithReionID:33 withParent:6 withSingCode:@"LIB"]];
            [regionArray addObject:[self regionWithReionID:35 withParent:6 withSingCode:@"MAS"]];
            [regionArray addObject:[self regionWithReionID:36 withParent:6 withSingCode:@"MDV"]];
            [regionArray addObject:[self regionWithReionID:37 withParent:6 withSingCode:@"MGL"]];
            [regionArray addObject:[self regionWithReionID:38 withParent:6 withSingCode:@"MYA"]];
            [regionArray addObject:[self regionWithReionID:223 withParent:6 withSingCode:@"MAC"]];
            [regionArray addObject:[self regionWithReionID:39 withParent:6 withSingCode:@"NEP"]];
            [regionArray addObject:[self regionWithReionID:40 withParent:6 withSingCode:@"OMA"]];
            [regionArray addObject:[self regionWithReionID:41 withParent:6 withSingCode:@"PAK"]];
            [regionArray addObject:[self regionWithReionID:42 withParent:6 withSingCode:@"PAL"]];
            [regionArray addObject:[self regionWithReionID:43 withParent:6 withSingCode:@"PHI"]];
            [regionArray addObject:[self regionWithReionID:44 withParent:6 withSingCode:@"QAT"]];
            [regionArray addObject:[self regionWithReionID:45 withParent:6 withSingCode:@"KSA"]];
            [regionArray addObject:[self regionWithReionID:46 withParent:6 withSingCode:@"SIN"]];
            [regionArray addObject:[self regionWithReionID:47 withParent:6 withSingCode:@"SRI"]];
            [regionArray addObject:[self regionWithReionID:48 withParent:6 withSingCode:@"SYR"]];
            [regionArray addObject:[self regionWithReionID:49 withParent:6 withSingCode:@"TJK"]];
            [regionArray addObject:[self regionWithReionID:50 withParent:6 withSingCode:@"THA"]];
            [regionArray addObject:[self regionWithReionID:51 withParent:6 withSingCode:@"TKM"]];
            [regionArray addObject:[self regionWithReionID:225 withParent:6 withSingCode:@"TKS"]];
            [regionArray addObject:[self regionWithReionID:52 withParent:6 withSingCode:@"UAE"]];
            [regionArray addObject:[self regionWithReionID:53 withParent:6 withSingCode:@"UZB"]];
            [regionArray addObject:[self regionWithReionID:54 withParent:6 withSingCode:@"VIE"]];
            [regionArray addObject:[self regionWithReionID:55 withParent:6 withSingCode:@"YEM"]];
           
            return regionArray;
            break;
            
        case 7:
            [regionArray addObject:[self regionWithReionID:56 withParent:7 withSingCode:@"ALG"]];
            [regionArray addObject:[self regionWithReionID:57 withParent:7 withSingCode:@"ANG"]];
            [regionArray addObject:[self regionWithReionID:58 withParent:7 withSingCode:@"BEN"]];
            [regionArray addObject:[self regionWithReionID:59 withParent:7 withSingCode:@"BOT"]];
            [regionArray addObject:[self regionWithReionID:60 withParent:7 withSingCode:@"BFA"]];
            [regionArray addObject:[self regionWithReionID:61 withParent:7 withSingCode:@"BDI"]];
            [regionArray addObject:[self regionWithReionID:62 withParent:7 withSingCode:@"CMR"]];
            [regionArray addObject:[self regionWithReionID:63 withParent:7 withSingCode:@"CPV"]];
            [regionArray addObject:[self regionWithReionID:64 withParent:7 withSingCode:@"CTA"]];
            [regionArray addObject:[self regionWithReionID:66 withParent:7 withSingCode:@"CGO"]];
            [regionArray addObject:[self regionWithReionID:231 withParent:7 withSingCode:@"COM"]];
            [regionArray addObject:[self regionWithReionID:238 withParent:7 withSingCode:@"CKS"]];
            [regionArray addObject:[self regionWithReionID:67 withParent:7 withSingCode:@"COD"]];
            [regionArray addObject:[self regionWithReionID:69 withParent:7 withSingCode:@"DJI"]];
            [regionArray addObject:[self regionWithReionID:70 withParent:7 withSingCode:@"EGY"]];
            [regionArray addObject:[self regionWithReionID:71 withParent:7 withSingCode:@"EQG"]];
            [regionArray addObject:[self regionWithReionID:71 withParent:7 withSingCode:@"ERI"]];
            [regionArray addObject:[self regionWithReionID:74 withParent:7 withSingCode:@"GAB"]];
            [regionArray addObject:[self regionWithReionID:75 withParent:7 withSingCode:@"GAM"]];
            [regionArray addObject:[self regionWithReionID:76 withParent:7 withSingCode:@"GHA"]];
            [regionArray addObject:[self regionWithReionID:77 withParent:7 withSingCode:@"GUI"]];
            [regionArray addObject:[self regionWithReionID:78 withParent:7 withSingCode:@"GNB"]];
            [regionArray addObject:[self regionWithReionID:79 withParent:7 withSingCode:@"KEN"]];
            [regionArray addObject:[self regionWithReionID:80 withParent:7 withSingCode:@"LES"]];
            [regionArray addObject:[self regionWithReionID:81 withParent:7 withSingCode:@"LBR"]];
            [regionArray addObject:[self regionWithReionID:82 withParent:7 withSingCode:@"LBY"]];
            [regionArray addObject:[self regionWithReionID:84 withParent:7 withSingCode:@"MWI"]];
            [regionArray addObject:[self regionWithReionID:85 withParent:7 withSingCode:@"MLI"]];
            [regionArray addObject:[self regionWithReionID:86 withParent:7 withSingCode:@"MTN"]];
            [regionArray addObject:[self regionWithReionID:87 withParent:7 withSingCode:@"MRI"]];
            [regionArray addObject:[self regionWithReionID:88 withParent:7 withSingCode:@"MAR"]];
            [regionArray addObject:[self regionWithReionID:89 withParent:7 withSingCode:@"MOZ"]];
            [regionArray addObject:[self regionWithReionID:243 withParent:7 withSingCode:@"MAY"]];
            [regionArray addObject:[self regionWithReionID:90 withParent:7 withSingCode:@"NAM"]];
            [regionArray addObject:[self regionWithReionID:91 withParent:7 withSingCode:@"NIG"]];
            [regionArray addObject:[self regionWithReionID:92 withParent:7 withSingCode:@"NGA"]];
            [regionArray addObject:[self regionWithReionID:93 withParent:7 withSingCode:@"RWA"]];
            [regionArray addObject:[self regionWithReionID:237 withParent:7 withSingCode:@"REU"]];
            [regionArray addObject:[self regionWithReionID:94 withParent:7 withSingCode:@"STP"]];
            [regionArray addObject:[self regionWithReionID:95 withParent:7 withSingCode:@"SEN"]];
            [regionArray addObject:[self regionWithReionID:96 withParent:7 withSingCode:@"SEY"]];
            [regionArray addObject:[self regionWithReionID:97 withParent:7 withSingCode:@"SLE"]];
            [regionArray addObject:[self regionWithReionID:98 withParent:7 withSingCode:@"SOM"]];
            [regionArray addObject:[self regionWithReionID:99 withParent:7 withSingCode:@"RSA"]];
            [regionArray addObject:[self regionWithReionID:100 withParent:7 withSingCode:@"SUD"]];
            [regionArray addObject:[self regionWithReionID:101 withParent:7 withSingCode:@"SWZ"]];
            [regionArray addObject:[self regionWithReionID:65 withParent:7 withSingCode:@"CHA"]];
            [regionArray addObject:[self regionWithReionID:68 withParent:7 withSingCode:@"CIV"]];
            [regionArray addObject:[self regionWithReionID:73 withParent:7 withSingCode:@"ETH"]];
            [regionArray addObject:[self regionWithReionID:83 withParent:7 withSingCode:@"MAD"]];
            [regionArray addObject:[self regionWithReionID:102 withParent:7 withSingCode:@"TAN"]];
            [regionArray addObject:[self regionWithReionID:103 withParent:7 withSingCode:@"TOG"]];
            [regionArray addObject:[self regionWithReionID:104 withParent:7 withSingCode:@"TUN"]];
            [regionArray addObject:[self regionWithReionID:105 withParent:7 withSingCode:@"UGA"]];
            [regionArray addObject:[self regionWithReionID:106 withParent:7 withSingCode:@"ZAM"]];
            [regionArray addObject:[self regionWithReionID:107 withParent:7 withSingCode:@"ZIM"]];
            [regionArray addObject:[self regionWithReionID:239 withParent:7 withSingCode:@"ZNZ"]];
            return regionArray;
            break;
            
            
        case 8:
            [regionArray addObject:[self regionWithReionID:162 withParent:8 withSingCode:@"ASA"]];
            [regionArray addObject:[self regionWithReionID:164 withParent:8 withSingCode:@"COK"]];
            [regionArray addObject:[self regionWithReionID:165 withParent:8 withSingCode:@"FIJ"]];
            [regionArray addObject:[self regionWithReionID:166 withParent:8 withSingCode:@"NCL"]];
            [regionArray addObject:[self regionWithReionID:167 withParent:8 withSingCode:@"NZL"]];
            [regionArray addObject:[self regionWithReionID:236 withParent:8 withSingCode:@"MNP"]];
            [regionArray addObject:[self regionWithReionID:168 withParent:8 withSingCode:@"PNG"]];
            [regionArray addObject:[self regionWithReionID:169 withParent:8 withSingCode:@"SAM"]];
            [regionArray addObject:[self regionWithReionID:170 withParent:8 withSingCode:@"SOL"]];
            [regionArray addObject:[self regionWithReionID:171 withParent:8 withSingCode:@"TAH"]];
            [regionArray addObject:[self regionWithReionID:172 withParent:8 withSingCode:@"TGA"]];
            [regionArray addObject:[self regionWithReionID:173 withParent:8 withSingCode:@"VAN"]];
            return regionArray;

            break;
            
            
        case 9:
            [regionArray addObject:[self regionWithReionID:187 withParent:9 withSingCode:@"ATG"]];
            [regionArray addObject:[self regionWithReionID:188 withParent:9 withSingCode:@"ARU"]];
            [regionArray addObject:[self regionWithReionID:186 withParent:9 withSingCode:@"AIA"]];
            [regionArray addObject:[self regionWithReionID:189 withParent:9 withSingCode:@"BAH"]];
            [regionArray addObject:[self regionWithReionID:190 withParent:9 withSingCode:@"BRB"]];
            [regionArray addObject:[self regionWithReionID:191 withParent:9 withSingCode:@"BLZ"]];
            [regionArray addObject:[self regionWithReionID:192 withParent:9 withSingCode:@"BER"]];
            [regionArray addObject:[self regionWithReionID:193 withParent:9 withSingCode:@"VGB"]];
            [regionArray addObject:[self regionWithReionID:194 withParent:9 withSingCode:@"CAN"]];
            [regionArray addObject:[self regionWithReionID:195 withParent:9 withSingCode:@"CAY"]];
            [regionArray addObject:[self regionWithReionID:196 withParent:9 withSingCode:@"CRC"]];
            [regionArray addObject:[self regionWithReionID:197 withParent:9 withSingCode:@"CUB"]];
            [regionArray addObject:[self regionWithReionID:242 withParent:9 withSingCode:@"CUR"]];
            [regionArray addObject:[self regionWithReionID:198 withParent:9 withSingCode:@"DMA"]];
            [regionArray addObject:[self regionWithReionID:199 withParent:9 withSingCode:@"DOM"]];
            [regionArray addObject:[self regionWithReionID:201 withParent:9 withSingCode:@"GRN"]];
            [regionArray addObject:[self regionWithReionID:202 withParent:9 withSingCode:@"GUA"]];
            [regionArray addObject:[self regionWithReionID:203 withParent:9 withSingCode:@"GUY"]];
            [regionArray addObject:[self regionWithReionID:227 withParent:9 withSingCode:@"GUA"]];
            [regionArray addObject:[self regionWithReionID:204 withParent:9 withSingCode:@"HAI"]];
            [regionArray addObject:[self regionWithReionID:205 withParent:9 withSingCode:@"HON"]];
            [regionArray addObject:[self regionWithReionID:206 withParent:9 withSingCode:@"JAM"]];
            [regionArray addObject:[self regionWithReionID:207 withParent:9 withSingCode:@"MEX"]];
            [regionArray addObject:[self regionWithReionID:208 withParent:9 withSingCode:@"MSR"]];
            [regionArray addObject:[self regionWithReionID:241 withParent:9 withSingCode:@"MTQ"]];
            [regionArray addObject:[self regionWithReionID:209 withParent:9 withSingCode:@"ANT"]];
            [regionArray addObject:[self regionWithReionID:210 withParent:9 withSingCode:@"NCA"]];
            [regionArray addObject:[self regionWithReionID:232 withParent:9 withSingCode:@"ANT"]];
            [regionArray addObject:[self regionWithReionID:211 withParent:9 withSingCode:@"PAN"]];
            [regionArray addObject:[self regionWithReionID:212 withParent:9 withSingCode:@"PUR"]];
            [regionArray addObject:[self regionWithReionID:200 withParent:9 withSingCode:@"SLV"]];
            [regionArray addObject:[self regionWithReionID:213 withParent:9 withSingCode:@"SKN"]];
            [regionArray addObject:[self regionWithReionID:214 withParent:9 withSingCode:@"LCA"]];
            [regionArray addObject:[self regionWithReionID:215 withParent:9 withSingCode:@"VIN"]];
            [regionArray addObject:[self regionWithReionID:216 withParent:9 withSingCode:@"SUR"]];
            [regionArray addObject:[self regionWithReionID:240 withParent:9 withSingCode:@"STM"]];
            [regionArray addObject:[self regionWithReionID:217 withParent:9 withSingCode:@"TRI"]];
            [regionArray addObject:[self regionWithReionID:218 withParent:9 withSingCode:@"TCA"]];
            [regionArray addObject:[self regionWithReionID:219 withParent:9 withSingCode:@"VIR"]];
            [regionArray addObject:[self regionWithReionID:220 withParent:9 withSingCode:@"USA"]];
            [regionArray addObject:[self regionWithReionID:245 withParent:9 withSingCode:@"UEC"]];
            [regionArray addObject:[self regionWithReionID:246 withParent:9 withSingCode:@"UWC"]];
            return regionArray;
            break;
            
            
        case 10:
            [regionArray addObject:[self regionWithReionID:175 withParent:10 withSingCode:@"ARG"]];
            [regionArray addObject:[self regionWithReionID:176 withParent:10 withSingCode:@"BOL"]];
            [regionArray addObject:[self regionWithReionID:177 withParent:10 withSingCode:@"BRA"]];
            [regionArray addObject:[self regionWithReionID:178 withParent:10 withSingCode:@"CHI"]];
            [regionArray addObject:[self regionWithReionID:179 withParent:10 withSingCode:@"COL"]];
            [regionArray addObject:[self regionWithReionID:180 withParent:10 withSingCode:@"ECU"]];
            [regionArray addObject:[self regionWithReionID:181 withParent:10 withSingCode:@"PAR"]];
            [regionArray addObject:[self regionWithReionID:182 withParent:10 withSingCode:@"PER"]];
            [regionArray addObject:[self regionWithReionID:183 withParent:10 withSingCode:@"URU"]];
            [regionArray addObject:[self regionWithReionID:184 withParent:10 withSingCode:@"VEN"]];
            return regionArray;
            break;
            
        default:
            break;
    }
    return nil;
}

- (Region *)regionWithReionID:(NSInteger)regionID withParent:(NSInteger)parent withSingCode:(NSString *)singCode {
    Region *region = [[Region alloc] init];
    region.region_id = regionID;
    region.parent = parent;
    region.sing_code = singCode;
    region.country = [[NSBundle mainBundle] localizedStringForKey:singCode value:nil table:@"InfoPlist"];
    return region;
}


@end
