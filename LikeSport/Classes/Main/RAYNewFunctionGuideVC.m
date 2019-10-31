//
//  RAYNewFunctionGuideVC.m
//  hooray
//
//  Created by 罗剑玉 on 17/2/4.
//  Copyright © 2016年 swordfish. All rights reserved.

//

#import "RAYNewFunctionGuideVC.h"

#define WINSIZE [UIScreen mainScreen].bounds.size
#define arrowsImageViewW 60
#define arrowsImageViewH 46
#define titleLabW 200



@interface RAYNewFunctionGuideVC ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;

@property (nonatomic, strong) UIImageView *arrowsImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) NSMutableArray *framesArr;
@property (nonatomic, strong) NSMutableArray *titlesArr;

@property (nonatomic, assign) CGFloat titleLabH;

@property(nonatomic,assign)int pageindex;



@end

@implementation RAYNewFunctionGuideVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.titlesArr) {
        self.titlesArr = [self.titles mutableCopy];
    }
    if (!self.framesArr) {
        self.framesArr = [self.frames mutableCopy];
    }
    self.pageindex=0;
    [self resetBtnFrame];
    
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNi{
   self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNi];
    
    if (self) {
        
//        UIImage* img=[UIImage imageNamed:@"userGuideBtnBG_unClear@2x"];
//        UIImage* steimg=[img stretchableImageWithLeftCapWidth:img.size.width/2.0f-1.0f topCapHeight:img.size.height/2.0f-1.0f];
//        self.checkBtn.backgroundColor=[UIColor redColor];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIImage* img=[UIImage imageNamed:@"userGuideBtnBG_unClear@2x"];
        UIImage* steimg=[img stretchableImageWithLeftCapWidth:self.checkBtn.frame.size.width/2.0f-1.0f topCapHeight:20.0f];
       // [self.checkBtn setBackgroundImage:steimg forState:UIControlStateNormal];
        
        [self.checkBtn.layer setBackgroundColor:[UIColor clearColor].CGColor];
        [self.checkBtn.layer setMasksToBounds:YES];
        [self.checkBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.checkBtn.layer setBorderWidth:2.0f];
        [self.checkBtn.layer setCornerRadius:5.0f];
        
        
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.timer invalidate];
//    self.timer=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetBtnFrame)];
    [self.view addGestureRecognizer:tap];


   // self.timer=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(resetBtnFrame) userInfo:nil repeats:YES];
   // [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)checkBtnClick:(id)sender {
       [self resetBtnFrame];
    // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetBtnFrame{
    
//    if (self.pageindex<=2) {
//        self.nextaction(self.pageindex);
//        self.pageindex++;
//    }else{
//        [self.timer invalidate];
//        self.timer=nil;
//
//    }
    self.nextaction(self.pageindex);
    self.pageindex++;
    
    if (self.titlesArr.count>0&&self.framesArr.count>0) {
        CGRect rect = CGRectFromString(self.framesArr.firstObject);
        self.btnX.constant = rect.origin.x;
        self.btnY.constant = rect.origin.y;
        if (rect.size.width>0) {
            self.btnW.constant = rect.size.width;
        }else{
            self.btnW.constant = WINSIZE.width/375*120;
        }
        if (rect.size.height>0) {
            self.btnH.constant = rect.size.height;
        }
        [self.view layoutIfNeeded];
        [self.framesArr removeObjectAtIndex:0];
        
        self.titleLab.text = [self.titlesArr firstObject];
        [self.titlesArr removeObjectAtIndex:0];
        
        [self resetSubViewsFrameWithBtnFrame:self.checkBtn.frame];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}

- (void)resetSubViewsFrameWithBtnFrame:(CGRect)frame{

    CGFloat centerX = WINSIZE.width/2;
    CGFloat centerY = WINSIZE.height/2;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat btnW = frame.size.width;
    CGFloat btnH = frame.size.height;
    
    CGFloat arrowsX;
    CGFloat arrowsY;
    CGFloat titleLabX;
    CGFloat titleLabY;
    self.titleLabH = [self labelHeightFromeString:self.titleLab.text with:titleLabW];


    CGFloat angle;
    if (x<centerX && y<centerY) {
        //左上
        //箭头旋转180‘
        angle = M_PI;
        arrowsX = x+btnW/2;
        arrowsY = y+btnH;
        titleLabX = arrowsX+arrowsImageViewW;
        titleLabY = arrowsY+20.0f;
   
    }else if(x>=centerX && y<=centerY){
        //右上
        //箭头旋转-90‘
        angle = -M_PI_2;
        arrowsX = x-arrowsImageViewW/2;
        arrowsY = y+btnH;
        titleLabX = arrowsX-titleLabW/2;
        titleLabY = arrowsY+arrowsImageViewH;
    
    
    }else if(x>=centerX && y>=centerY){
        //右下
        //箭头不旋转
        angle = 0;
        arrowsX = x;
        arrowsY = y-arrowsImageViewH;
        titleLabX = arrowsX-titleLabW+20;
        titleLabY = arrowsY-self.titleLabH+20;

        
    }else if(x<centerX && y>centerY){
        //左下
        angle = M_PI_2;
        arrowsX = x+arrowsImageViewW/2;
        arrowsY = y-btnH;
        titleLabX = arrowsX;
        titleLabY = arrowsY-self.titleLabH;

        
    }
//    if (self.pageindex==1) {
//        self.checkBtn.transform=CGAffineTransformScale(CGAffineTransformIdentity, 4.0f, 1.0f);
//    }

    self.arrowsImageView.transform = CGAffineTransformMakeRotation(angle);
    self.arrowsImageView.frame = CGRectMake(arrowsX, arrowsY, arrowsImageViewW, arrowsImageViewH);
        self.titleLab.frame = CGRectMake(titleLabX, titleLabY, titleLabW, self.titleLabH);
    [self.view addSubview:self.arrowsImageView];
    [self startArrowsAnimation];
    [self.view addSubview:self.titleLab];
    //[self.view layoutSubviews];
    [self.view layoutIfNeeded];

}

/**
 * @desc根据字符串和宽度计算高度
 */
- (CGFloat)labelHeightFromeString:(NSString *)string with:(CGFloat)with
{
    CGRect tmpsize = [string boundingRectWithSize:CGSizeMake(with, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} context:nil];
    return tmpsize.size.height;
}
- (void)startArrowsAnimation{
    
    if (self.arrowsImageView.animationImages == nil) {
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for (int i = 1; i<=8; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"userGuide_arrors%d",i]];
            [images addObject:image];
        }
        self.arrowsImageView.animationImages = images;
        self.arrowsImageView.animationDuration = 0.6;
        self.arrowsImageView.animationRepeatCount = 0;
    }
    
    [self.arrowsImageView startAnimating];
}

- (void)stopArrowsAnimation{
    if ([self.arrowsImageView isAnimating]) [self.arrowsImageView stopAnimating];
}

-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab =[[UILabel alloc]init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:20.0f];
        // _titleLab.font = [UIFont fontWithName:@"Wawati SC" size:24];
       // _titleLab.text = @"这是一个新功能，这个功能很牛逼啊很牛B";
    }
    return _titleLab;
}

-(UIImageView *)arrowsImageView
{
    if (!_arrowsImageView) {
        _arrowsImageView = [[UIImageView alloc]init];
    }
    return _arrowsImageView;

}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];  
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}
@end
