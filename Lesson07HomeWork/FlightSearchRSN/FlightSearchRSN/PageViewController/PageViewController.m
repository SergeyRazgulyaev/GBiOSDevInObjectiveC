//
//  PageViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 09.02.2021.
//

#import "PageViewController.h"
#import "InStartPageViewController.h"

#define CONTENT_COUNT 4

@interface PageViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation PageViewController {
    struct firstContentData {
        __unsafe_unretained NSString *title;
        __unsafe_unretained NSString *contentText;
        __unsafe_unretained NSString *imageName;
    } contentData[CONTENT_COUNT];
}

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContentDataArray];
    [self configurePageViewController];
}

//MARK: - Configure PageViewController
- (void)configurePageViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    
    InStartPageViewController *inStartViewController = [self viewControllerAtIndex:0];
    [self setViewControllers:@[inStartViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 150.0, self.view.bounds.size.width, 50.0)];
    self.pageControl.numberOfPages = CONTENT_COUNT;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height - 150.0, 100.0, 50.0);
    [self.nextButton addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTintColor:[UIColor blackColor]];
    [self updateButtonWithIndex:0];
    [self.view addSubview:self.nextButton];
}

//MARK: - Create Content Data Array
- (void)createContentDataArray {
    NSArray *titles = [NSArray arrayWithObjects:@"About Application", @"Tickets", @"Map with prices", @"Favorites", nil];
    NSArray *contents = [NSArray arrayWithObjects:@"Flight search application", @"Find the cheapest flights", @"View the map with ticket prices", @"Save tickets to favorites", nil];
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = [titles objectAtIndex:i];
        contentData[i].contentText = [contents objectAtIndex:i];
        contentData[i].imageName = [NSString stringWithFormat:@"first_%d", i+1];
    }
}

- (InStartPageViewController *)viewControllerAtIndex:(int)index {
    if (index < 0 || index >= CONTENT_COUNT) {
        return nil;
    }
    InStartPageViewController *inStartPageViewController = [[InStartPageViewController alloc] init];
    inStartPageViewController.title = contentData[index].title;
    inStartPageViewController.contentText = contentData[index].contentText;
    inStartPageViewController.image = [UIImage imageNamed: contentData[index].imageName];
    inStartPageViewController.index = index;
    return inStartPageViewController;
}

- (void)updateButtonWithIndex:(int)index {
    switch (index) {
        case 0:
        case 1:
        case 2:
            [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
            self.nextButton.tag = 0;
            break;
        case 3:;
            [self.nextButton setTitle:@"Ready" forState:UIControlStateNormal];
            self.nextButton.tag = 1;
            break;
        default:
            break;
    }
}

- (void)nextButtonDidTap:(UIButton *)sender {
    int index = ((InStartPageViewController *)[self.viewControllers firstObject]).index;
    if (sender.tag) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:index+1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.pageControl.currentPage = index+1;
            [weakSelf updateButtonWithIndex:index+1];
        }];
    }
}

//MARK:- UIPageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        int index = ((InStartPageViewController *)[pageViewController.viewControllers firstObject]).index;
        _pageControl.currentPage = index;
        [self updateButtonWithIndex:index];
    }
}

//MARK:- UIPageViewController DataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((InStartPageViewController *)viewController).index;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((InStartPageViewController *)viewController).index;
    index++;
    return [self viewControllerAtIndex:index];
}


@end
