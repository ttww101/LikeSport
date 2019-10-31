//
//  SearchViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/1.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomTextField.h"
#import "KxMenu.h"
#import "KSKuaiShouTool.h"
#import "Search.h"
#import "SearchCell.h"

#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "BDKNotifyHUD.h"
#import "TeamDetailViewController.h"
#import "KSTeamDetailViewController.h"

#import "NSString+ZYChangeCode.h"
#import "HistoryViewCell.h"
#import "SquareLayout.h"
#import "FootballDetailController.h"


@interface SearchViewController ()<UITextFieldDelegate,IFlySpeechRecognizerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    MBProgressHUD *HUD;
//    IFlySpeechRecognizer *iFlySpeechRecognizer;
}

@property (weak, nonatomic) CustomTextField *searchBar;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

// 历史搜索
@property (nonatomic, strong) NSArray *historySource;
@property (nonatomic, assign) BOOL isHistory;


//搜索内容 如果返回的结果不是目前搜索的就不刷新
@property (nonatomic, copy) NSString *searchString;

// 讯飞语音输入按钮
@property (weak, nonatomic) UIView *iFlyView;
@property (weak, nonatomic) UIButton *iFlyBtn;

@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, strong) NSString * result;

//@property (weak, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) BDKNotifyHUD *notify;

@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) HistoryViewCell *cell;
//@property (nonatomic, strong) NSMutableArray *data;

@property (weak, nonatomic) UILabel *label;

@property (weak, nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation SearchViewController{
    UIButton *typeBtn;
}

static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarController.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setSearchBar];
    

//    [self saveArray:nil withKey:@"history"];
    _historySource = [self getArrayWithKey:@"history"];
    if ([_historySource count] > 0) {
//        _dataSource = _historySource;
        _isHistory = YES;
        [self createUICollectionView];
    }
    
    // 讯飞语音
    [self createIFly];
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.delegate = self;
//    NSLog(@"版本号=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    // 将视图置顶
//    [self bringSubviewToFront: theView];
//    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(55, 8, 15, 15)];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    //    [activityView setBackgroundColor:[UIColor lightGrayColor]];
    [self.searchBar addSubview:activityView];
    _activityView = activityView;
}


#pragma mark -- 设置搜索栏
- (void)setSearchBar {
    // 改变状态颜色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
   
    CustomTextField *searchBar = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 25, kSceenWidth-100, 30)];
    searchBar.leftIndent = 40;
    searchBar.rightIndent = 20;
    searchBar.layer.cornerRadius = 5;
    [searchBar setBorderStyle:UITextBorderStyleRoundedRect];
    searchBar.backgroundColor = KSBackgroundGray;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    if (_type == 2) {
        searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or players", @"InfoPlist", nil);
    } else {
        searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or team", @"InfoPlist", nil);
    }
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:searchBar];
    _searchBar = searchBar;
   // [searchBar becomeFirstResponder];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem  alloc]initWithCustomView:searchBar];
    typeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    typeBtn.frame = CGRectMake(0,0, 40, 30);
    [typeBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self changeTypeBtn]; // 更换类别按钮图案
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    searchBar.leftView=typeBtn;
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(36, 10, 10, 10)];
    arrow.image = [UIImage imageNamed:@"arrowDown"];
    [typeBtn addSubview:arrow];
    [_searchBar addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 50, 30)];
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];

    
   /*
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    [self.view addSubview:bar];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth - 60, 25, 50, 30)];
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil) forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancelBtn];
    
    CustomTextField *searchBar = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 25, kSceenWidth-70, 30)];
    searchBar.leftIndent = 40;
    searchBar.rightIndent = 20;
    searchBar.layer.cornerRadius = 5;
    [searchBar setBorderStyle:UITextBorderStyleRoundedRect];
    searchBar.backgroundColor = KSBackgroundGray;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    if (_type == 2) {
        searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or players", @"InfoPlist", nil);
    } else {
        searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or team", @"InfoPlist", nil);
    }
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:searchBar];
    _searchBar = searchBar;
    [searchBar becomeFirstResponder];
    
    //    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    typeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    typeBtn.frame = CGRectMake(0, 0, 40, 30);
    typeBtn.frame = CGRectMake(10, 25, 40, 30);
    
    [typeBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBar addSubview:typeBtn];
    [self changeTypeBtn]; // 更换类别按钮图案
    [self.view addSubview:typeBtn];
    //设置整个菜单块的背景颜色，如果不设置，就采用默认的背景颜色（代码中有体现）
    //        [KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:97/255.0f blue:33/255.0f alpha:1.0]];
    
    //设置所有菜单项的字体，如果不设置，就采用默认的字体（代码中有体现）
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(36, 10, 10, 10)];
    arrow.image = [UIImage imageNamed:@"arrowDown"];
    [typeBtn addSubview:arrow];
    [_searchBar addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
    */
}

