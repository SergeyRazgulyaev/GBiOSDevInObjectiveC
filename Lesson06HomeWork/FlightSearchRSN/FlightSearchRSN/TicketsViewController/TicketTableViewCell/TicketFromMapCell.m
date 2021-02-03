//
//  TicketFromMapCell.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 02.02.2021.
//

#import "TicketFromMapCell.h"

@interface TicketFromMapCell()
@property (nonatomic, strong) UIImageView *aircraftImageView;
@property (nonatomic, strong) UIImageView *favoriteStarImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TicketFromMapCell

//MARK: - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:self.priceLabel];
        
        self.aircraftImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.aircraftImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.aircraftImageView.image = [UIImage systemImageNamed:@"airplane.circle"];
        self.aircraftImageView.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.aircraftImageView];
        
        self.favoriteStarImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.favoriteStarImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.favoriteStarImageView.image = [UIImage systemImageNamed:@"star.fill"];
        self.favoriteStarImageView.tintColor = [UIColor whiteColor];
        [self.contentView addSubview:self.favoriteStarImageView];
        
        self.placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        self.placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.placesLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:self.dateLabel];
    }
    
    return self;
}

//MARK: - Layout Subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    self.priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 145.0, 40.0);
    self.aircraftImageView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10.0, 10.0, 110.0, 110.0);
    self.favoriteStarImageView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 100, 10.0, 20.0, 20.0);
    self.placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLabel.frame) + 16.0, 100.0, 20.0);
    self.dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setMapPrice:(MapPrice *)mapPrice {
    _mapPrice = mapPrice;
    
    _priceLabel.text = [NSString stringWithFormat:@"%ld rub.", (long)mapPrice.value];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", mapPrice.destination.code, mapPrice.origin.code];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:mapPrice.departureDate];
    
    if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice:_mapPrice]) {
        _favoriteStarImageView.tintColor = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];
    };
}

- (void)setFavoriteTicketFromMap:(FavoriteMapPrice *)favoriteTicketFromMap {
    _favoriteTicketFromMap = favoriteTicketFromMap;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld rub.", _favoriteTicketFromMap.priceValue];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", _favoriteTicketFromMap.originCode, _favoriteTicketFromMap.destinationCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:_favoriteTicketFromMap.departureDate];
    _favoriteStarImageView.tintColor = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];
}

@end
