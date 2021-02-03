//
//  CoreDataHelper.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 31.01.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Ticket.h"
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+(instancetype)sharedInstance;

-(NSArray *)favoriteTicketsFromFinder;
-(NSArray *)favoriteTicketsFromFinderReverse;
-(BOOL)isFavoriteTicket:(Ticket *)ticket;
-(void)addTicketToFavorites:(Ticket *)ticket;
-(void)removeTicketFromFavorites:(Ticket *)ticket;

-(NSArray *)favoriteMapPrices;
-(NSArray *)favoriteMapPricesReverse;
-(BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice;
-(void)addMapPriceToFavorites:(MapPrice *)mapPrice;
-(void)removeMapPriceFromFavorites:(MapPrice *)mapPrice;

@end

NS_ASSUME_NONNULL_END
