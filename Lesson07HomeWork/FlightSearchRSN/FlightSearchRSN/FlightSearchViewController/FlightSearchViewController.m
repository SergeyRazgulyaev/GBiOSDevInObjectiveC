//
//  FlightSearchViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 12.01.2021.
//

#import "FlightSearchViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "PlaceViewController.h"
#import "TicketsViewController.h"
#import "ProgressView.h"

@interface FlightSearchViewController () <PalceViewControllerDelegate>
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) UILabel *flightDurationLabel;
@property (nonatomic, strong) UILabel *completeLoadDataLabel;
@property (nonatomic, strong) UITextField *departurePlaceTextField;
@property (nonatomic, strong) UITextField *arrivalPlaceTextField;
@property (nonatomic, strong) UISegmentedControl *economyOrBusinessSegmentedControl;
@property (nonatomic, strong) UISlider *flightDurationSlider;
@property (nonatomic, strong) UIButton *findDeparturePlaceButton;
@property (nonatomic, strong) UIButton *findArrivalPlaceButton;
@property (nonatomic, strong) UIButton *showTicketsButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressIndicator;
@property (nonatomic, strong) UIImageView *airplaneImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation FlightSearchViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureFromLabel];
    [self configureToLabel];
    [self configureFlightDurationLabel];
    [self configureCompleteLoadDataLabel];
    [self configureDeparturePlaceTextField];
    [self configureArrivalPlaceTextField];
    [self configureEconomyOrBusinessSegmentedControl];
    [self configureFlightDurationSlider];
    [self configureFindDeparturePlaceButton];
    [self configureFindArrivalPlaceButton];
    [self configureShowTicketsButton];
    [self configureActivityIndicator];
    [self configureProgressIndicator];
    [self configureAirplaneImageView];
    [self configureTapGestureRecognizer];
    [self addObserverInNotificationCenter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self keyboardAddObserver];
    [self configureSearchRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self keyboardRemoveObserver];
}

- (void) dealloc {
    [self removeObserverFromNotificationCenter];
}

//MARK: - Configuration Methods
- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"Flight Search";
    _searchRequest.origin = nil;
    _searchRequest.destination = nil;
    [[DataManager sharedInstance] loadData];
}

//MARK: - Notification Center
- (void) addObserverInNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void) removeObserverFromNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

//MARK: - SearchRequest
- (void) configureSearchRequest {
    _searchRequest.origin = nil;
    _searchRequest.destination = nil;
}

//MARK: - Load Data Methods
- (void) loadDataComplete {
    [self showCompleteLoadDataLabel];
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forTextField:self.departurePlaceTextField];
    }];
}

- (void) showCompleteLoadDataLabel {
    [self.completeLoadDataLabel setHidden:NO];
}

//MARK: - Labels
- (void) configureFromLabel {
    self.fromLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 - 18, 130, 43, 40)];
    self.fromLabel.textColor = [UIColor whiteColor];
    self.fromLabel.text = @"From:";
    self.fromLabel.textAlignment = NSTextAlignmentRight;
    self.fromLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.view addSubview:self.fromLabel];
}

- (void) configureToLabel {
    self.toLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 - 18, 190, 43, 40)];
    self.toLabel.textColor = [UIColor whiteColor];
    self.toLabel.text = @"To:";
    self.toLabel.textAlignment = NSTextAlignmentRight;
    self.toLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.view addSubview:self.toLabel];
}

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

//MARK: - Text Fields
-(void) configureDeparturePlaceTextField {
    self.departurePlaceTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 33, 130, 218, 40)];
    self.departurePlaceTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.departurePlaceTextField.placeholder = @"Departure place";
    self.departurePlaceTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.departurePlaceTextField];
}

-(void) configureArrivalPlaceTextField {
    self.arrivalPlaceTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 33, 190, 218, 40)];
    self.arrivalPlaceTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.arrivalPlaceTextField.placeholder = @"The place of arrival";
    self.arrivalPlaceTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.arrivalPlaceTextField];
}

