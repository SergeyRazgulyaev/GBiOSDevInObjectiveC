//
//  PlaceViewController.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 17.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PalceViewControllerDelegate <NSObject>

-(void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<PalceViewControllerDelegate>delegate;
-(instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
