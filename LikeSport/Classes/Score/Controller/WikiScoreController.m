//
//  WikiScoreController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/9.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "WikiScoreController.h"
#import "KSKuaiShouTool.h"
#import "KSFootballBase.h"
#import "KSBasketballBase.h"
#import "Btn_TableView.h"
#import "KSConstant.h"
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]

@interface WikiScoreController ()<UITextViewDelegate,Btn_TableViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (weak, nonatomic) UITextView *textView;
@property (weak, nonatomic) UITextField *hHalf;
@property (weak, nonatomic) UITextField *cHalf;
@property (weak, nonatomic) UITextField *hFull;
@property (weak, nonatomic) UITextField *cFull;

@property (strong , nonatomic) Btn_TableView *m_btn_tableView;


@end

@implementation WikiScoreController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setUpNavigationTitleCenter];
    
//    self.navigationItem.title = _wiki.matchtypefullname;
    
    [self getParam];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _textView.delegate = self;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}



-(void)dismissKeyboard{
//    [self.m_btn_tableView tableViewHidden];
    [_hHalf resignFirstResponder];
    [_cHalf resignFirstResponder];
    [_hFull resignFirstResponder];
    [_cFull resignFirstResponder];

    [_textView resignFirstResponder];
}


// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kSceenWidth, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//    [self.m_btn_tableView tableViewHidden];
//}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:NSLocalizedStringFromTable(@"Provide info or relevant link", @"InfoPlist", nil)]) {
        textView.text = @"";
        [self.m_btn_tableView tableViewHidden];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = NSLocalizedStringFromTable(@"Provide info or relevant link", @"InfoPlist", nil);
    }
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)getParam {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the bar determinate mode to show task progress.
    hud.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
    });
    
    [KSKuaiShouTool getFootballBaseType:_mtype withMatchID:_mid withCompleted:^(id result) {
        KSFootballBase *footballBase = [KSFootballBase mj_objectWithKeyValues:result];
        FootballBaseResult *baseResult = [FootballBaseResult mj_objectWithKeyValues:footballBase.result];
        
        KSBasketballBase *basketballBase = [KSBasketballBase mj_objectWithKeyValues:result];
        BasketResult *basketResult = [BasketResult mj_objectWithKeyValues:basketballBase.result];
        
        WikiParam *wikiParam = [[WikiParam alloc] init];
        if (_mtype == 0) { // 足球
            
            wikiParam.s_h_bf = baseResult.full_h;
            wikiParam.s_c_bf = baseResult.full_c;
            wikiParam.s_half_h = baseResult.half_h;
            wikiParam.s_half_c = baseResult.half_c;
            wikiParam.s_statetxt = baseResult.state;
            NSLog(@"s_h_bf%li---%li",(long)wikiParam.s_h_bf,(long)baseResult.full_h);
        } else if (_mtype == 1 || _mtype == 2) {  // 篮球
            wikiParam.s_h_bf = basketResult.total_h;
            wikiParam.s_c_bf = basketResult.total_c;
            wikiParam.s_half_h = basketResult.st1_h + basketResult.st2_h;
            wikiParam.s_half_c = basketResult.st1_h + basketResult.st2_h;
            wikiParam.s_statetxt = basketResult.state;
        }
        _wikiParam = wikiParam;
        MJExtensionLog(@"param%@",self.wikiParam.s_statetxt);
        
        [self setFootball];
        [self setSaveBtn];

        [hud hideAnimated:YES];

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


- (void)setFootball {
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-135, 45, 75, 20)];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.text = NSLocalizedStringFromTable(@"Status", @"InfoPlist", nil);
    [self.view addSubview:levelLabel];
    
    self.m_btn_tableView = [[Btn_TableView alloc] initWithFrame:CGRectMake(kSceenWidth/2-55, 45, 110, 25)];
    self.m_btn_tableView.delegate_Btn_TableView = self;
    //按钮名字
    KSConstant *state = [[KSConstant alloc] init];

//    self.m_btn_tableView.m_Btn_Name = [state getState:_wikiParam.s_statetxt];
    self.m_btn_tableView.tableViewHeigh = 300;
    self.m_btn_tableView.btnTitleColor = KSBlue;
    
    self.m_btn_tableView.cellColor = [UIColor whiteColor];
    self.m_btn_tableView.isDownImage = NO;

    self.m_btn_tableView.backgroundColor = [UIColor whiteColor];
    //数据内容
    if (_mtype == 0) {
        self.m_btn_tableView.m_TableViewData = @[NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Midfielder", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"ET", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil)];
    } else if (_mtype == 1) {
        self.m_btn_tableView.m_TableViewData = @[NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Midfielder", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil)];
    } else if (_mtype == 2) {
        self.m_btn_tableView.m_TableViewData = @[NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil),
                                                 NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil)];

    }
    
    [self.m_btn_tableView addViewData];
    
    if (_mtype == 0) {
        [self.m_btn_tableView setM_Btn_Name:[state getState:_wikiParam.s_statetxt]];
    } else if (_mtype == 1){
        switch ([_wikiParam.s_statetxt intValue]) {
            case 1:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil)];

                break;
                
            case 2:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil)];

                break;
                
            case 3:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil)];

                break;
                
            case 4:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil)];

                break;
                
            default:
                [self.m_btn_tableView setM_Btn_Name:[state getState:_wikiParam.s_statetxt]];
                break;
        }
    } else if (_mtype == 2) {
        switch ([_wikiParam.s_statetxt intValue]) {
            case 1:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil)];
                
                break;
                
            case 2:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil)];
                
                break;
                
            case 3:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil)];
                
                break;
                
            case 4:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil)];
                
                break;
            case 5:
                [self.m_btn_tableView setM_Btn_Name:NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil)];
                
                break;
                
            default:
                [self.m_btn_tableView setM_Btn_Name:[state getState:_wikiParam.s_statetxt]];
                break;
        }

    }

    [self.view addSubview:self.m_btn_tableView];
    
    
    UILabel *halfLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-135, 80, 75, 20)];
    halfLabel.textAlignment = NSTextAlignmentCenter;
    halfLabel.text = NSLocalizedStringFromTable(@"Half Time", @"InfoPlist", nil);;
    
    UITextField *hHalf = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2-55, 80, 40, 20)];
    //    hHalf.placeholder = @"0";
    if (_wikiParam.s_half_h != -1) {
        hHalf.text = [NSString stringWithFormat:@"%li",(long)_wikiParam.s_half_h];
    }
    hHalf.backgroundColor = [UIColor whiteColor];
    hHalf.keyboardType = UIKeyboardTypeDecimalPad;
    hHalf.textAlignment = NSTextAlignmentCenter;
    _hHalf = hHalf;
    
    UILabel *vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 80, 10, 20)];
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.text = @"-";
    
    UITextField *cHalf = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2+15, 80, 40, 20)];
    //    cHalf.placeholder = @"0";
    if (_wikiParam.s_half_c != -1) {
        cHalf.text = [NSString stringWithFormat:@"%li",(long)_wikiParam.s_half_c];
    }
    cHalf.backgroundColor = [UIColor whiteColor];
    cHalf.keyboardType = UIKeyboardTypeDecimalPad;
    cHalf.textAlignment = NSTextAlignmentCenter;
    _cHalf = cHalf;
    
    if (_mtype == 0) { // 篮球没有半场
        [self.view addSubview:halfLabel];
        [self.view addSubview:hHalf];
        [self.view addSubview:vsLabel];
        [self.view addSubview:cHalf];
        
    }
    
    
    UILabel *fullLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-135, 115, 75, 20)];
    if (_mtype == 1 || _mtype == 2) {
        fullLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-135, 80, 75, 20)];
    }
    fullLabel.textAlignment = NSTextAlignmentCenter;
    fullLabel.text = NSLocalizedStringFromTable(@"Full Time", @"InfoPlist", nil);
    [self.view addSubview:fullLabel];
    
    UITextField *hFull = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2-55, 115, 40, 20)];
    if (_mtype == 1 || _mtype == 2) {
        hFull = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2-55, 80, 40, 20)];
    }
    //    hFull.placeholder = @"0";
    if (_wikiParam.s_h_bf != -1) {
        hFull.text = [NSString stringWithFormat:@"%li",(long)_wikiParam.s_h_bf];
    }
    hFull.backgroundColor = [UIColor whiteColor];
    hFull.keyboardType = UIKeyboardTypeDecimalPad;
    hFull.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hFull];
    _hFull = hFull;
    
    
    UILabel *vs2Label = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 115, 10, 20)];
    if (_mtype == 1 || _mtype == 2) {
        vs2Label = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth/2-5, 80, 10, 20)];
    }

    vs2Label.textAlignment = NSTextAlignmentCenter;
    vs2Label.text = @"-";
    [self.view addSubview:vs2Label];
    
    UITextField *cFull = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2+15, 115, 40, 20)];
    if (_mtype == 1 || _mtype == 2) {
        cFull = [[UITextField alloc] initWithFrame:CGRectMake(kSceenWidth/2+15, 80, 40, 20)];
    }
    //    cFull.placeholder = @"0";
    if (_wikiParam.s_c_bf != -1) {
        cFull.text = [NSString stringWithFormat:@"%li",(long)_wikiParam.s_c_bf];
    }
    cFull.backgroundColor = [UIColor whiteColor];
    cFull.keyboardType = UIKeyboardTypeDecimalPad;
    cFull.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:cFull];
    _cFull = cFull;
    
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, kSceenWidth-20, 150)];
    if (_mtype == 1 || _mtype == 2) {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 115, kSceenWidth-20, 150)];
    }
    textView.text = NSLocalizedStringFromTable(@"Provide info or relevant link", @"InfoPlist", nil);
    textView.font = [UIFont systemFontOfSize:15];
    //    textView.backgroundColor = [UIColor lightGrayColor];
    textView.delegate = self;
    [self.view addSubview:textView];
    _textView = textView;
    
    
