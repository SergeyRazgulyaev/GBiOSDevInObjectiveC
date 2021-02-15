//
//  MapPrice.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 25.01.2021.
//

#import "MapPrice.h"
#import "DataManager.h"

@implementation MapPrice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin {
    self = [super init];
    if (self) {
        self.destination = [[DataManager sharedInstance] cityForIATA:[dictionary valueForKey:@"destination"]];
        self.origin = origin;
        self.departureDate = [self dateFromString: [dictionary valueForKey:@"depart_date"]];
        self.returnDate = [self dateFromString: [dictionary valueForKey:@"return_date"]];
        self.numberOfChanges = [[dictionary valueForKey:@"number_of_changes"] integerValue];
        self.value = [[dictionary valueForKey:@"value"] integerValue];
        self.dictance = [[dictionary valueForKey:@"dictance"] integerValue];
        self.actual = [[dictionary valueForKey:@"actual"] integerValue];
    }
    return self;
}

-(NSDate * _Nullable)dateFromString: (NSString *)dateString {
    if (!dateString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString: dateString];
}

@end