- (void)cancelSearch{
    [self.navigationController popViewControllerAnimated:NO];
    //    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -- 更换类别
- (void)changeTypeBtn {
    UIImage *image;
    switch (_type) {
        case 0:
            image = [UIImage imageNamed:@"football1"];
            break;
        case 1:
            image = [UIImage imageNamed:@"basketball2"];

            break;
        case 2:
            image = [UIImage imageNamed:@"tennisball2"];

            break;
            
        default:
            break;
    }

    [typeBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    // 切换类别时更换输入框提示文字
    if (_type == 2) {
        _searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or players", @"InfoPlist", nil);
    } else {
        _searchBar.placeholder = NSLocalizedStringFromTable(@"Enter the league or team", @"InfoPlist", nil);
    }
    [_collectionView reloadData];
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedStringFromTable(@"Soccer", @"InfoPlist", nil)
                     image:[UIImage imageNamed:@"football1"]
                       tag:0
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:NSLocalizedStringFromTable(@"Basketball", @"InfoPlist", nil)
                     image:[UIImage imageNamed:@"basketball2"]
                       tag:1
                    target:self
                    action:@selector(pushMenuItem:)],    //点击菜单项处理事件
      
//      [KxMenuItem menuItem:NSLocalizedStringFromTable(@"Tennis", @"InfoPlist", nil)
//                     image:[UIImage imageNamed:@"tennisball2"]
//                       tag:2
//                    target:self
//                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[_type];
    first.foreColor = KSBackgroundGray;  //设置菜单项的foreColor字体颜色，前背景颜色
    first.alignment = NSTextAlignmentCenter;   //设置菜单项的对其方式
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:[sender.superview convertRect:sender.frame toView:self.navigationController.view]
                 menuItems:menuItems];
}

-(UIColor *)infoBlueColor
{
    return KSBackgroundGray;//[UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
}

- (void)pushMenuItem:(id)sender
{
    KxMenuItem *button = sender;
    _type = button.tag;
    [self changeTypeBtn];
    NSLog(@"%li", (long)button.tag);
    [self loadLevno];
}