//    UILabel *label2 = [[UILabel alloc]init];
//    label2.numberOfLines = 0; // 需要把显示行数设置成无限制
//    label2.font = [UIFont systemFontOfSize:15];
//    label2.textAlignment = NSTextAlignmentLeft;
//    label2.text = @"帮助我们获得完整的赛程资料，您可以获得100金币";
//    CGSize size =  [self sizeWithString:label2.text font:label2.font];
//    label2.frame = CGRectMake(10, CGRectGetMaxY(textView.frame)+5, size.width, size.height);
//    //    label2.center = self.view.center;
//    [self.view addSubview:label2];
}


- (void)setSaveBtn {
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, kSceenWidth-20, 30)];
//    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [saveBtn setTitle:NSLocalizedStringFromTable(@"Send", @"InfoPlist", nil) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didClickedSaveButton) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.cornerRadius = 15;
    saveBtn.backgroundColor = KSBlue;
    //    [someButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:saveBtn];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
//    self.navigationItem.rightBarButtonItem = mailbutton;
}

- (void)didClickedSaveButton{
    //    _topView.hidden = YES;
    self.wikiParam.h_bf = [_hFull.text integerValue];
    self.wikiParam.c_bf = [_cFull.text integerValue];
    self.wikiParam.half_h = [_hHalf.text integerValue];
    self.wikiParam.half_c = [_cHalf.text integerValue];
    self.wikiParam.rmark = _textView.text;
    self.wikiParam.mtype = _wiki.mtype;
    self.wikiParam.wikitype = 1;
    self.wikiParam.wikixs_id = _wiki.wikixs_id;
    self.wikiParam.stage_id = _wiki.stage_id;
    self.wikiParam.typeid = _mid;

    
    [self.textView resignFirstResponder];
    NSDictionary *param = self.wikiParam.mj_keyValues;
    MJExtensionLog(@"param%@",param);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hideAnimated:YES afterDelay:3.f];
    hud.label.numberOfLines = 3;

    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, -20);
    
    if (self.wikiParam.s_h_bf != self.wikiParam.h_bf || self.wikiParam.s_c_bf != self.wikiParam.c_bf || self.wikiParam.s_half_h != self.wikiParam.half_h || self.wikiParam.s_half_c != self.wikiParam.half_c || ![self.wikiParam.rmark isEqualToString:NSLocalizedStringFromTable(@"Provide info or relevant link", @"InfoPlist", nil)]) {
        if (self.wikiParam != nil) {
            [KSKuaiShouTool wikiWithParam:self.wikiParam.mj_keyValues withCompleted:^(id result) {
                int ret_code = [[result objectForKey:@"ret_code"] intValue];
                if (ret_code == 0) {
                    hud.label.text = NSLocalizedStringFromTable(@"Submitted successfully", @"InfoPlist", nil);
                }
                
//                NSLog(@"维基提交成功%@",result);
            } failure:^(NSError *error) {
                
                hud.label.text = NSLocalizedStringFromTable(@"Submitted failed", @"InfoPlist", nil);
                
            }];
        }
        
    } else {
        hud.label.text = NSLocalizedStringFromTable(@"You do not change any information, can't submit", @"InfoPlist", nil);
    }
    
}

