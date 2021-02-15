//
//  AircraftFleetCell.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 27.01.2021.
//

#import "AircraftFleetCell.h"

@implementation AircraftFleetCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.aircraftModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height - 95), (frame.size.width - 20), 20.0)];
        self.aircraftModelLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.aircraftModelLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.aircraftModelLabel];
        
        self.aircraftCapacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height - 75), (frame.size.width - 20), 20.0)];
        self.aircraftCapacityLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.aircraftCapacityLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.aircraftCapacityLabel];
        
        self.aircraftImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, (frame.size.height - 100))];
        self.aircraftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.aircraftImageView];
        
        self.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    return self;
}

@end
