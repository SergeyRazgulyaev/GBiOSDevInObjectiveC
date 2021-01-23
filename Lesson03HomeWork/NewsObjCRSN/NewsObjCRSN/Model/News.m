//
//  News.m
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 21.01.2021.
//

#import "News.h"

@implementation News
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.author = [dictionary valueForKey:@"author"];
        self.content = [dictionary valueForKey:@"content"];
        self.newsDescription = [dictionary valueForKey:@"description"];
        self.publishedAt = [dictionary valueForKey:@"publishedAt"];
        self.source = [dictionary valueForKey:@"source"];
        self.title = [dictionary valueForKey:@"title"];
        self.url = [dictionary valueForKey:@"url"];
        self.urlToImage = [dictionary valueForKey:@"urlToImage"];
    }
    return self;
}

@end
