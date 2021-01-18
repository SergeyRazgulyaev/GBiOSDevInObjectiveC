//
//  PlaceViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 17.01.2021.
//

#import "PlaceViewController.h"

#define reusePlaceCellIdentifier @"PlaceCellIdentifier"

@interface PlaceViewController ()
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentPlaceArray;
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

//MARK: - Navigation Controller
- (void) configureNavigationController {
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    if (self.placeType == PlaceTypeDeparture) {
            self.title = @"From";
        } else {
            self.title = @"To";
        }
}

//MARK: - Segmented Control
- (void) configureSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"City", @"Airport"]];
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
    return [self.currentPlaceArray count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusePlaceCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusePlaceCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        City *city = [self.currentPlaceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [self.currentPlaceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int) self.segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace:[self.currentPlaceArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