#pragma mark -- 创建tableView
- (UITableView *)createTableView
{
    if (!_tableView)
    {
        _tableView = ({
            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewCellStyleDefault];
            
            tableView.showsVerticalScrollIndicator = YES;
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            [self.view addSubview:tableView];
            
            tableView;
        });
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (_isHistory) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSceenWidth-20, 30)];
//        label.font = [UIFont systemFontOfSize:13];
//        label.textColor = KSBlue;
//        label.text = @"历史记录";
//        return label;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (_isHistory) {
//        return 30;
//    }
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataSource.count == 10 && !_isHistory) {
        return 30;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_dataSource.count == 10 && !_isHistory) {
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 30)];
        [moreBtn setTitle:NSLocalizedStringFromTable(@"Click to load more", @"InfoPlist", nil) forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setTitleColor:KSBlue forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        return moreBtn;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"cell";
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.searchResult = _dataSource[indexPath.row];
//    cell.keyword = _searchBar.text;
    if (_searchBar.text.length > 0) {
        // 原始搜索结果字符串.
        SearchResult *searchResult = _dataSource[indexPath.row];
        NSString *originResult = searchResult.Name;
        
        // 获取关键字的位置 , 都转换成小写来查找位置
        NSRange range = [originResult.lowercaseString rangeOfString:_searchBar.text.lowercaseString];
        
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
        
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
        
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        
        // 将带属性的字符串添加到cell.textLabel上.
        [cell.nameLabel setAttributedText:attribute];
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableArray *array = [[self getArrayWithKey:@"history"] mutableCopy];
    SearchResult *indexResult = _dataSource[indexPath.row];

    if (array.count < 3) { // 判断是否有历史记录，如果没有，就初始化为3个数组
//        array = [@[@[],@[],@[]] mutableCopy];
        NSMutableArray *a0 = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *a1 = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *a2 = [NSMutableArray arrayWithCapacity:10];
        array = [@[a0,a1,a2] mutableCopy];
        [array[_type] addObject:indexResult.mj_JSONString];
        [self saveArray:array withKey:@"history"];

    } else {
        // 判断是否有相同的
        BOOL historyHas = NO;
        for (SearchResult *search in array[_type]) {
            if ([search.ID intValue] == [indexResult.ID intValue]) {
                historyHas = NO;
                break;
            } else {
                historyHas = YES;
            }
        }
        if ([array[_type] count] == 0) { // 数组为空
            historyHas = YES;
        }
        
        if (historyHas) { // 没有重复的
//            NSMutableArray *history = [NSMutableArray arrayWithCapacity:10];
//            for (int i = 0; i < [array[_type] count]; i++) {
//                SearchResult *search = array[_type][i];
//                [history addObject:search.mj_JSONString];
//            }
//            array[_type] = [history mutableCopy];
//            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSMutableArray *array2 = [[self getArrayStringWithKey:@"history"] mutableCopy];
//            array2 = [[defaults objectForKey:@"history"] mutableCopy];
            [array2[_type] insertObject:indexResult.mj_JSONString atIndex:0];
            if ([array2[_type] count] > 10) {
                [array2[_type] removeObjectAtIndex:10];
            }
            [self saveArray:array2 withKey:@"history"];

        }

    }
    
    
    
    TeamDetailViewController *teamVC = [[TeamDetailViewController alloc] init];
    teamVC.baction=^(){
        
        [self.searchBar resignFirstResponder];
    
    };
    SearchResult *searchResult = _dataSource[indexPath.row];
    teamVC.type = [searchResult.Sport intValue];
    teamVC.teamid = [searchResult.ID intValue];
    teamVC.title = searchResult.Name;
    teamVC.sportType = searchResult.Type;
    
//    [self.navigationController pushViewController:teamVC animated:NO];
    
    FootballDetailController *footballDetailVc = [[FootballDetailController alloc] init];
    footballDetailVc.matchID =  [searchResult.ID intValue];
    footballDetailVc.type = [searchResult.Sport intValue];
    footballDetailVc.state = 0;
    [footballDetailVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:footballDetailVc animated:YES];
    
    
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [_searchBar resignFirstResponder];
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数（减速停止，结束拖动）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   // [_searchBar resignFirstResponder];
}


#pragma mark -- 创建UICollectionView
- (UICollectionView *)createUICollectionView
{
    if (!_collectionView)
    {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 自定义的布局对象
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        layout.minimumLineSpacing = 5;
//        layout.minimumInteritemSpacing = 5;
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.minimumLineSpacing = 0.0f;
//        layout.minimumInteritemSpacing = 0.0f;
//        CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];

        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId]; // 头部
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId]; // 尾部
        collectionView.alwaysBounceVertical = YES;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

//配置item的边距
//设置每组的cell的边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_historySource[_type] count];
}

// 定义 UICollectionView 中上下两个 cell 的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


// 定义 UICollectionView 中左右两个 cell 的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

// 定义 UICollectionView 头部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kSceenWidth, 32);
}

// 定义 UICollectionView 尾部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}



// 设置返回每个item的属性
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    SearchResult *search = _historySource[_type][indexPath.row];
    cell.keyword = search.Name;
    [cell setNeedsLayout];
    return cell;
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];
    }
    SearchResult *search = _historySource[_type][indexPath.row];
    _cell.keyword = search.Name;
    return [_cell sizeForCell];
}


// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
//        headerView.backgroundColor = [UIColor grayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
        label.text = NSLocalizedStringFromTable(@"Search history", @"InfoPlist", nil);
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-30, 5, 20, 20)];
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:deleteBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 30, kSceenWidth-20, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [headerView addSubview:line];
        return headerView;
    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        UICollectionReusableView *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
//        if(footerView == nil)
//        {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        footerView.backgroundColor = [UIColor lightGrayColor];
//        
//        return footerView;
//    }
    
    return nil;
}

#pragma mark -- 删除历史记录
- (void)deleteHistory{
    [self saveArray:nil withKey:@"history"];
    _historySource = nil;
    
    [_collectionView reloadData];
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (int i = 0; i < [_historySource[_type] count] ; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [indexPaths addObject:indexPath];
//    }
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
//    } completion:^(BOOL finished) {
//        
//        for (NSIndexPath *indexPath in indexPaths) {
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//            cell.backgroundColor = [UIColor redColor];
//        }
//    }];
}

// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamDetailViewController *teamVC = [[TeamDetailViewController alloc] init];
    SearchResult *searchResult = _historySource[_type][indexPath.row];
    teamVC.type = [searchResult.Sport intValue];
    teamVC.teamid = [searchResult.ID intValue];
    teamVC.title = searchResult.Name;
    teamVC.sportType = searchResult.Type;
    [self.navigationController pushViewController:teamVC animated:YES];
  
    
//    KSTeamDetailViewController* teamVC=[[KSTeamDetailViewController alloc]init];
//    SearchResult *searchResult = _historySource[_type][indexPath.row];
//    teamVC.type = [searchResult.Sport intValue];
//    teamVC.teamid = [searchResult.ID intValue];
//    teamVC.title = searchResult.Name;
//    teamVC.sportType = searchResult.Type;
//    [self.navigationController pushViewController:teamVC animated:YES];

    
}



//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray* array = [super layoutAttributesForElementsInRect:rect];
//    
//    //可视rect
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    
//    //设置item的缩放
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//item到中心点的距离
//            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;//距离除以有效距离得到标准化距离
//            //距离小于有效距离才生效
//            NSLog(@"%f",distance);
//            if (ABS(distance) < ACTIVE_DISTANCE) {
//                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));//缩放率范围1~1.3,与标准距离负相关
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);//x,y轴方向变换
//                //attributes.zIndex = 0;
//            }
//        }
//    }
//    
//    return array;
//}




//- (CustomTextField *)searchBar
//{
//    if (!_searchBar)
//    {
//        _searchBar = [[CustomTextField alloc]initWithFrame:CGRectMake(0, WGiveHeight(15+64), self.view.frame.size.width, WGiveHeight(45))];
//        _searchBar.backgroundColor = [UIColor whiteColor];
//        _searchBar.clearButtonMode = UITextFieldViewModeAlways;
//        [_searchBar becomeFirstResponder];
//        [_searchBar addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
//        [self.view addSubview:_searchBar];
//    }
//    return _searchBar;
//}


#pragma mark -- 搜索框文字改变时调用
- (void)changeFieldText:(CustomTextField *)sender
{
    // 尚未选定具体字符,不搜索
//    UITextRange *selectedRange = [sender markedTextRange];
//    NSString * newText = [sender textInRange:selectedRange];
//    //获取高亮部分
//    if(newText.length>0)
//        return;
    if (_searchBar.text.length == 0) {
        _isHistory = YES;
        [self.view bringSubviewToFront:_collectionView];
        [self.view bringSubviewToFront:_iFlyView];
        //        _dataSource = [self getArrayWithKey:@"history"];
        //        [self.tableView reloadData];
    }
    
    [self loadLevno];

}

