//
//  MenuBar.m
//  WKMenuController
//
//  Created by macairwkcao on 16/1/26.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import "GBPopMenuButtonView.h"
#import "GBPopMenuButtonItem.h"

#define GBRotationAngle M_PI / 20

#define GBScreenWidth [UIScreen mainScreen].bounds.size.width
#define GBScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GBPopMenuButtonView()

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@property (nonatomic,weak)UIButton *mainButton;

@property(nonatomic,strong)NSArray *items;

@end

@implementation GBPopMenuButtonView{
    
    //拖动按钮的起始坐标点
    CGPoint _touchPoint;
    
    //起始按钮的x,y值
    CGFloat _touchBtnX;
    CGFloat _touchBtnY;
    
}

static CGFloat floatBtnW = 50;
static CGFloat floatBtnH = 50;

-(instancetype)initWithItems:(NSArray *)itemsImages size:(CGSize)size type:(GBmenuButtonType)type isMove:(BOOL)isMove{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.itemsImages = itemsImages;
        self.isShow = NO;
        self.type = type;
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.layer.cornerRadius = size.width / 2.0;
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        
        //判断是否添加添加移动手势
        if (isMove) {
//            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//            [self addGestureRecognizer:pan];
        }else{
            
            return self;
        }
    }
    return self;
}


#pragma mark - 移动方法
//- (void)pan:(UIPanGestureRecognizer *)pan
//{
//    //根据在view上Pan的位置，
//    CGPoint locationPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
//
//    CGFloat padding = CGRectGetWidth(self.frame)/2;
//    // 超出屏幕可视范围的直接return
//    if (locationPoint.x < padding || locationPoint.y < padding || locationPoint.x > GBScreenWidth-padding || locationPoint.y > GBScreenHeight-padding) return;
//
//    self.center = locationPoint;
//}

#pragma mark - button move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    
    _touchBtnX = self.frame.origin.x;
    _touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    //偏移量(当前坐标 - 起始坐标 = 偏移量)
    CGFloat offsetX = currentPosition.x - _touchPoint.x;
    CGFloat offsetY = currentPosition.y - _touchPoint.y;
    
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
    
    //父试图的宽高
    CGFloat superViewWidth = screenW;
    CGFloat superViewHeight = screenH;
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    
    //x轴左右极限坐标
    if (btnX > superViewWidth){
        //按钮右侧越界
        CGFloat centerX = superViewWidth - btnW/2;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnX < 0){
        //按钮左侧越界
        CGFloat centerX = btnW * 0.5;
        self.center = CGPointMake(centerX, centerY);
    }
    
    //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
    CGFloat defaultNaviHeight = 64;
    CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
    
    //y轴上下极限坐标
    if (btnY <= 0){
        //按钮顶部越界
        centerY = btnH * 0.7;
        self.center = CGPointMake(centerX, centerY);
    }
    else if (btnY > judgeSuperViewHeight){
        //按钮底部越界
        CGFloat y = superViewHeight - btnH * 0.5;
        self.center = CGPointMake(btnX, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    
    CGFloat minDistance = 2;
    
    //结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - _touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - _touchBtnY) > minDistance;
    
    if (isOverX || isOverY) {
        //超过移动范围就不响应点击 - 只做移动操作
        NSLog(@"move - btn");
        [self touchesCancelled:touches withEvent:event];
    }else{
        [super touchesEnded:touches withEvent:event];
        
//        [_floatBtn showItems];
        [self showItems];
        //        if (_floatBtn.btnClick) {
        //            _floatBtn.btnClick(_floatBtn);
        //        }
    }
    
    //按钮靠近右侧
    
    switch (MNAssistiveTypeNearRight) {
            
        case MNAssistiveTypeNone:{
            
            //自动识别贴边
            if (self.center.x >= screenW/2) {
                
                [UIView animateWithDuration:0.5 animations:^{
                    //按钮靠右自动吸边
                    CGFloat btnX = screenW - floatBtnW;
                    self.frame = CGRectMake(btnX, btnY, floatBtnW, floatBtnH);
                }];
            }else{
                
                [UIView animateWithDuration:0.5 animations:^{
                    //按钮靠左吸边
                    CGFloat btnX = 0;
                    self.frame = CGRectMake(btnX, btnY, floatBtnW, floatBtnH);
                }];
            }
            break;
        }
        case MNAssistiveTypeNearLeft:{
            [UIView animateWithDuration:0.5 animations:^{
                //按钮靠左吸边
                CGFloat btnX = 0;
                self.frame = CGRectMake(btnX, btnY, floatBtnW, floatBtnH);
            }];
            break;
        }
        case MNAssistiveTypeNearRight:{
            [UIView animateWithDuration:0.5 animations:^{
                //按钮靠右自动吸边
                CGFloat btnX = screenW - floatBtnW;
                self.frame = CGRectMake(btnX, btnY, floatBtnW, floatBtnH);
            }];
        }
    }
    
    
}


-(void)setImage:(UIImage *)image{
    [self.mainButton setImage:image forState:UIControlStateNormal];
}

-(void)setHighlightedImage:(UIImage *)highlightedImage{
    [self.mainButton setImage:highlightedImage forState:UIControlStateHighlighted];
}

-(void)setTitle:(NSString *)title color:(UIColor *)color{
    [self.mainButton setTitle:title forState:UIControlStateNormal];
    [self.mainButton setTitleColor:color forState:UIControlStateNormal];
}
#pragma mark - 重写hitTest:withEvent:方法，检查是否点击item
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    return self;
    CGPoint buttonPoint = [self convertPoint:point fromView:self];
    if ([self pointInside:buttonPoint withEvent:event]) {
        return self;
    }
    
    UIView *result = [super hitTest:point withEvent:event];
    if (self.isShow) {
        for (GBPopMenuButtonItem *item in self.items) {
            CGPoint buttonPoint = [item convertPoint:point fromView:self];
            if ([item pointInside:buttonPoint withEvent:event]) {
                return item;
            }
            
        }
    }
    return result;
}
-(void)setType:(GBmenuButtonType)type{
    _type = type;
}
#pragma mark -- 添加子视图
-(void)addSubviews{
    UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainButton addTarget:self action:@selector(showItems) forControlEvents:UIControlEventTouchUpInside];
