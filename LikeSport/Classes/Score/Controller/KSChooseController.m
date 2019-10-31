//
//  KSChooseController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/31.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSChooseController.h"
#import "KSKuaiShouTool.h"

#import "Pinyin.h"
#import "ChineseString.h"
#import "ChooseCell.h"
@interface KSChooseController () <UITableViewDelegate,UITableViewDataSource,ChooseCellDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, weak) UIButton *allBtn;
@property (nonatomic, weak) UIButton *notBtn;
@property (nonatomic, weak) UIButton *overBtn;
@property (nonatomic, weak) UILabel *selectLabel;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *indexList;
@property (nonatomic, strong) NSMutableArray<Matchtypes *> *matchTypes;
@property (nonatomic, strong) NSMutableArray<Matchtypes *> *regions;
@property (nonatomic, strong) NSMutableArray *allData;


@property (nonatomic, strong) NSMutableArray *selectIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectPath;

@property (weak, nonatomic) UILabel *label;

@end

@implementation KSChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSegmentedControl];
    
    [self setUpNavigationTitleCenter];
    
    //    [self setUpBottomView];
    [self.view addSubview:self.bottomView];
    
    [self setSaveBtn];
    
    // Do any additional setup after loading the view from its nib.

    [self setupTableView];
    
    [self setUpData];
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setUpData];
}
- (void)setUpData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    
    [KSKuaiShouTool getChooseType:_type withMDay:_MDay withCompleted:^(id result) {
        KSChoose *choose = [KSChoose mj_objectWithKeyValues:result];
        
        _matchTypes = [choose.result.matchtypes mutableCopy];
        _regions = [choose.result.regions mutableCopy];
                

        [self setChooseCheck];

        [self sortArray:_matchTypes];

        
        [hud hideAnimated:YES];
        //程序结束
        [self.tableView reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [self networdError];
    }];
}

#pragma mark -- 网络出错
-(void)networdError {
    if (_allData.count > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:1] animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.f];
        hud.label.numberOfLines = 3;
        hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
    } else {
        self.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        self.label.hidden = NO;
    }
}



- (void)setChooseCheck {
    for (Matchtypes *match in _chooseArray) {
        for (Matchtypes *mat in _matchTypes) {
            if (match.rid == mat.rid) {
                mat.isSelect = YES;
            }
        }
        for (Matchtypes *matc in _regions) {
            if (match.region_id == matc.rid) {
                matc.isSelect = YES;
            }
        }
    }

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (Matchtypes *match in _matchTypes) {
        if (match.isSelect) {
            [array addObject:match];
        }
    }
        self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[array count],(unsigned long)_matchTypes.count];

}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)sortArray:(NSMutableArray<Matchtypes *> *)array {
    _indexList = [NSMutableArray arrayWithCapacity:26];
    _allData = [NSMutableArray arrayWithCapacity:26];

    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        Matchtypes *chineseString= array[i];
        
        if(chineseString.name==nil){
            chineseString.name=@"";
        }
        
        if(![chineseString.name isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.name.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.name characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    //Step3输出
    NSMutableArray *currentArr = [NSMutableArray array];

    for(int i=0;i<[chineseStringsArray count];i++){
        Matchtypes *chineseString=[chineseStringsArray objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%c",[chineseString.pinYin characterAtIndex:0]];
        if (![_indexList containsObject:string]) {
            [_indexList addObject:string];
            currentArr = [NSMutableArray array];
            [currentArr addObject:chineseString];
            [_allData addObject:currentArr];
        } else {
            [currentArr addObject:chineseString];
        }
//        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.name,chineseString.pinYin);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];

    });
}



- (void)setSaveBtn {
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didClickedSave) forControlEvents:UIControlEventTouchUpInside];
    //    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = mailbutton;
}

- (void)setupTableView {

    dispatch_async(dispatch_get_main_queue(), ^{

        [self.tableView reloadData];
    });
}

- (void)setUpBottomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,kSceenHeight - 104, kSceenWidth, 40)];
    view.backgroundColor = KSBlue;
    
    
    [self.view addSubview:view];
}

