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
        self.title = NSLocalizedString(@"ticketsViewControllerTitle", "");
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
        NSString *messagePart1 = [NSString stringWithFormat:@"%@ - %@", notificationCell.ticket.from, notificationCell.ticket.to];
        NSString *messagePart2 = NSLocalizedString(@"notificationCellFor", "");
        NSString *messagePart3 = [NSString stringWithFormat:@"%@", notificationCell.ticket.price];
        NSString *messagePart4 = NSLocalizedString(@"notificationCellCurrencyUnit", "");
        NSString *message = [[[messagePart1 stringByAppendingString:messagePart2] stringByAppendingString:messagePart3] stringByAppendingString:messagePart4];
        
        NSURL *imageURL;
        
        Notification notification = NotificationMake(NSLocalizedString(@"notificationName", ""), message, self.datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        NSString *messageNotificationWillBeSentPart1 = [NSString stringWithFormat:NSLocalizedString(@"alertController1InTicketsVCMessage", "")];
        NSString *messageNotificationWillBeSentPart2 = [NSString stringWithFormat: @"%@", self.datePicker.date];
        NSString *messageNotificationWillBeSent = [messageNotificationWillBeSentPart1 stringByAppendingString:messageNotificationWillBeSentPart2];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertController1InTicketsVCTitle", "") message: messageNotificationWillBeSent preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alertController1InTicketsVCActionClose", "") style:UIAlertActionStyleCancel handler:nil];
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
        self.title = NSLocalizedString(@"favoritesViewControllerTitle", "");
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertController2InTicketsVCTitle", "") message:NSLocalizedString(@"alertController2InTicketsVCMessage", "") preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        if ([[CoreDataHelper sharedInstance] isFavoriteTicket: [self.tickets objectAtIndex:indexPath.row]]) {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"favoriteActionTitleDelete", "") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeTicketFromFavorites:[self.tickets objectAtIndex:indexPath.row]];
                [self.tableView reloadData];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"favoriteActionTitleAdd", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addTicketToFavorites:[self.tickets objectAtIndex:indexPath.row]];
                [self.tableView reloadData];
            }];
        }
        
        UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"notificationActionTitle", "") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if ([[CoreDataHelper sharedInstance] isFavoriteTicket: [self.tickets objectAtIndex:indexPath.row]]) {
                self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
                [self->_dateTextField becomeFirstResponder];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertController3InTicketsVCTitle", "") message:[NSString stringWithFormat:NSLocalizedString(@"alertController3InTicketsVCMessage", "")] preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alertController3InTicketsVCCancelAction", "") style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alertController3InTicketsVCCancelAction", "") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:notificationAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//MARK: - Segmented Control
- (void) configureFavoritesSegmentedControl {
    self.favoritesSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"favoritesSegmentedControlFinder", ""), NSLocalizedString(@"favoritesSegmentedControlMap", "")]];
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