//    [mainButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [mainButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    [mainButton setTitle:@"Menu" forState:UIControlStateNormal];
    [mainButton setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [mainButton setTintColor:[UIColor darkGrayColor]];
    mainButton.layer.borderWidth = 0.8;
    mainButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.mainButton = mainButton;
    self.mainButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    mainButton.layer.cornerRadius = self.frame.size.width / 2.0;
    mainButton.layer.masksToBounds = YES;
    
#pragma mark -- 菜单选项
    
    [self items];
    
    [self addSubview:_mainButton];
    
}

//- (instancetype)clipImageWithImageName:(UIImage *)img border:(CGFloat)border {
//    //開啟繪圖上下文
//    UIGraphicsBeginImageContext(img.size);
//    CGPoint center = CGPointMake(img.size.width * 0.5, img.size.height * 0.5);
//    CGFloat radius = MIN(center.x, center.y);
//    //先畫一個白色的圓
//    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    [[UIColor whiteColor] setFill];
//    [bgPath fill];
//    
//    //再畫一個小一點的圓
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius - border startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    //設定剪裁區域
//    [path addClip];
//    [img drawAtPoint:CGPointZero];
//    
//    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImg;
//}
//
//- (UIImage *)image:(NSString *)name {
//    CGSize size = CGSizeMake(35, 35);
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    [UIColor.whiteColor set];
//    CGPoint center = CGPointMake(35 * 0.5, 35 * 0.5);
//    CGFloat radius = MIN(center.x, center.y);
//    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    [[UIColor whiteColor] setFill];
//    [bgPath fill];
//    
//    CGRect rect = CGRectMake(7.5, 7.5, 21, 21);
//    UIRectFill(rect);
//    [name drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
#pragma mark -- 懒加载菜单选项
-(NSArray *)items{
    if (_items == nil) {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.itemsImages.count];
        for (int i = 0; i < self.itemsImages.count; i++) {
            UIImage *image = [UIImage imageNamed:self.itemsImages[i]];
            
//            UIImage *image = [self image:self.itemsImages[i]];
            GBPopMenuButtonItem *item = [GBPopMenuButtonItem muneItemWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) image:image heightImage:nil target:self action:@selector(tapItem:)];
            item.tag = 100 + i;
            item.center = self.mainButton.center;
            [self addSubview:item];
            [items addObject:item];
        }
        [self addSubview:_mainButton];
        _items = items;
    }
    return _items;
}
#pragma mark -- 展开item，以MenuBarTypeRound方式展开(@param offsetAngle  根据展开的方向不同，设置不同的偏移角度)
-(void)itemShowRoundTypeWithOffsetAngle:(CGFloat)offsetAngle{
    CGFloat count = self.items.count;
    for (GBPopMenuButtonItem *item in self.items) {
        CGFloat angle = [self caculateRoundAngleWithOffsetAngle:offsetAngle index:count];
        [item itemShowWithType:GBButtonItemShowTypeRound angle:angle];
        count -- ;
    }
}
-(void)itemShowLineWithOffsetPoint:(CGPoint)point incremenr:(CGSize)increment{
    CGFloat count = self.items.count;
    
    for (GBPopMenuButtonItem *item in self.items) {
        CGPoint targetPoint = [self caculateLinePointWithOffsetPoint:point increment:increment index:count];
        [item itemShowWithTargetPoint:targetPoint type:GBButtonItemShowTypeLine];
        count -- ;
    }
}
#pragma mark -- 展开角度计算，以MenuBarTypeRound方式展开(@param offsetAngle  根据展开的方向不同，设置不同的偏移角度,@return return angle 每个item偏移的角度)
-(CGFloat)caculateRoundAngleWithOffsetAngle:(CGFloat)offsetAngle index:(CGFloat)index{
    CGFloat angle = M_PI / (self.items.count);
    angle = angle * index - angle / 2.0 + offsetAngle;
    return angle;
}

