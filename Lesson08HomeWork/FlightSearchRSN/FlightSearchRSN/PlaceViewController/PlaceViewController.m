//
//  PlaceViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 17.01.2021.
//

#import "PlaceViewController.h"

#define reusePlaceCellIdentifier @"PlaceCellIdentifier"

@interface PlaceViewController () <UISearchResultsUpdating>
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentPlaceArray;
@property (nonatomic, strong) NSMutableArray *searchedPlaceArray;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        self.placeType = type;
    }
    return self;
}

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSearchController];
    [self configureTableView];
    [self configureNavigationController];
    [self configureSegmentedControl];
}

//MARK: - TableView
- (void) configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
}

//MARK: - SearchController
- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.searchedPlaceArray = [NSMutableArray new];
    if (self.placeType == PlaceTypeDeparture) {
        self.searchController.searchBar.placeholder = NSLocalizedString(@"searchControllerSearchBarPlaceholderDeparture", "");
    } else {
        self.searchController.searchBar.placeholder = NSLocalizedString(@"searchControllerSearchBarPlaceholderArrival", "");
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        [self.searchedPlaceArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        self.searchedPlaceArray = [[self.currentPlaceArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];
    }
}

//MARK: - Navigation Controller
- (void) configureNavigationController {
    self.navigationItem.searchController = self.searchController;
    if (self.placeType == PlaceTypeDeparture) {
        self.title = NSLocalizedString(@"placeViewControllerFromLabel", "");
    } else {
        self.title = NSLocalizedString(@"placeViewControllerToLabel", "");
    }
}

//MARK: - Segmented Control
- (void) configureSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"segmentedControlCity", ""), NSLocalizedString(@"segmentedControlAirport", "")]];
    [self.segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
}

- (void)changeSource {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentPlaceArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            self.currentPlaceArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

//MARK: - Table view data source
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive && [self.searchedPlaceArray count] > 0) {
        return [self.searchedPlaceArray count];
    } else if (self.searchController.isActive && [self.searchedPlaceArray count] == 0 && ![self.searchController.searchBar.text isEqual: @""]) {
        return 0;
    } else {
        return [self.currentPlaceArray count];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusePlaceCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusePlaceCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        City *city = (self.searchController.isActive && [self.searchedPlaceArray count] > 0)? [self.searchedPlaceArray objectAtIndex:indexPath.row]: [self.currentPlaceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = (self.searchController.isActive && [self.searchedPlaceArray count] > 0)? [self.searchedPlaceArray objectAtIndex:indexPath.row]: [self.currentPlaceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int) self.segmentedControl.selectedSegmentIndex) + 1;
    if (self.searchController.isActive && [self.searchedPlaceArray count] > 0) {
        [self.delegate selectPlace:[self.searchedPlaceArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    } else {
        [self.delegate selectPlace:[self.currentPlaceArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
