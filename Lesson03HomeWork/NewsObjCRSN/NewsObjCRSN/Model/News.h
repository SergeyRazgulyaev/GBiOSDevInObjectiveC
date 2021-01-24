//
//  News.h
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 21.01.2021.
//

#import <Foundation/Foundation.h>
#import "Source.h"

NS_ASSUME_NONNULL_BEGIN

@interface News : NSObject
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *newsDescription;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, strong) Source *source;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *urlToImage;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
