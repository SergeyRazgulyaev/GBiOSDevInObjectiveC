//
//  TabBarController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import "TabBarController.h"
#import "MainMenuViewController.h"
#import "AircraftFleetViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype) init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
    }
    return self;
}

//MARK: - TabBarController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTabBarController];
}

//MARK: - TabBarController
- (void)configureTabBarController {
    self.tabBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
}

//MARK: - Methods
- (NSArray<UIViewController*> *) createViewControllers {
    NSMutableArray<UIViewController*> *viewControllers = [NSMutableArray new];
    
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
    mainMenuViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Main menu" image:[UIImage systemImageNamed:@"ticket"] selectedImage:[UIImage systemImageNamed:@"ticket.fill"]];
    
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    firstNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    [viewControllers addObject:firstNavigationController];
    
    AircraftFleetViewController *aircraftFleetViewController = [[AircraftFleetViewController alloc] init];
    aircraftFleetViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Aircraft fleet" image:[UIImage systemImageNamed:@"airplane.circle"] selectedImage:[UIImage systemImageNamed:@"airplane.circle.fill"]];

    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:aircraftFleetViewController];
    secondNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    [viewControllers addObject:secondNavigationController];
    
    return viewControllers;
}

@end