- (void)didClickedSave {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];

    for (Matchtypes *match in _matchTypes) {
        if (match.isSelect) {
            [array addObject:match];
        }
    }
    
    NSInteger allCount = 0;
    for (int i = 0; i < _allData.count; i++) {
        allCount += [_allData[i] count];
    }
    if (_selectIndexPaths.count == allCount) {
        _chooseType = 0;
    }
    
    if (self.chooseBlock) {
        self.chooseBlock(array);
    }
    
    if (array.count != _matchTypes.count && array.count != 0) {
        NSInteger count = _matchTypes.count-array.count;
        NSString *cou;
        if (count>99) {
            
            cou = @"99+";
            
        } else if (count != 0){
            cou = [NSString stringWithFormat:@"%li",(long)count];
        } else if (count == 0){
            cou = @"0";
        }
        if ([self.delegate respondsToSelector:@selector(chooseArray:chooseType:type:residueCount:)]) {
            [self.delegate chooseArray:array chooseType:1 type:_type residueCount:cou];
        }
    } else if (array.count == _matchTypes.count) {
        if ([self.delegate respondsToSelector:@selector(chooseArray:chooseType:type:residueCount:)]) { // 全选的话不记录
            [self.delegate chooseArray:array chooseType:0 type:_type residueCount:0];
        }
    }
    if (array.count==0) {
        if ([self.delegate respondsToSelector:@selector(chooseArray:chooseType:type:residueCount:)]) {
            [self.delegate chooseArray:array chooseType:0 type:_type residueCount:@""];
        }
  
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSegmentedControl
{
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedStringFromTable(@"Match", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Country", @"InfoPlist", nil),nil];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedStringFromTable(@"Match", @"InfoPlist", nil), nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    //    segmentedControl.frame = CGRectMake(10, (kSceenWidth-90)/2, 90, 30.0);
    
    //设置按下按钮时的颜色
    segmentedControl.tintColor = [UIColor whiteColor];
    
//    if (_chooseType == 2){
//        segmentedControl.selectedSegmentIndex = 1;//默认选中的按钮索引
////        _chooseType = 2;
//    } else {
        segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
//        _chooseType = 1;
//    }
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(dosomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
}

- (void)dosomethingInSegment:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;

    switch (index) {
        case 0:
            [self sortArray:_matchTypes];
//                _selectPath = nil;
            _selectIndexPaths = nil;
//            if (_isMatch != 1) {
//                [self chooseAll];
//            } else {
//                [self setChooseCheck];
//            }
//                self.selectLabel.text = @"已选:0";
            _chooseType = 1;
            [self.tableView reloadData];
            break;
            

        case 1:
            [self sortArray:_regions];
//                _selectPath = nil;
            _selectIndexPaths = nil;
//            if (_isMatch != 2) {
//                [self chooseAll];
//            } else {
//                [self setChooseCheck];
//            }
//                self.selectLabel.text = @"已选:0";
            _chooseType = 2;
            [self.tableView reloadData];
            break;

        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark tableView索引代理

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexList;
    
}

//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
//    NSLog(@"===%@  ===%ld",title,(long)index);
    
    //点击索引，列表跳转到对应索引的行
    
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    [self showLetter:title ];
    
    return index;
    
}

- (void)showLetter:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.font = [UIFont systemFontOfSize:30];
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    hud.userInteractionEnabled = NO;

    [hud hideAnimated:YES afterDelay:1.f];
}



#pragma mark tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 70;
//    }
    return 20;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == _indexList.count - 1) {
//        return 50;
//    }
    return 0.01;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 20)];
    label.frame = CGRectMake(10, 0, kSceenWidth-10, 20);
    
    
    label.text = _indexList[section];
    [view addSubview:label];
    return view;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _allData[section];
    return array.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCell *cell = [ChooseCell cellWithTableView:tableView];
    Matchtypes *match = _allData[indexPath.section][indexPath.row];
    
    if (_chooseType == 2) {
        match.isMatch = YES;
        cell.followBtn.hidden = YES;
    } else {
        cell.followBtn.hidden = NO;
    }
    
    cell.delegate = self;
    
    cell.match = match;
    return cell;
    
}

