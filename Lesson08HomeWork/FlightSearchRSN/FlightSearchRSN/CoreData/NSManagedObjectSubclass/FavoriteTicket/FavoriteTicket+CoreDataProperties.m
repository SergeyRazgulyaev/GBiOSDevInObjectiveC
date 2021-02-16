//
//  FavoriteTicket+CoreDataProperties.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 31.01.2021.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic airline;
@dynamic arrivalDate;
@dynamic created;
@dynamic departureDate;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic to;
@dynamic price;

@end
