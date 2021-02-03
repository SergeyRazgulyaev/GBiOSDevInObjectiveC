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

@interface TravelDestinationsViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *travelDestinationsArray;
@property (nonatomic, strong) NSMutableArray *travelDestinationsSearchArray;
@property (nonatomic, strong) UISearchController *searchController;

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
    [self configureTravelDestinationsViewController];
    [self configureSearchController];
    [self configureNavigationController];
    [self prepareTravelDestinationsArray];
}

//MARK: - TravelDestinationsViewController
- (void)configureTravelDestinationsViewController {
    self.title = @"Travel destinations";
    self.tableView.allowsSelection = NO;
}

//MARK: - SearchController
- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"Search travel destinations";
    self.travelDestinationsSearchArray = [NSMutableArray new];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        [self.travelDestinationsSearchArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        self.travelDestinationsSearchArray = [[self.travelDestinationsArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];
    }
}

//MARK: - NavigationController
- (void)configureNavigationController {
    self.navigationItem.searchController = self.searchController;
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
    if (self.searchController.isActive && [self.travelDestinationsSearchArray count] > 0) {
        return [self.travelDestinationsSearchArray count];
    } else if (self.searchController.isActive && [self.travelDestinationsSearchArray count] == 0 && ![self.searchController.searchBar.text isEqual: @""]) {
        return 0;
    } else {
        return [self.travelDestinationsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelDestinationsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseTravelDestinationsCellIdentifier];
    if (!cell) {
        cell = [[TravelDestinationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseTravelDestinationsCellIdentifier];
    }
    Country *country = (self.searchController.isActive && [self.travelDestinationsSearchArray count] > 0)? [self.travelDestinationsSearchArray objectAtIndex:indexPath.row]: [self.travelDestinationsArray objectAtIndex:indexPath.row];
    cell.countryName.text = country.name;
    cell.countryCode.text = country.code;
    
    return cell;
}

@end
