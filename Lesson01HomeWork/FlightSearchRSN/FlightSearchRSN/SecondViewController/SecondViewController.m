//
//  SecondViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 12.01.2021.
//

#import "SecondViewController.h"
#import "DataManager.h"

@interface SecondViewController ()
@property (nonatomic, strong) UITextField *fromCityTextField;
@property (nonatomic, strong) UITextField *toCityTextField;
@property (nonatomic, strong) UISegmentedControl *dayOrNightSegmentedControl;
@property (nonatomic, strong) UILabel *flightDurationLabel;
@property (nonatomic, strong) UISlider *flightDurationSlider;
@property (nonatomic, strong) UIButton *loadDataButton;
@property (nonatomic, strong) UILabel *completeLoadDataLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressIndicator;
@property (nonatomic, strong) UIImageView *airplaneImageView;
@end

@implementation SecondViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureFromCityTextField];
    [self configureToCityTextField];
    [self configureDayOrNightSegmentedControl];
    [self configureFlightDurationLabel];
    [self configureFlightDurationSlider];
    [self configureLoadDataButton];
    [self configureCompleteLoadDataLabel];
    [self configureActivityIndicator];
    [self configureProgressIndicator];
    [self configureAirplaneImageView];
    [self addObserverInNotificationCenter];
}

- (void) dealloc
{
    [self removeObserverFromNotificationCenter];
}

//MARK: - Configuration Methods
- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"Flight Search";
}

//MARK: - Text Fields
-(void) configureFromCityTextField {
    self.fromCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 130, 300, 40)];
    self.fromCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.fromCityTextField.placeholder = @"Enter departure city";
    self.fromCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.fromCityTextField];
}

-(void) configureToCityTextField {
    self.toCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 190, 300, 40)];
    self.toCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.toCityTextField.placeholder = @"Enter the city of arrival";
    self.toCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.toCityTextField];
}

//MARK: - Segmented Control
- (void) configureDayOrNightSegmentedControl {
    self.dayOrNightSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Economy", @"Business"]];
    self.dayOrNightSegmentedControl.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 250, 200, 25);
    self.dayOrNightSegmentedControl.backgroundColor = [UIColor lightGrayColor];
    self.dayOrNightSegmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.dayOrNightSegmentedControl];
}

//MARK: - Slider
- (void) configureFlightDurationSlider {
    self.flightDurationSlider = [[UISlider alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 330, 300, 25)];
    self.flightDurationSlider.minimumTrackTintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.flightDurationSlider.maximumTrackTintColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.flightDurationSlider.minimumValue = 1.0;
    self.flightDurationSlider.maximumValue = 12.0;
    self.flightDurationSlider.value = self.flightDurationSlider.maximumValue / 2.0 + 1.0;
    self.flightDurationSlider.minimumValueImage = [UIImage systemImageNamed:@"airplane.circle.fill"];
    self.flightDurationSlider.maximumValueImage = [UIImage systemImageNamed:@"airplane.circle.fill"];
    self.flightDurationSlider.tintColor = [UIColor whiteColor];
    [self.flightDurationSlider setThumbImage:[UIImage systemImageNamed:@"airplane"] forState:UIControlStateNormal];
    [self.flightDurationSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.flightDurationSlider];
}

- (void) sliderValueChanged: (UISlider *)slider {
    if ([slider isEqual:self.flightDurationSlider]) {
        self.flightDurationLabel.text = [@"Flight duration: " stringByAppendingFormat:@"%@ hours", [NSString stringWithFormat: @"%0.0f", self.flightDurationSlider.value]];
    }
}

//MARK: - Button
- (void) configureLoadDataButton {
    self.loadDataButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadDataButton setTitle:@"Find flights" forState:UIControlStateNormal];
    self.loadDataButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.loadDataButton.tintColor = [UIColor whiteColor];
    self.loadDataButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 380, 200, 50);
    self.loadDataButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.loadDataButton addTarget:self action:@selector(pushLoadDataButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadDataButton];
}

//MARK: - Labels
- (void) configureFlightDurationLabel {
    self.flightDurationLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 300, 200, 30)];
    self.flightDurationLabel.textColor = [UIColor whiteColor];
    self.flightDurationLabel.text = [@"Flight duration: " stringByAppendingFormat:@"%@ hours", [NSString stringWithFormat: @"%0.0f", 7.0]];
    self.flightDurationLabel.textAlignment = NSTextAlignmentCenter;
    self.flightDurationLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.view addSubview:self.flightDurationLabel];
}

- (void) configureCompleteLoadDataLabel {
    self.completeLoadDataLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 430, 200, 50)];
    self.completeLoadDataLabel.textColor = [UIColor whiteColor];
    self.completeLoadDataLabel.text = @"Data loading completed!";
    self.completeLoadDataLabel.textAlignment = NSTextAlignmentCenter;
    self.completeLoadDataLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.completeLoadDataLabel setHidden:YES];
    [self.view addSubview:self.completeLoadDataLabel];
}

//MARK: - Activity Indicator
- (void) configureActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.activityIndicator.frame = self.view.bounds;
    self.activityIndicator.color = [UIColor greenColor];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
}

//MARK: - Progress Indicator
- (void) configureProgressIndicator {
    self.progressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressIndicator.progressTintColor = [UIColor greenColor];
    self.progressIndicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 440, 300, 25);
    self.progressIndicator.progress = 0.0;
    [self.progressIndicator setHidden:YES];
    [self.view addSubview:self.progressIndicator];
}

//MARK: - Progress Indicator
- (void) configureAirplaneImageView {
    self.airplaneImageView = [[UIImageView alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 150) / 2.0, 470, 150, 150)];
    self.airplaneImageView.image = [UIImage systemImageNamed:@"airplane.circle"];
    self.airplaneImageView.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.airplaneImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.airplaneImageView];
}

//MARK: - Methods
- (void) pushLoadDataButton: (UIButton *)sender {
    [self.activityIndicator startAnimating];
    [self.progressIndicator setHidden:NO];
    self.progressIndicator.progress = 0.5;
    [[DataManager sharedInstance] loadData];
}

- (void) showCompleteLoadDataLabel {
    [self.completeLoadDataLabel setHidden:NO];
}

- (void) loadDataComplete {
    [self.activityIndicator stopAnimating];
    [self.progressIndicator setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
    [self showCompleteLoadDataLabel];
}

- (void) addObserverInNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void) removeObserverFromNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

@end