#pragma mark -- 加载联想
- (void)loadLevno{
    if (_searchBar.text.length > 0) {
        [self createTableView];
        [self.view bringSubviewToFront:_tableView];
        [self.view bringSubviewToFront:_iFlyView];
        NSString *search = _searchBar.text;
        if ([NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"gb"] || [NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"big"]) {
            search = [search stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        NSLog(@"搜索内容=%@",search);
        _searchString = search;
        NSDictionary *params = @{@"key":search,@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"count":@"10"};
        [KSKuaiShouTool searchWithParams:params withCompleted:^(id result) {
            Search *searchResult = [Search mj_objectWithKeyValues:result];
            if (searchResult.ret_code == 0) {
                if ([search isEqualToString:_searchString]) {
                    _dataSource = searchResult.result;
                    for (int i = 0; i < _dataSource.count; i++) {
                        //                        SearchResult *search = _dataSource[i];
                        //                        NSLog(@"搜索结果=%@",search.Name);
                    }
                    _isHistory = NO;
                    [self.tableView reloadData];
                    if (_dataSource.count == 0) { // 搜索不到相关的内容
                        self.label.hidden = NO;
                        [self.view bringSubviewToFront:_label];
                    }
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else if (_searchBar.text.length == 0) {
        _isHistory = YES;
        [self.view bringSubviewToFront:_collectionView];
        [self.view bringSubviewToFront:_iFlyView];
//        _dataSource = [self getArrayWithKey:@"history"];
//        [self.tableView reloadData];
    }
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _isHistory = YES;
    _historySource = [self getArrayWithKey:@"history"];
//    [self.tableView reloadData];
    [self.collectionView reloadData];
    return YES;
}

#pragma mark -- 键盘上的回车搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loadMoreData];
    return YES;
}

#pragma mark -- 加载更多数据
- (void)loadMoreData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(3.);
    });
    if (_searchBar.text.length > 0) {
        [self createTableView];
        NSString *search = _searchBar.text;
        if ([NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"gb"] || [NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"big"]) {
            search = [search stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        NSLog(@"搜索内容=%@",_searchBar.text);
        
        NSDictionary *params = @{@"key":search,@"mtype":[NSString stringWithFormat:@"%li",(long)_type],@"count":@"100"};
        [KSKuaiShouTool searchWithParams:params withCompleted:^(id result) {
            Search *searchResult = [Search mj_objectWithKeyValues:result];
            if (searchResult.ret_code == 0) {
                //                if ([sender.text isEqualToString:_searchString]) {
                _dataSource = searchResult.result;
                for (int i = 0; i < _dataSource.count; i++) {
                    //                    SearchResult *search = _dataSource[i];
                    //                    NSLog(@"搜索结果=%@",search.Name);
                }
                hud.hidden = YES;
                [self.tableView reloadData];
                [_searchBar resignFirstResponder];
                
                
                //                }
            }
            
        } failure:^(NSError *error) {
            hud.hidden = YES;
        }];
    }else if (_searchBar.text.length == 0) {
        hud.hidden = YES;
        _dataSource = [self getArrayWithKey:@"history"];
        [self.tableView reloadData];
        
    }
}

//- (void)didClickSearch{
//    NSDictionary *params = @{@"key":_searchBar.text,@"mtype":[NSString stringWithFormat:@"%i",_type]};
//    [KSLikeSportTool searchWithParams:params withCompleted:^(id result) {
//        Search *searchResult = [Search mj_objectWithKeyValues:result];
//        if (searchResult.ret_code == 0) {
//            _dataSource = searchResult.result;
//            for (int i = 0; i < _dataSource.count; i++) {
//                SearchResult *search = _dataSource[i];
//                NSLog(@"搜索结果=%@",search.Name);
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 讯飞语音输入
- (void)createIFly {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kSceenHeight - 50, kSceenWidth, 50)];
    view.backgroundColor = KSBackgroundGray;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, kSceenWidth-40, 40)];
    [sendBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    [sendBtn setTitle:NSLocalizedStringFromTable(@"Hold to Talk", @"InfoPlist", nil) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(stopIFly) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(startIFly) forControlEvents:UIControlEventTouchDown];
    [sendBtn addTarget:self action:@selector(promptCancelIFly) forControlEvents:UIControlEventTouchDragExit];
    [sendBtn addTarget:self action:@selector(cancelIFly) forControlEvents:UIControlEventTouchUpOutside];
    //UIControlEventTouchDragEnter 当一次触摸从控件窗口之外拖动到内部时：往上滑后又往下滑回来，继续录音
    [sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    sendBtn.layer.cornerRadius = 5;
    // 设置按钮边框
    sendBtn.layer.borderWidth = 0.5;
    sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sendBtn.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];

    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:sendBtn];
    _iFlyBtn = sendBtn;
    
//    [self.view addSubview:view];
    
    
  //  [self.view insertSubview:view atIndex:0];
    self.iFlyView = view;
    
    self.searchBar.inputAccessoryView=self.iFlyView;
    
    IATConfig *instance = [IATConfig sharedInstance];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [languages objectAtIndex:0];
        NSLog(@"当前语言:%@", preferredLang);
    
    if ([preferredLang rangeOfString:@"zh-Hans"].location != NSNotFound) { // 中文和台湾用普通话
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_MANDARIN];
    } else if ([preferredLang isEqualToString:@"zh-HK"]||[preferredLang isEqualToString:@"zh-MO"]|| [preferredLang isEqualToString:@"zh-Hant-HK"]||[preferredLang isEqualToString:@"zh-Hant-MO"]) { //香港和澳门粤语
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_CANTONESE];
    } else if ([preferredLang rangeOfString:@"zh-Hant"].location != NSNotFound) { // 繁体用普通话
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_MANDARIN];
    } else {
        instance.language = [IFlySpeechConstant LANGUAGE_ENGLISH];
    }
   
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    
    
}

