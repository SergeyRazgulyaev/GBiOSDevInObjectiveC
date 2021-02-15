//
//  CoreDataHelper.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 31.01.2021.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance {
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

-(void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    self.managedObjectModel =[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    
    NSPersistentStore *store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

-(void)save {
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

//MARK: - Tickets
- (NSArray *)favoriteTicketsFromFinder {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"departureDate" ascending:YES]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (NSArray *)favoriteTicketsFromFinderReverse {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"departureDate" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (BOOL)isFavoriteTicket:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departureDate == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departureDate, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (FavoriteTicket *)remindedTicket:(Ticket *)remindedTicket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND from == %@ AND to == %@", (long)remindedTicket.price.integerValue, remindedTicket.from, remindedTicket.to];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (void)addTicketToFavorites:(Ticket *)ticket {
    if ([self isFavoriteTicket:ticket]) {
        NSLog(@"Ticket is in Favorites");
    } else {
        NSLog(@"Ticket is not in Favorites");
        FavoriteTicket *favoriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
        favoriteTicket.price = ticket.price.intValue;
        favoriteTicket.airline = ticket.airline;
        favoriteTicket.departureDate = ticket.departureDate;
        favoriteTicket.expires = ticket.expires;
        favoriteTicket.flightNumber = ticket.flightNumber.intValue;
        favoriteTicket.arrivalDate = ticket.arrivalDate;
        favoriteTicket.from = ticket.from;
        favoriteTicket.to = ticket.to;
        favoriteTicket.created = [NSDate date];
        
        [self save];
    }
}

- (void)removeTicketFromFavorites:(Ticket *)ticket {
    FavoriteTicket *favoriteTicket = [self favoriteFromTicket:ticket];
    if (favoriteTicket) {
        [_managedObjectContext deleteObject:favoriteTicket];
        [self save];
    }
}

//MARK: - MapPrices
-(NSArray *)favoriteMapPrices {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"departureDate" ascending:YES]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

-(NSArray *)favoriteMapPricesReverse {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"departureDate" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

-(BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice {
    return [self favoriteFromMapPrice:mapPrice] != nil;
}

- (FavoriteMapPrice *)favoriteFromMapPrice:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.predicate = [NSPredicate predicateWithFormat: @"departureDate == %@ AND destinationCode == %@ AND destinationCoordLat == %f AND destinationCoordLon == %f AND destinationName == %@ AND originCode == %@ AND originCoordLat == %f AND originCoordLon == %f AND originName == %@ AND priceValue == %ld AND  returnDate == %@", mapPrice.departureDate, mapPrice.destination.code, mapPrice.destination.coordinate.latitude, mapPrice.destination.coordinate.longitude, mapPrice.destination.name, mapPrice.origin.code, mapPrice.origin.coordinate.latitude, mapPrice.origin.coordinate.longitude, mapPrice.origin.name, (long)mapPrice.value, mapPrice.returnDate];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

-(void)addMapPriceToFavorites:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteMapPrice" inManagedObjectContext:_managedObjectContext];
    favoriteMapPrice.departureDate = mapPrice.departureDate;
    favoriteMapPrice.destinationCode = mapPrice.destination.code;
    favoriteMapPrice.destinationCoordLat = mapPrice.destination.coordinate.latitude;
    favoriteMapPrice.destinationCoordLon = mapPrice.destination.coordinate.longitude;
    favoriteMapPrice.destinationName = mapPrice.destination.name;
    favoriteMapPrice.originCode = mapPrice.origin.code;
    favoriteMapPrice.originCoordLat = mapPrice.origin.coordinate.latitude;
    favoriteMapPrice.originCoordLon = mapPrice.origin.coordinate.longitude;
    favoriteMapPrice.originName = mapPrice.origin.name;
    favoriteMapPrice.priceValue = mapPrice.value;
    favoriteMapPrice.returnDate = mapPrice.returnDate;
    
    [self save];
}

-(void)removeMapPriceFromFavorites:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [self favoriteFromMapPrice:mapPrice];
    if (favoriteMapPrice) {
        [_managedObjectContext deleteObject:favoriteMapPrice];
        [self save];
    }
}

@end
