//
//  AGIntroduceViewController.m
//  AGIntroduceViewController
//
//  Created by amG on 2019/10/3.
//  Copyright © 2019 PrototypeC. All rights reserved.
//

#import "AGIntroduceViewController.h"
#import "UIView+AGConstraint.h"

@interface AGIntroduceViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *vcs;
@property (strong, nonatomic) UIButton *doneButton;

@end

@implementation AGIntroduceViewController

#pragma mark - Public

- (void)setBackgroundColor:(UIColor *)color {
    [self.view setBackgroundColor:color];
}

- (void)setPageControlSelectedColor:(UIColor *)color {
    self.pageControl.currentPageIndicatorTintColor = color;
}

- (void)setPageControlUnSelectedColor:(UIColor *)color {
    self.pageControl.pageIndicatorTintColor = color;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isLastPageShowDoneButton = NO;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *>*)images {
    self = [self init];
    if (self) {
        NSMutableArray *vcs = [NSMutableArray new];
        for (UIImage *image in images) {
            UIViewController *vc = [UIViewController new];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [vc.view addSubview:imageView];
            [imageView constraints:vc.view];
            [vcs addObject:vc];
        }
        self.vcs = [vcs copy];
        [self.pageViewController setViewControllers:@[vcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return self;
}

#pragma mark - Private

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isLastPageShowDoneButton == YES) {
        [self.doneButton setHidden:YES];
    }
}
- (void)setupView {
    self.view.backgroundColor = [UIColor colorWithRed:64/255.f green:64/255.f blue:64/255.f alpha:1.0f];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.pageControl];
    [self.pageViewController didMoveToParentViewController:self];
    [self.pageViewController.view constraintsTopLayoutGuide:self toLayoutAttribute:NSLayoutAttributeBottom constant:0];
    [self.pageViewController.view constraintsBottom:self.pageControl toLayoutAttribute:NSLayoutAttributeTop];
    [self.pageViewController.view constraintsLeading:self.view toLayoutAttribute:NSLayoutAttributeLeading];
    [self.pageViewController.view constraintsTrailing:self.view toLayoutAttribute:NSLayoutAttributeTrailing];
    
    [self.pageControl constraintsBottomLayoutGuide:self toLayoutAttribute:NSLayoutAttributeTop constant:0];
    [self.pageControl constraintsHeightWithConstant:16];
    [self.pageControl constraintsCenterX:self.view toLayoutAttribute:NSLayoutAttributeCenterX];
    
    [self.view addSubview:self.doneButton];
    [self.doneButton constraintsBottom:self.pageControl toLayoutAttribute:NSLayoutAttributeTop constant:-6];
    [self.doneButton constraintsHeightWithConstant:40];
    [self.doneButton constraintsCenterX:self.pageControl toLayoutAttribute:NSLayoutAttributeCenterX];
    [self.doneButton constraintSelfWidthHeightByRatio:2.3];
}

- (void)doneButtonDidTouchUpInside:(id)sender {
    if (self.endBlock != nil) {
        self.endBlock();
    }
}

#pragma mark - Getter

- (UIButton *)doneButton {
    if (_doneButton == nil) {
        UIButton *button = [UIButton new];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 2;
        [button addTarget:self action:@selector(doneButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton = button;
    }
    return _doneButton;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *control = [UIPageControl new];
        control.numberOfPages = self.vcs.count;
        control.currentPage = 0;
        control.pageIndicatorTintColor = [UIColor whiteColor];
        control.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl = control;
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark - PageViewController

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageVC.dataSource = self;
        pageVC.delegate = self;
        pageVC.view.backgroundColor = [UIColor clearColor];
        _pageViewController = pageVC;
    }
    return _pageViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    NSUInteger index = [self.vcs indexOfObject:pendingViewControllers.firstObject];
    self.pageControl.currentPage = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished) {
        NSUInteger index = [self.vcs indexOfObject:self.pageViewController.viewControllers.firstObject]; // index = 0 ~ n
        self.pageControl.currentPage = index;
        
        if (self.isLastPageShowDoneButton == YES) {
            if (index == self.vcs.count - 1) {
                [self.doneButton setHidden:NO];
            } else {
                [self.doneButton setHidden:YES];
            }
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.vcs indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.vcs[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.vcs indexOfObject:viewController];
    if (index == self.vcs.count - 1) {
        return nil;
    }
    return self.vcs[index + 1];
}

@end
