//
//  APIManager.h
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 22.01.2021.
//

#import <Foundation/Foundation.h>
#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
-(void)allNewsWithCompletion:(void (^)(NSArray *allNews))completion;

@end

NS_ASSUME_NONNULL_END
