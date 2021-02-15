//
//  FavoriteMapPrice+CoreDataProperties.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 02.02.2021.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic departureDate;
@dynamic destinationCode;
@dynamic destinationCoordLat;
@dynamic destinationCoordLon;
@dynamic destinationName;
@dynamic originCode;
@dynamic originCoordLat;
@dynamic originCoordLon;
@dynamic originName;
@dynamic priceValue;
@dynamic returnDate;

@end
