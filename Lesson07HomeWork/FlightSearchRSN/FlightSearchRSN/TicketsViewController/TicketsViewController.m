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
#import "NotificationCenter.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"
#define TicketFromMapCellReuseIdentifier @"TicketFromMapCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UISegmentedControl *favoritesSegmentedControl;
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation TicketsViewController {
    BOOL isFavorites;
    BOOL isRemindedTicket;
    TicketTableViewCell *notificationCell;
}

//MARK: - Init
- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        self.tickets = tickets;
        self.title = @"Tickets";
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        
        self.dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        self.dateTextField.hidden = YES;
        self.dateTextField.inputView = self.datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        self.dateTextField.inputAccessoryView = keyboardToolbar;
        
        [self.view addSubview:self.dateTextField];
    }
    return self;
}

-(void)doneButtonDidTap:(UIButton *)sender {
    if (self.datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ for %@ rub.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];
        NSURL *imageURL;
        Notification notification = NotificationMake(@"Ticket reminder", message, self.datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successfully" message:[NSString stringWithFormat:@"Notification will be sent: %@", self.datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        isRemindedTicket = NO;
        self.tickets = [NSArray new];
        self.title = @"Favorites";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        [self.tableView registerClass:[TicketFromMapCell class] forCellReuseIdentifier:TicketFromMapCellReuseIdentifier];
        [self configureFavoritesSegmentedControl];
        [self configureSortButton];
    }
    return self;
}

- (instancetype)initWithRemindedTicket:(FavoriteTicket *)ticket; {
    self = [super init];
    if (self) {
        isFavorites = YES;
        isRemindedTicket = YES;
        self.tickets = @[ticket];
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
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
        if (isRemindedTicket == NO) {
            [self selectSource];
        }
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
    if (isFavorites) {
        if (self.favoritesSegmentedControl.selectedSegmentIndex == 0) {
            TicketTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:2.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                cell.getAircraftImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                    cell.getAircraftImageView.transform = CGAffineTransformMakeRotation(0);
                }
                                 completion:nil];
            }];
        } else {
            TicketFromMapCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:2.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                cell.getAircraftImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                    cell.getAircraftImageView.transform = CGAffineTransformMakeRotation(0);
                }
                                 completion:nil];
            }];
        }
    } else {
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
        
        UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Remind" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if ([[CoreDataHelper sharedInstance] isFavoriteTicket: [self.tickets objectAtIndex:indexPath.row]]) {
                self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
                [self->_dateTextField becomeFirstResponder];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention" message:[NSString stringWithFormat:@"Make this ticket a favorite first to create a reminder"] preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:notificationAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    [self.sortButton setImage:[UIImage systemImageNamed:@"arrow.up.arrow.down.square"] forState:UIControlStateNormal];
    self.sortButton.tag = 0;
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
