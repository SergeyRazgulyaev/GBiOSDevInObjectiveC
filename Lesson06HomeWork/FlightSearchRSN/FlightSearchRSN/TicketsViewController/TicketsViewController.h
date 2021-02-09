//
//  TicketsViewController.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 28.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

//MARK: - Init
- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