#pragma mark -- 下拉菜单的回调
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items;
    KSConstant *state = [[KSConstant alloc] init];

    if (_mtype == 0) {
        items = @[@"W",@"S",@"Z",@"X",@"J",@"F",@"D",@"Y",@"T",@"Q",@"C"];
        [self.m_btn_tableView setM_Btn_Name:[state getState:items[indexPath.row]]];
    } else if (_mtype == 1) {
        items = @[@"W",@"1",@"2",@"3",@"4",@"Z",@"F",@"D",@"Y",@"T",@"Q",@"C"];
        self.m_btn_tableView.m_Btn_Name = [state getBasketballState:items[indexPath.row]];
    } else if (_mtype == 2) {
        items = @[@"W",@"1",@"2",@"3",@"4",@"Z",@"F",@"D",@"Y",@"T",@"Q",@"C"];
        self.m_btn_tableView.m_Btn_Name = [state getTinnisState:items[indexPath.row]];
    }
    
    _wikiParam.statetxt = items[indexPath.row];
//        [self.m_btn setTitle:[state getState:items[indexPath.row]] forState:UIControlStateNormal];

//    NSLog(@"进程%@",items[indexPath.row]);
    //        NSInteger item = [items indexOfObject:theString];
    //    switch (item) {
}

- (void)setWiki:(WikiResult *)wiki {
    _wiki = wiki;
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
