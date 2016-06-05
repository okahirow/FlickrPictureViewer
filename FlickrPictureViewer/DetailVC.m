//
//  DetailVC.m
//  FlickrPictureViewer
//
//  Created by 岡宏充 on 2016/06/05.
//  Copyright © 2016年 Hiromitsu Oka. All rights reserved.
//

#import "DetailVC.h"
#import "PicturePageVC.h"

@interface DetailVC () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property UIPageViewController* pageViewController;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInitialPageViewController];
}

- (void)setupInitialPageViewController {
    // Prevent the problem that first displayed PicturePageVC's content inset will not correct.
    // http://stackoverflow.com/questions/18202475/content-pushed-down-in-a-uipageviewcontroller-with-uinavigationcontroller
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    PicturePageVC *initialVC = [self getPicturePageVcOfIndex:self.initialPictureIndex];
    NSArray *viewControllers = @[initialVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self updateNavigationTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PicturePageVC*)getPicturePageVcOfIndex:(NSUInteger)index {
    PicturePageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PicturePageVC"];
    Picture* picture = self.pictureList[index];
    
    vc.pageIndex = index;
    vc.targetPicture = picture;
    
    return vc;
}

- (void)updateNavigationTitle {
    PicturePageVC *currentVC = self.pageViewController.viewControllers.firstObject;
    
    self.title = [NSString stringWithFormat:@"%lu/%lu", currentVC.pageIndex + 1, (unsigned long)self.pictureList.count];
}

- (IBAction)didTapScreen {
    [self toggleNavigationBar];
}

- (void)toggleNavigationBar {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    // If iPhone landscape, status bar should not display.
    BOOL shouldHideStatusBar = [super prefersStatusBarHidden];
    
    if (self.navigationController.navigationBarHidden) {
        return YES;
    }
    else {
        if (shouldHideStatusBar) {
            return YES;
        }
        else {
            return NO;
        }
    }
}



#pragma mark <UIPageViewControllerDelegate>

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self updateNavigationTitle];
}


#pragma mark <UIPageViewControllerDataSource>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PicturePageVC* beforeVC = (PicturePageVC*)viewController;
    
    if (beforeVC.pageIndex == 0) {
        return nil;
    }
    
    return [self getPicturePageVcOfIndex:beforeVC.pageIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PicturePageVC* beforeVC = (PicturePageVC*)viewController;
    
    if (beforeVC.pageIndex == self.pictureList.count - 1) {
        return nil;
    }
    
    return [self getPicturePageVcOfIndex:beforeVC.pageIndex + 1];
}


@end
