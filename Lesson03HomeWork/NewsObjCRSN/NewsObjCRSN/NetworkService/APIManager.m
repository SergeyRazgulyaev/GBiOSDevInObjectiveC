//
//  APIManager.m
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 22.01.2021.
//

#import "APIManager.h"

#define API_TOKEN @"4823bfe9152442baafde686452ac56d6"
#define API_URL_NEWSAPI @"https://newsapi.org/v2/top-headlines?country=us"

@implementation APIManager

+ (instancetype)sharedInstance {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIManager alloc] init];
    });
    return instance;
}

- (void)allNewsWithCompletion:(void (^)(NSArray *allNews))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@&apiKey=%@", API_URL_NEWSAPI, API_TOKEN];
    [self load:urlString withCompletion:^(id  _Nullable result) {
        NSDictionary *response = [result valueForKey:@"articles"];
        if (response) {
            NSDictionary *json = response;
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *oneNewsElement in json) {
                News *news = [[News alloc] initWithDictionary:oneNewsElement];
                [array addObject:news];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array);
            });
        }
    }];
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
        }
    }] resume] ;
}

@end
