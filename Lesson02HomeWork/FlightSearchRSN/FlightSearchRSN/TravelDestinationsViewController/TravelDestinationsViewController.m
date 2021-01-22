//
//  TravelDestinationsViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 18.01.2021.
//

#import "TravelDestinationsViewController.h"
#import "DataManager.h"
#import "TravelDestinationsCell.h"

#define reuseTravelDestinationsCellIdentifier @"TravelDestinationsCellIdentifier"

@interface TravelDestinationsViewController ()
@property (nonatomic, strong) NSArray *travelDestinationsArray;
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
    [self prepareTravelDestinationsArray];
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
