//
//  Aircraft.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Aircraft : NSObject
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *aircraftCapacity;
@property (nonatomic, strong) NSString *imageName;

- (instancetype) initWithModelName: (NSString *)modelName
                  aircraftCapacity: (NSString *)aircraftCapacity
                         imageName: (NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
