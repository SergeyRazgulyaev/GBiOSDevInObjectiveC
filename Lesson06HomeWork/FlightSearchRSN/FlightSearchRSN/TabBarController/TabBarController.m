//
//  TabBarController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import "TabBarController.h"
#import "FinderViewController.h"
#import "MapViewController.h"
#import "TicketsViewController.h"
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
    
    //FinderViewController
    FinderViewController *finderViewController = [[FinderViewController alloc] init];
    finderViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Finder" image:[UIImage systemImageNamed:@"ticket"] selectedImage:[UIImage systemImageNamed:@"ticket.fill"]];
    
    UINavigationController *finderNavigationController = [[UINavigationController alloc] initWithRootViewController:finderViewController];
    finderNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    finderNavigationController.navigationBar.prefersLargeTitles = NO;

    [viewControllers addObject:finderNavigationController];
    
    //Map ViewController
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Map" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage systemImageNamed:@"map.fill"]];

    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    mapNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    mapNavigationController.navigationBar.prefersLargeTitles = NO;
    [viewControllers addObject:mapNavigationController];
    
    //Favorite Tickets ViewController
    TicketsViewController *favoritesViewController = [[TicketsViewController alloc] initFavoriteTicketsController];
    favoritesViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Favorite" image:[UIImage systemImageNamed:@"star.circle"] selectedImage:[UIImage systemImageNamed:@"star.circle.fill"]];

    UINavigationController *favoritesNavigationController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    favoritesNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    favoritesNavigationController.navigationBar.prefersLargeTitles = NO;
    [viewControllers addObject:favoritesNavigationController];
    
    //AircraftFleetViewController
    AircraftFleetViewController *aircraftFleetViewController = [[AircraftFleetViewController alloc] init];
    aircraftFleetViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Aircraft fleet" image:[UIImage systemImageNamed:@"airplane.circle"] selectedImage:[UIImage systemImageNamed:@"airplane.circle.fill"]];

    UINavigationController *aircraftFleetNavigationController = [[UINavigationController alloc] initWithRootViewController:aircraftFleetViewController];
    aircraftFleetNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    aircraftFleetNavigationController.navigationBar.prefersLargeTitles = NO;
    [viewControllers addObject:aircraftFleetNavigationController];
    
    return viewControllers;
}

@end
