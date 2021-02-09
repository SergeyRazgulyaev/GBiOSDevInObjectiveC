//
//  FavoriteTicket+CoreDataProperties.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 31.01.2021.
//
//

#import "FavoriteTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *arrivalDate;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departureDate;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nonatomic) int16_t flightNumber;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) int64_t price;
//@property (nonatomic) BOOL isInFavorite;
@property (nonatomic) BOOL addedToFavoritesFromMap;

@end

NS_ASSUME_NONNULL_END
