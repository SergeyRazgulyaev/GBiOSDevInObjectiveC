//
//  FirstViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 11.01.2021.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()
@property (nonatomic, strong) UIView *substrateView;
@property (nonatomic, strong) UILabel *flightSearchLabel;
@property (nonatomic, strong) UIButton *nextControllerButton;
@property (nonatomic, strong) UILabel *flightNewsLabel;
@property (nonatomic, strong) UITextView *flightNewsTextView;
@end

@implementation FirstViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureSubstrateView];
    [self configureFlightSearchLabel];
    [self configureNextControllerButton];
    [self configureFlightNewsLabel];
    [self configureFlightNewsTextView];
}

//MARK: - Configuration Method
- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"Main menu";
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
    self.flightSearchLabel.text = @"Flight Search";
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

//MARK: - Button
- (void) configureNextControllerButton {
    self.nextControllerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextControllerButton setTitle:@"Go to flight search" forState:UIControlStateNormal];
    self.nextControllerButton.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.nextControllerButton.tintColor = [UIColor whiteColor];
    self.nextControllerButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 530, 200, 50);
    self.nextControllerButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.nextControllerButton addTarget:self action:@selector(pushNextControllerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextControllerButton];
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

//MARK: - Methods
- (void) pushNextControllerButton: (UIButton *)sender {
    [self openSecondViewController];
}

- (void) openSecondViewController {
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    [self.navigationController showViewController:secondViewController sender:self];
}

@end
