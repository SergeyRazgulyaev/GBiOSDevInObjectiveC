//
//  TicketsViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 28.01.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "TicketFromMapCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"
#define TicketFromMapCellReuseIdentifier @"TicketFromMapCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UISegmentedControl *favoritesSegmentedControl;
@property (nonatomic, strong) UIButton *sortButton;

@end

@implementation TicketsViewController {
    BOOL isFavorites;
}

//MARK: - Init
- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        self.tickets = tickets;
        self.title = @"Tickets";
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSArray new];
        self.title = @"Favorite";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        [self.tableView registerClass:[TicketFromMapCell class] forCellReuseIdentifier:TicketFromMapCellReuseIdentifier];
        [self configureFavoritesSegmentedControl];
        [self configureSortButton];
    }
    return self;
}

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        [self selectSource];
        [self.tableView reloadData];
    }
}

//MARK: - TableView
- (void) configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//MARK: - TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isFavorites) {
        if (self.favoritesSegmentedControl.selectedSegmentIndex == 0) {
            TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
            cell.favoriteTicket = [self.tickets objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            TicketFromMapCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketFromMapCellReuseIdentifier forIndexPath:indexPath];
            cell.favoriteTicketFromMap = [self.tickets objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
        cell.ticket = [self.tickets objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Actions with ticket" message:@"What should be done with the selected ticket?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavoriteTicket: [self.tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Delete from Favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeTicketFromFavorites:[self.tickets objectAtIndex:indexPath.row]];
            [self.tableView reloadData];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Add to Favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addTicketToFavorites:[self.tickets objectAtIndex:indexPath.row]];
            [self.tableView reloadData];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//MARK: - Segmented Control
- (void) configureFavoritesSegmentedControl {
    self.favoritesSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Finder", @"Map"]];
    [self.favoritesSegmentedControl addTarget:self action:@selector(selectSource) forControlEvents:UIControlEventValueChanged];
    self.favoritesSegmentedControl.selectedSegmentIndex = 0;
    [self selectSource];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.favoritesSegmentedControl];
}

- (void)selectSource {
    switch (self.favoritesSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.tickets = [[CoreDataHelper sharedInstance] favoriteTicketsFromFinder];
            break;
        case 1:
            self.tickets = [[CoreDataHelper sharedInstance] favoriteMapPrices];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

//MARK: - Sort Button
-(void)configureSortButton {
    self.sortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sortButton setImage:[UIImage systemImageNamed:@"arrow.up.arrow.down.square"] forState:UIControlStateNormal];
    [self.sortButton addTarget:self action:@selector(pushSortButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sortButton.tag = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sortButton];
}

-(void)pushSortButton:(UIButton *)sender {
    if (self.sortButton.tag == 0) {
        switch (self.favoritesSegmentedControl.selectedSegmentIndex) {
            case 0:
                self.tickets = [[CoreDataHelper sharedInstance] favoriteTicketsFromFinderReverse];
                break;
            case 1:
                self.tickets = [[CoreDataHelper sharedInstance] favoriteMapPricesReverse];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
        [self.sortButton setImage:[UIImage systemImageNamed:@"arrow.up.arrow.down.square.fill"] forState:UIControlStateNormal];
        self.sortButton.tag = 1;
    } else {
        switch (self.favoritesSegmentedControl.selectedSegmentIndex) {
            case 0:
                self.tickets = [[CoreDataHelper sharedInstance] favoriteTicketsFromFinder];
                break;
            case 1:
                self.tickets = [[CoreDataHelper sharedInstance] favoriteMapPrices];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
        [self.sortButton setImage:[UIImage systemImageNamed:@"arrow.up.arrow.down.square"] forState:UIControlStateNormal];
        self.sortButton.tag = 0;
    }
}

@end
