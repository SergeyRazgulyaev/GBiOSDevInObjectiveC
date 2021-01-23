//
//  Source.h
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 22.01.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Source : NSObject

@property (nonatomic, strong) NSString *sourceID;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
