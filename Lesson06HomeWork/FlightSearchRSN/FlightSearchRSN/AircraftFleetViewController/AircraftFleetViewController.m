//
//  AircraftFleetViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import "AircraftFleetViewController.h"
#import "Aircraft.h"
#import "AircraftFleetCell.h"

#define reuseAircraftFleetCellIdentifier @"AircraftFleetCellIdentifier"

@interface AircraftFleetViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *aircraftFleetArray;
@property (nonatomic, strong) NSMutableArray *aircraftSearchArray;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation AircraftFleetViewController

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAircraftFleetViewController];
    [self configureCollectionView];
    [self configureSearchController];
    [self configureNavigationController];
    [self createAircraftFleetArray];
}

//MARK: - Aircraft Fleet Array
- (void)createAircraftFleetArray {
    Aircraft *airbusA320 = [[Aircraft alloc] initWithModelName:@"Airbus A320" aircraftCapacity:@"180" imageName:@"AirbusA320"];
    Aircraft *airbusА321 = [[Aircraft alloc] initWithModelName:@"Airbus A321" aircraftCapacity:@"185" imageName:@"AirbusА321"];
    Aircraft *airbusА330200 = [[Aircraft alloc] initWithModelName:@"Airbus A330-200" aircraftCapacity:@"293" imageName:@"AirbusА330200"];
    Aircraft *airbusA350900 = [[Aircraft alloc] initWithModelName:@"Airbus A350-900" aircraftCapacity:@"366" imageName:@"AirbusA350900"];
    Aircraft *boeing737800  = [[Aircraft alloc] initWithModelName:@"Boeing 737-800" aircraftCapacity:@"189" imageName:@"Boeing737800"];
    Aircraft *boeing777300ER = [[Aircraft alloc] initWithModelName:@"Boeing 777-300ER" aircraftCapacity:@"550" imageName:@"Boeing777300ER"];
    Aircraft *sukhoiSuperJet100 = [[Aircraft alloc] initWithModelName:@"Sukhoi SuperJet 100" aircraftCapacity:@"108" imageName:@"SukhoiSuperJet100"];

    self.aircraftFleetArray = @[airbusA320, airbusА321, airbusА330200, airbusA350900, boeing737800, boeing777300ER, sukhoiSuperJet100];
}

//MARK: - AircraftFleetViewController
- (void)configureAircraftFleetViewController {
    self.title = @"Aircraft fleet";
}

//MARK: - SearchController
- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"Search aircraft";
    self.aircraftSearchArray = [NSMutableArray new];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        [self.aircraftSearchArray removeAllObjects];
        for (Aircraft *aircraft in self.aircraftFleetArray) {
            if ([[aircraft.modelName lowercaseString] containsString: [searchController.searchBar.text lowercaseString]]) {
                [self.aircraftSearchArray addObject:aircraft];
            }
        }
        [self.collectionView reloadData];
    }
}

//MARK: - NavigationController
- (void)configureNavigationController {
    self.navigationItem.searchController = self.searchController;
}

//MARK: - CollectionView
- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.itemSize = CGSizeMake(170.0, 170.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.collectionView.dataSource = self;    
    [self.collectionView registerClass:[AircraftFleetCell class] forCellWithReuseIdentifier:reuseAircraftFleetCellIdentifier];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchController.isActive && [self.aircraftSearchArray count] > 0) {
        return self.aircraftSearchArray.count;
    } else if (self.searchController.isActive && [self.aircraftSearchArray count] == 0 && ![self.searchController.searchBar.text isEqual: @""]) {
        return 0;
    } else {
        return self.aircraftFleetArray.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AircraftFleetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseAircraftFleetCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[AircraftFleetCell alloc] initWithReuseIdentifier:reuseAircraftFleetCellIdentifier];
    }
    if (self.searchController.isActive && [self.aircraftSearchArray count] > 0) {
        cell.aircraftImageView.image = [UIImage imageNamed:[[self.aircraftSearchArray objectAtIndex:indexPath.row] imageName]];
        cell.aircraftModelLabel.text = [[self.aircraftSearchArray objectAtIndex:indexPath.row] modelName];
        cell.aircraftCapacityLabel.text = [NSString stringWithFormat:@"Capacity: %@", [[self.aircraftSearchArray objectAtIndex:indexPath.row] aircraftCapacity]];
    } else {
        cell.aircraftImageView.image = [UIImage imageNamed:[[self.aircraftFleetArray objectAtIndex:indexPath.row] imageName]];
        cell.aircraftModelLabel.text = [[self.aircraftFleetArray objectAtIndex:indexPath.row] modelName];
        cell.aircraftCapacityLabel.text = [NSString stringWithFormat:@"Capacity: %@", [[self.aircraftFleetArray objectAtIndex:indexPath.row] aircraftCapacity]];
    }
    return cell;
}

@end
