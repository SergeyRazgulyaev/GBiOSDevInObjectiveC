//
//  Aircraft.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import "Aircraft.h"

@implementation Aircraft

- (instancetype)initWithModelName:(NSString *)modelName aircraftCapacity:(NSString *)aircraftCapacity imageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.modelName = modelName;
        self.aircraftCapacity = aircraftCapacity;
        self.imageName = imageName;
    }
    return self;
}
@end
