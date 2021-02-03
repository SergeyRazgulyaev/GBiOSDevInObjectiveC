//
//  TravelDestinationsCell.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 18.01.2021.
//

#import "TravelDestinationsCell.h"

@implementation TravelDestinationsCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.countryName = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width - 90, 44.0)];
        self.countryName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.countryName];
        
        self.countryCode = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70.0, 0.0, 70.0, 44.0)];
        self.countryCode.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.countryCode];
    }
    return self;
}

@end
