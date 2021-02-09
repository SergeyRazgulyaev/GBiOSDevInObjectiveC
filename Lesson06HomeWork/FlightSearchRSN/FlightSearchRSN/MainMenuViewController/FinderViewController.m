//
//  FinderViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 11.01.2021.
//

#import "FinderViewController.h"
#import "FlightSearchViewController.h"
#import "TravelDestinationsViewController.h"
#import "DataManager.h"

@interface FinderViewController () 
@property (nonatomic, strong) UIView *substrateView;
@property (nonatomic, strong) UILabel *flightSearchLabel;
@property (nonatomic, strong) UIButton *goToFlightSearchButton;
@property (nonatomic, strong) UIButton *travelDestinationsButton;
@property (nonatomic, strong) UILabel *flightNewsLabel;
@property (nonatomic, strong) UITextView *flightNewsTextView;
@end

@implementation FinderViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureSubstrateView];
    [self configureFlightSearchLabel];
    [self configureGoToFlightSearchButton];
    [self configureTravelDestinationsButton];
    [self configureFlightNewsLabel];
    [self configureFlightNewsTextView];
    [[DataManager sharedInstance] loadData];
}

//MARK: - Configuration Method
- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"Finder";
}

//MARK: - View
- (void) configureSubstrateView {
    self.substrateView = [[UIView alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 140, 300, 200)];
    self.substrateView.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    [self.view addSubview:self.substrateView];
}

//MARK: - Labels
- (void) configureFlightSearchLabel {
    self.flightSearchLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 190, 200, 100)];
    self.flightSearchLabel.backgroundColor = [UIColor whiteColor];
    self.flightSearchLabel.textColor = [UIColor blackColor];
    self.flightSearchLabel.text = @"Find Your Flight";
    self.flightSearchLabel.textAlignment = NSTextAlignmentCenter;
    self.flightSearchLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [self.view addSubview:self.flightSearchLabel];
}

- (void) configureFlightNewsLabel {
    self.flightNewsLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 370, 300, 25)];
    self.flightNewsLabel.backgroundColor = [UIColor whiteColor];
    self.flightNewsLabel.textColor = [UIColor blackColor];
    self.flightNewsLabel.text = @"Flight News";
    self.flightNewsLabel.textAlignment = NSTextAlignmentCenter;
    self.flightNewsLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.view addSubview:self.flightNewsLabel];
}

//MARK: - TextView
- (void) configureFlightNewsTextView {
    self.flightNewsTextView = [[UITextView alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 400, 300, 100)];
    self.flightNewsTextView.backgroundColor = [UIColor whiteColor];
    self.flightNewsTextView.textColor = [UIColor blackColor];
    self.flightNewsTextView.text = @"Sheremetyevo International Airport in Moscow reopened Terminal D in full operation from July 27, 2020. The airport is fully prepared for the restoration of international air traffic, taking into account the need to ensure the safety and health of passengers and guests.";
    self.flightNewsTextView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self.flightNewsTextView setEditable:NO];
    [self.view addSubview:self.flightNewsTextView];
}

//MARK: - Buttons
- (void) configureGoToFlightSearchButton {
    self.goToFlightSearchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.goToFlightSearchButton setTitle:@"Go to flight search" forState:UIControlStateNormal];
    self.goToFlightSearchButton.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.goToFlightSearchButton.tintColor = [UIColor whiteColor];
    self.goToFlightSearchButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 530, 200, 50);
    self.goToFlightSearchButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.goToFlightSearchButton addTarget:self action:@selector(pushGoToFlightSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goToFlightSearchButton];
}

- (void) pushGoToFlightSearchButton: (UIButton *)sender {
    [self openFlightSearchViewController];
}

- (void) openFlightSearchViewController {
    FlightSearchViewController *flightSearchViewController = [[FlightSearchViewController alloc] init];
    [self.navigationController showViewController:flightSearchViewController sender:self];
}

- (void) configureTravelDestinationsButton {
    self.travelDestinationsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.travelDestinationsButton setTitle:@"Travel destinations" forState:UIControlStateNormal];
    self.travelDestinationsButton.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.travelDestinationsButton.tintColor = [UIColor whiteColor];
    self.travelDestinationsButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 600, 200, 50);
    self.travelDestinationsButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.travelDestinationsButton addTarget:self action:@selector(pushTravelDestinationsButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.travelDestinationsButton];
}

- (void) pushTravelDestinationsButtonButton: (UIButton *)sender {
    [self openTravelDestinationsViewController];
}

- (void) openTravelDestinationsViewController {
    TravelDestinationsViewController *travelDestinationsViewController = [[TravelDestinationsViewController alloc] init];
    [self.navigationController showViewController:travelDestinationsViewController sender:self];
}


@end