- (void)check {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark 关注联赛
- (void)followMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    Matchtypes *match = _allData[indexPath.section][indexPath.row];
//    NSLog(@"赛事类型%@  type%li id%li",liveF.live.matchtypefullname,(long)_type,(long)liveF.live.match_id);
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];//根据键值取出token
    
    if (token.length > 0) {
        
        NSInteger state = 0;
        if (match.is_follow == 0) {
            state = 1;
        } else if (match.is_follow == 1){
            state = 2;
        }
        NSDictionary *param = @{@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"ptype":@3,@"mid":[NSString stringWithFormat:@"%li",(long)match.rid],@"status":[NSString stringWithFormat:@"%li",(long)state]};
        [KSKuaiShouTool followMatchWithParam:param withCompleted:^(id result) {
            if ([result objectForKey:@"ret_code"] == 0) {
                if (match.is_follow == 0) {
                    match.is_follow = 1;
                } else if (match.is_follow == 1){
                    match.is_follow = 0;
                }
            } else {
                if (match.is_follow == 0) {
                    match.is_follow = 1;
                } else if (match.is_follow == 1){
                    match.is_follow = 0;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

        } failure:^(NSError *error) {
            
        }];

    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedStringFromTable(@"Please login first", @"InfoPlist", nil);
        [hud hideAnimated:YES afterDelay:1.f];
        [self.tableView reloadData];

    }
    //    [_dataSource mutableCopy];
    
}


// 选中筛选
- (void)chooseMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if ([self.selectIndexPaths containsObject:indexPath]) {
        [self.selectIndexPaths removeObject:indexPath];
    } else {
        [self.selectIndexPaths addObject:indexPath];
    }

    Matchtypes *match = _allData[indexPath.section][indexPath.row];
    match.isSelect = !match.isSelect;
    if (match.region_id == 0) { // 选中的是国家
        for (Matchtypes *mat in _matchTypes) {
            if (match.rid == mat.region_id) {
 
                mat.isSelect = match.isSelect;
            }
        }
    } else { // 选中的是联赛
        for (Matchtypes *mat in _regions) {
            if (match.region_id == mat.rid) {
           
                mat.isSelect = match.isSelect;
                BOOL isSelect = NO;
                for (Matchtypes *matc in _matchTypes) {
                    if (matc.region_id == mat.rid && matc.isSelect) {
                        isSelect = YES;
                    }
                }
                if (!isSelect) {
                    mat.isSelect = NO;
                }else {
                    mat.isSelect = YES;
                }
                
            }
        }
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self getSelectCount],(unsigned long)_matchTypes.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.selectIndexPaths containsObject:indexPath]) {
        
        [self.selectIndexPaths removeObject:indexPath];
        
    } else {
        
        [self.selectIndexPaths addObject:indexPath];
    }

    Matchtypes *match = _allData[indexPath.section][indexPath.row];
    match.isSelect = !match.isSelect;
    if (match.region_id == 0) { // 选中的是国家
        for (Matchtypes *mat in _matchTypes) {
            if (match.rid == mat.region_id) {
                mat.isSelect = match.isSelect;
            }
        }
    } else { // 选中的是联赛
        for (Matchtypes *mat in _regions) {
            if (match.region_id == mat.rid) {

                mat.isSelect = match.isSelect;
                BOOL isSelect = NO;
                for (Matchtypes *matc in _matchTypes) {
                    if (matc.region_id == mat.rid && matc.isSelect) {
                        isSelect = YES;
                    }
                }
                if (!isSelect) {
                    mat.isSelect = NO;
                }else {
                    mat.isSelect = YES;
                }
                
            }
        }
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self getSelectCount],(unsigned long)_matchTypes.count];


}

// 设置导航条头居中，返回按钮中的文字不显示
- (void)setUpNavigationTitleCenter
{
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }
}

- (UIButton *)allBtn {
    if (!_allBtn) {
        UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
        [allBtn setTitle:NSLocalizedStringFromTable(@"All", @"InfoPlist", nil) forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [allBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [allBtn.layer setCornerRadius:12];
        [allBtn.layer setBorderWidth:2];//设置边界的宽度
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){255,255,255,1});
        [allBtn.layer setBorderColor:color];
        [allBtn addTarget:self action:@selector(didClickAllBtn) forControlEvents:UIControlEventTouchUpInside];
        _allBtn = allBtn;
        [self.bottomView addSubview:_allBtn];

    }
    return _allBtn;
}

- (void)didClickAllBtn {
    for (int i = 0; i < _allData.count; i++) {
        NSArray *array = _allData[i];
        for (int j = 0; j < array.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if (![self.selectIndexPaths containsObject:indexPath]) {
                [self.selectIndexPaths addObject:indexPath];
            }
        }
    }
    
    for (Matchtypes *mat in _matchTypes) {
        mat.isSelect = YES;
    }
    for (Matchtypes *mat in _regions) {
        mat.isSelect = YES;
    }
    
//    _chooseType = 0;
    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self getSelectCount],(unsigned long)_matchTypes.count];
    
    
    [self.tableView reloadData];
}

- (void)chooseAll {
    for (int i = 0; i < _allData.count; i++) {
        NSArray *array = _allData[i];
        for (int j = 0; j < array.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if (![self.selectIndexPaths containsObject:indexPath]) {
                [self.selectIndexPaths addObject:indexPath];
            }
        }
    }

    
    
    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self getSelectCount],(unsigned long)_matchTypes.count];


    [self.tableView reloadData];
}

