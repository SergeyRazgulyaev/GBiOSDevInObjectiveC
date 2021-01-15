//
//  DataManager.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 11.01.2021.
//

#import "DataManager.h"

@interface DataManager ()
@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;

@end

@implementation DataManager

+ (instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self.countriesArray = [self createObjectsFromArray: countriesJsonArray withType: DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self.citiesArray = [self createObjectsFromArray: citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self.airportsArray = [self createObjectsFromArray: airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName: kDataManagerLoadDataDidComplete object: nil];
        });
        NSLog(@"Data loading completed!");
    });
}

-(NSMutableArray *) createObjectsFromArray: (NSArray *) array withType: (DataSourceType) type {
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary *jsonObject in array) {
        if (type == DataSourceTypeCountry) {
            Country *country = [[Country alloc]initWithDictionary:jsonObject];
            [result addObject: country];
        } else if (type == DataSourceTypeCity) {
            City *city = [[City alloc]initWithDictionary:jsonObject];
            [result addObject: city];
        } else if (type == DataSourceTypeAirport) {
            Airport *airport = [[Airport alloc]initWithDictionary:jsonObject];
            [result addObject: airport];
        }
    }
    return result;
}

-(NSArray *)arrayFromFileName: (NSString *)filename ofType: (NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

-(NSArray *)countries {
    return self.countriesArray;
}

-(NSArray *)cities {
    return self.citiesArray;
}

-(NSArray *)airports {
    return self.airportsArray;
}

@end
