//
//  FavoriteMapPrice+CoreDataProperties.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 02.02.2021.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *departureDate;
@property (nullable, nonatomic, copy) NSString *destinationCode;
@property (nonatomic) float destinationCoordLat;
@property (nonatomic) float destinationCoordLon;
@property (nullable, nonatomic, copy) NSString *destinationName;
@property (nullable, nonatomic, copy) NSString *originCode;
@property (nonatomic) float originCoordLat;
@property (nonatomic) float originCoordLon;
@property (nullable, nonatomic, copy) NSString *originName;
@property (nonatomic) int64_t priceValue;
@property (nullable, nonatomic, copy) NSDate *returnDate;

@end

NS_ASSUME_NONNULL_END
