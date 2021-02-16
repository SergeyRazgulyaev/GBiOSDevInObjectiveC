//
//  AircraftFleetViewController.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 26.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AircraftFleetViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