// 停止录音
- (void)stopIFly{
    [_iFlySpeechRecognizer stopListening];
    
    
    [self.notify removeFromSuperview];
}

// 开始录音
- (void)startIFly{
    [_activityView startAnimating];

    self.isCanceled = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
//        [_audioStreamBtn setEnabled:NO];
//        [_upWordListBtn setEnabled:NO];
//        [_upContactBtn setEnabled:NO];
    }else{
        NSLog(@"讯飞语音输入:启动识别服务失败，请稍后重试");
//        [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
    }
    
    [self displayNotification];


}

// 往上滑，提示取消录音
- (void)promptCancelIFly{
    NSLog(@"讯飞语音输入:往上滑提示取消录音");
}

// 取消录音
- (void)cancelIFly{
    self.isCanceled = YES;

    [_iFlySpeechRecognizer cancel];
    
    [self.notify removeFromSuperview];

    [_activityView stopAnimating];

}

//4. IFlySpeechRecognizerDelegate识别代理
/*识别结果返回代理
 @param :results识别结果
 @ param :isLast 表示是否最后一次结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _searchBar.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    if ([NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"big"] || [NSLocalizedStringFromTable(@"lan", @"InfoPlist", nil) isEqualToString:@"gb"]) {//粤语
        _searchBar.text = [NSString stringWithFormat:@"%@%@",_searchBar.text,[resultFromJson autoChange]];
    } else {
        _searchBar.text = [NSString stringWithFormat:@"%@%@ ", _searchBar.text,resultFromJson];
    }
    [self loadLevno];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_searchBar.text);
    [_activityView stopAnimating];
}

/*识别会话结束返回代理
 @ param error 错误码,error.errorCode=0表示正常结束,非0表示发生错误。 */
- (void) onError:(IFlySpeechError *) errorCode{
    if ([IATConfig sharedInstance].haveView == NO ) {
        NSString *text ;
        
        if (self.isCanceled) {
            text = @"识别取消";
            
        } else if (errorCode.errorCode == 0 ) {
            if (_result.length == 0) {
                text = @"无识别结果";
            }else {
                text = @"识别成功";
            }
        }else {
            text = [NSString stringWithFormat:@"发生错误：%d %@", errorCode.errorCode,errorCode.errorDesc];
//            NSLog(@"%@",text);
        }
        
//        [_popUpView showText: text];
        
    }else {
//        [_popUpView showText:@"识别结束"];
//        NSLog(@"errorCode:%d",[errorCode errorCode]);
    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech {
//    HUD.label.text = @"停止录音";
//    [HUD showAnimated:YES];
    NSLog(@"停止录音");

}

/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech {
//    HUD = [[MBProgressHUD alloc]initWithView:self.view];
//    HUD.label.text = @"正在录音";
//    
//    [HUD showAnimated:YES];
    NSLog(@"正在录音");
}

/**
 音量回调函数 volume 0-30
 ****/
- (void) onVolumeChanged: (int)volume {
    if (self.isCanceled) {
//        [_popUpView removeFromSuperview];
        return;
    }
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    NSLog(@"%@",vol);
    
    NSInteger radio = volume/5;
    NSString *volu = [NSString stringWithFormat:@"radio_%li",(long)radio];
    self.notify.image = [UIImage imageNamed:volu];
//    [_popUpView showText: vol];
}

#pragma mark -- 音量提示
- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"radio_0"] text:nil];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    return _notify;
}

