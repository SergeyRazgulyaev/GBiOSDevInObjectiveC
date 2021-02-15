//
//  TicketFromMapCell.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 02.02.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "MapPrice.h"
#import "FavoriteMapPrice+CoreDataClass.h"
#import "CoreDataHelper.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketFromMapCell : UITableViewCell

@property (nonatomic, strong) MapPrice *mapPrice;
@property (nonatomic, strong) FavoriteMapPrice *favoriteTicketFromMap;

-(UIImageView *)getAircraftImageView;

@end

NS_ASSUME_NONNULL_END