//
- (void)chooseSomeWithArray:(NSArray *)choose {
    for (int i = 0; i < _allData.count; i++) {
        NSArray *allArray = _allData[i];
        for (int j = 0; j < allArray.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//            Matchtypes *all = _allData[i];
//            Matchtypes *cho = choose[i];
            if (![self.selectIndexPaths containsObject:indexPath] ) {
                [self.selectIndexPaths addObject:indexPath];
            }
        }
    }
//    self.selectLabel.text = [NSString stringWithFormat:@"已选:%lu",(unsigned long)[self.selectIndexPaths count]];
    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self.selectIndexPaths count]];

    
    [self.tableView reloadData];
}

- (UIButton *)overBtn {
    if (!_overBtn) {
        UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 70, 30)];
        [overBtn setTitle:NSLocalizedStringFromTable(@"Against", @"InfoPlist", nil) forState:UIControlStateNormal];
        overBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [overBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [overBtn.layer setCornerRadius:12];
        [overBtn.layer setBorderWidth:2];//设置边界的宽度
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){255,255,255,1});        [overBtn.layer setBorderColor:color];
        [overBtn addTarget:self action:@selector(chooseOver) forControlEvents:UIControlEventTouchUpInside];
        _overBtn = overBtn;
        [self.bottomView addSubview:_overBtn];

    }
    return _overBtn;
}

- (void)chooseOver {

    for (int i = 0; i < _allData.count; i++) {
        NSArray *array = _allData[i];
        for (int j = 0; j < array.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([self.selectIndexPaths containsObject:indexPath]) {
                [self.selectIndexPaths removeObject:indexPath];
            } else {
                [self.selectIndexPaths addObject:indexPath];
            }
        }
    }

    for (Matchtypes *mat in _matchTypes) {
        mat.isSelect = !mat.isSelect;
    }
    for (Matchtypes *mat in _regions) {
        mat.isSelect = !mat.isSelect;
    }
    
    self.selectLabel.text = [NSString stringWithFormat:@"%@:%lu/%lu",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil),(unsigned long)[self getSelectCount],(unsigned long)_matchTypes.count];

    [self.tableView reloadData];
}

- (NSInteger)getSelectCount {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (Matchtypes *match in _matchTypes) {
        if (match.isSelect) {
            [array addObject:match];
        }
    }
    return array.count;
}

- (UILabel *)selectLabel {
    if (!_selectLabel) {
        UILabel *selectLabel = [[UILabel alloc] init];
        selectLabel.frame = CGRectMake(kSceenWidth - 165, 5, 145, 30);
        selectLabel.text = [NSString stringWithFormat:@"%@:0",NSLocalizedStringFromTable(@"The selected", @"InfoPlist", nil)];
        selectLabel.textAlignment = NSTextAlignmentRight;
        selectLabel.textColor = [UIColor whiteColor];
        selectLabel.font=[UIFont systemFontOfSize:14.0f];
        _selectLabel = selectLabel;
        [self.bottomView addSubview:_selectLabel];
    }
    return _selectLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, kSceenHeight - 104, kSceenWidth, 40);
        bottomView.backgroundColor = KSBlue;
        
        [bottomView addSubview:self.allBtn];
        
        [bottomView addSubview:self.notBtn];
        
        [bottomView addSubview:self.overBtn];
        
        [bottomView addSubview:self.selectLabel];
        
        _bottomView = bottomView;
    }
    return _bottomView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-105) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 20;
        tableView.showsVerticalScrollIndicator = YES;
        
        tableView.sectionIndexColor = KSBlue;
        [tableView registerNib:[UINib nibWithNibName:@"ChooseCell" bundle:nil] forCellReuseIdentifier:@"chooseCell"];


        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (NSMutableArray<Matchtypes *> *)matchTypes {
    if (!_matchTypes) {
        _matchTypes = [@[] mutableCopy];
    }
    return _matchTypes;
}

- (NSMutableArray<Matchtypes *> *)regions {
    if (!_regions) {
        _regions = [@[] mutableCopy];
    }
    return _regions;
}

- (NSMutableArray *)selectIndexPaths{
    if (!_selectIndexPaths) {
        _selectIndexPaths = [@[] mutableCopy];
    }
    return _selectIndexPaths;
}

- (NSArray *)chooseArray {
    if (!_chooseArray) {
        _chooseArray = [@[] mutableCopy];
    }
    return _chooseArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

// 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kSceenWidth-220)/2 , 70, 220, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = 2;
        label.text = NSLocalizedStringFromTable(@"Temporarily no data!", @"InfoPlist", nil);
        [self.tableView addSubview:label];
        [self.view insertSubview:label atIndex:1];
        _label = label;
    }
    return _label;
}



@end
