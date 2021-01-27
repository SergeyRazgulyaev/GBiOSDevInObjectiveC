//
//  AircraftFleetCell.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 27.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AircraftFleetCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *aircraftModelLabel;
@property (nonatomic, strong) UILabel *aircraftCapacityLabel;
@property (nonatomic, strong) UIImageView *aircraftImageView;

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