-(CGPoint)caculateLinePointWithOffsetPoint:(CGPoint)offsetPoint increment:(CGSize)increment index:(NSInteger)index{
    CGFloat x = offsetPoint.x;
    CGFloat y = offsetPoint.y;
    x += increment.width * index;
    y += increment.height * index;
    CGPoint point = CGPointMake(x, y);
    return point;
}
#pragma mark - 成员方法(显示菜单)
-(void)showItems{
    if (!self.isShow) {
        CGFloat count = self.items.count;
        self.isShow = YES;
        if ([self.delegate respondsToSelector:@selector(menuButtonHide)]) {
            [self.delegate menuButtonShow];
        }
        switch (self.type) {
            case GBMenuButtonTypeRadRight:
                for (GBPopMenuButtonItem *item in self.items) {
                    [item itemShowWithType:GBButtonItemShowTypeRadRight angle:GBRotationAngle * count];
                    count --;
                }
                break;
            case GBMenuButtonTypeRadLeft:
                for (GBPopMenuButtonItem *item in self.items) {
                    [item itemShowWithType:GBButtonItemShowTypeRadLeft angle:GBRotationAngle * count];
                    count --;
                }
                break;
            case GBMenuButtonTypeLineTop:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(0, -self.frame.size.height - 10)];
            }
                break;
            case GBMenuButtonTypeLineBottom:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(0, self.frame.size.height + 10)];
                
            }
                break;
            case GBMenuButtonTypeLineLeft:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(- self.frame.size.height - 10, 0)];
            }
                break;
            case GBMenuButtonTypeLineRight:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(self.frame.size.height + 10, 0)];
            }
                break;
            case GBMenuButtonTypeRoundTop:{
                [self itemShowRoundTypeWithOffsetAngle:0];
            }
                break;
                
            case GBMenuButtonTypeRoundBottom:{
                [self itemShowRoundTypeWithOffsetAngle:- M_PI];
            }
                break;
            case GBMenuButtonTypeRoundLeft:{
                [self itemShowRoundTypeWithOffsetAngle:M_PI / 2.0];
                
            }
                break;
            case GBMenuButtonTypeRoundRight:{
                [self itemShowRoundTypeWithOffsetAngle: - M_PI / 2.0];
                
            }
                break;
            default:
                break;
        }
    }else{
        [self hideItems];
    }
}
#pragma mark - 成员方法(隐藏菜单)

-(void)hideItems{
    for (GBPopMenuButtonItem *item in self.items) {
        [item itemHide];
    }
    if ([self.delegate respondsToSelector:@selector(menuButtonHide)]) {
        [self.delegate menuButtonShow];
    }
    self.isShow = NO;
}
#pragma 点击item响应事件

-(void)tapItem:(GBPopMenuButtonItem *)item{
    if ([self.delegate respondsToSelector:@selector(menuButtonSelectedAtIdex:)]) {
        [self.delegate menuButtonSelectedAtIdex:item.tag - 100];
    }
    
    if (self.menuButtonSelectedAtIdex) {
        self.menuButtonSelectedAtIdex(item.tag - 100);
    }
    
}

@end