//MARK: - Segmented Control
- (void) configureEconomyOrBusinessSegmentedControl {
    self.economyOrBusinessSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Economy", @"Business"]];
    self.economyOrBusinessSegmentedControl.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 250, 200, 25);
    self.economyOrBusinessSegmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.economyOrBusinessSegmentedControl];
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

//MARK: - Buttons
//FindDeparturePlace Button
- (void) configureFindDeparturePlaceButton {
    self.findDeparturePlaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.findDeparturePlaceButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    self.findDeparturePlaceButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.findDeparturePlaceButton.tintColor = [UIColor whiteColor];
    self.findDeparturePlaceButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 260, 130, 40, 40);
    [self.findDeparturePlaceButton addTarget:self action:@selector(pushFindDepartureOrArrivalPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.findDeparturePlaceButton];
}

//FindArrivalPlace Button
- (void) configureFindArrivalPlaceButton {
    self.findArrivalPlaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.findArrivalPlaceButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    self.findArrivalPlaceButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.findArrivalPlaceButton.tintColor = [UIColor whiteColor];
    self.findArrivalPlaceButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 260, 190, 40, 40);
    [self.findArrivalPlaceButton addTarget:self action:@selector(pushFindDepartureOrArrivalPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.findArrivalPlaceButton];
}

- (void) pushFindDepartureOrArrivalPlaceButton: (UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual: self.findDeparturePlaceButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController showViewController:placeViewController sender:self];
}

//ShowTicketsButton
- (void) configureShowTicketsButton {
    self.showTicketsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showTicketsButton setTitle:@"Show tickets" forState:UIControlStateNormal];
    self.showTicketsButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.showTicketsButton.tintColor = [UIColor whiteColor];
    self.showTicketsButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 380, 200, 50);
    self.showTicketsButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.showTicketsButton addTarget:self action:@selector(pushShowTicketsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showTicketsButton];
}

- (void) pushShowTicketsButton: (UIButton *)sender {
    if (![self.departurePlaceTextField.text isEqual: @""] && self.searchRequest.origin == nil) {
        _searchRequest.origin = [[DataManager sharedInstance] iataForCityOrAirport: self.departurePlaceTextField.text];
    }
    if (![self.arrivalPlaceTextField.text isEqual: @""] && self.searchRequest.destination == nil) {
        _searchRequest.destination = [[DataManager sharedInstance] iataForCityOrAirport: self.arrivalPlaceTextField.text];
    }
    
    if (self.searchRequest.origin == nil || self.searchRequest.destination == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Search error" message:@"Search fields must be filled in correctly" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.searchRequest.origin && self.searchRequest.destination) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedInstance] ticketsWithRequest:self.searchRequest withCompletion:^(NSArray *tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
                        [self.navigationController showViewController:ticketsViewController sender:self];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No tickets found for this direction" preferredStyle: UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }];
        }];
    }
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

//MARK: - AirplaneImageView
- (void) configureAirplaneImageView {
    self.airplaneImageView = [[UIImageView alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 150) / 2.0, 470, 150, 150)];
    self.airplaneImageView.image = [UIImage systemImageNamed:@"airplane.circle"];
    self.airplaneImageView.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.airplaneImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.airplaneImageView];
}

//MARK: - Select Place Method
- (void)selectPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forTextField: (placeType == PlaceTypeDeparture) ? self.departurePlaceTextField : self.arrivalPlaceTextField];
}

//MARK: - Set Place Method
- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forTextField:(UITextField *)textField {
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
        self.departurePlaceTextField.text = title;
    } else {
        _searchRequest.destination = iata;
        self.arrivalPlaceTextField.text = title;
    }
}

//MARK: - Tap Gesture Recognizer
- (void)configureTapGestureRecognizer {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

//MARK: - Keyboard
- (void)keyboardAddObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardRemoveObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShown:(NSNotification *)notification {
    //    NSLog(@"Keyboard Will Shown");
}

- (void) keyboardWillHide:(NSNotification *)notification {
    //    NSLog(@"Keyboard Will Hide");
}

@end