- (void)displayNotification {
//    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:10.0f speed:0.5f inView:self.view completion:^{
//        [self.notify removeFromSuperview];
    }];
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            
//            [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    _iFlyView.transform = CGAffineTransformMakeTranslation(0, -height-64);
//    _iFlyView.hidden = NO;
//    [self.view bringSubviewToFront:_iFlyView];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
  //  _iFlyView.hidden = YES;
    
    
    
//    _iFlyView.transform = CGAffineTransformIdentity;
    
    
//    CGRect rect =_iFlyView.frame;
//    rect.origin.y=[UIScreen mainScreen].bounds.size.height;
//    _iFlyView.frame=rect;
}
-(void)keyboardChangeFrame:(NSNotification*)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat height = keyboardRect.origin.y;
//    if (height>[UIScreen mainScreen].bounds.size.height) {
//        CGRect rect =_iFlyView.frame;
//        rect.origin.y=[UIScreen mainScreen].bounds.size.height;
//        _iFlyView.frame=rect;
//    }else{
//    [self.view bringSubviewToFront:_iFlyView];
//        CGRect rect =_iFlyView.frame;
//        rect.origin.y=[UIScreen mainScreen].bounds.size.height-keyboardRect.size.height-_iFlyView.frame.size.height-64;
//        _iFlyView.frame=rect;
//    }
}

#pragma mark -- 字段持久缓存(保存在数据库)
- (void)saveArray:(NSArray *)array withKey:(NSString *)key{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:key];
    [defaults synchronize];
}
//- (void)saveArray:(NSArray *)array withKey:(NSString *)key
//{
//    NSMutableArray *history = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 0; i < array.count; i++) {
//        SearchResult *search = array[i];
//        [history addObject:search.mj_JSONString];
//    }
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    [defaults setObject:history forKey:key];
//    [defaults synchronize];
//}



- (NSArray *)getArrayWithKey:(NSString *)key {

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableArray *history = [defaults objectForKey:key];//根据键值取出name
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    if (history == nil) {
        return history;
    }

    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:3];
#warning iphone7闪退
    for (int i = 0; i < history.count; i++) {
        NSArray *array = history[i];
        NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j<array.count; j++) {
            [array3 addObject:[SearchResult mj_objectWithKeyValues:array[j]]];
        }
        [array2 addObject:array3];
    }
    return array2;
}

- (NSArray *)getArrayStringWithKey:(NSString *)key {
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableArray *history = [defaults objectForKey:key];//根据键值取出name
    
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < history.count; i++) {
        NSArray *array = history[i];
        NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j<array.count; j++) {
            [array3 addObject:array[j]];
        }
        [array2 addObject:array3];
        
    }
    return array2;
}

#pragma mark -- 没有数据时显示label
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 , 100, kSceenWidth-20, 40)];
        label.text = NSLocalizedStringFromTable(@"Can't search relevant information", @"InfoPlist", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view insertSubview:label atIndex:1];
        //        [self.view addSubview:label];
        //                [self.navigationController.view addSubview:label];
        _label = label;
    }
    return _label;
}

//- (UIActivityIndicatorView *)activityView {
//    if (_activityView) {
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 25, 15, 15)];
//        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//        //    [activityView setBackgroundColor:[UIColor lightGrayColor]];
//        [self.searchBar addSubview:activityView];
//        _activityView = activityView;
//    }
//    return _activityView;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
   // self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
     // [self.searchBar resignFirstResponder];
     //  [self.searchBar becomeFirstResponder];
   // [self.searchBar reloadInputViews];
   //self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    self.navigationController.navigationBarHidden = NO; // 使右滑返回手势可用
//    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
   
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.hidden = NO; // 显示导航栏
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
