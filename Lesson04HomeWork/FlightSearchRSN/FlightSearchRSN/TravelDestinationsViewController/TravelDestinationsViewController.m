//
//  TravelDestinationsViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 18.01.2021.
//

#import "TravelDestinationsViewController.h"
#import "DataManager.h"
#import "TravelDestinationsCell.h"
#import "MapViewController.h"

#define reuseTravelDestinationsCellIdentifier @"TravelDestinationsCellIdentifier"

@interface TravelDestinationsViewController ()
@property (nonatomic, strong) NSArray *travelDestinationsArray;
@property (nonatomic, strong) UIButton *showOnMapButton;
@end

@implementation TravelDestinationsViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    [self.tableView registerClass:[TravelDestinationsCell class] forCellReuseIdentifier:reuseTravelDestinationsCellIdentifier];
    return self;
}

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureShowOnMapButton];
    [self prepareTravelDestinationsArray];
}

//MARK: - ShowOnMapButton configuration
- (void) configureShowOnMapButton {
    self.showOnMapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showOnMapButton setTitle:@" Show on Map" forState:UIControlStateNormal];
    [self.showOnMapButton setImage:[UIImage systemImageNamed:@"map.fill"] forState:UIControlStateNormal];
    [self.showOnMapButton addTarget:self action:@selector(pushShowOnMapButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.showOnMapButton];
}

- (void) pushShowOnMapButton: (UIButton *)sender {
    [self openMapViewController];
}

- (void) openMapViewController {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    [self.navigationController showViewController:mapViewController sender:self];
}

//MARK: - Prepare Travel Destinations Array to present
- (void) prepareTravelDestinationsArray {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.travelDestinationsArray = [[[DataManager sharedInstance] countries] sortedArrayUsingDescriptors:@[sort]];
}

//MARK: - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.travelDestinationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelDestinationsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseTravelDestinationsCellIdentifier];
    if (!cell) {
        cell = [[TravelDestinationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseTravelDestinationsCellIdentifier];
    }
    Country *country = [self.travelDestinationsArray objectAtIndex:indexPath.row];
    cell.countryName.text = country.name;
    cell.countryCode.text = country.code;
    
    return cell;
}

@end
