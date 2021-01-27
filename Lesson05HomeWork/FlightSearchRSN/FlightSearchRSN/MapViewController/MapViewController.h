//
//  MapViewController.h
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 24.01.2021.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <MKMapViewDelegate>
- (void)addressFromLocation:(CLLocation *)location;
- (void)locationFromAddress:(NSString *)address;
- (void)theRedSquareAnnotationWithAddressFromLocation:(CLLocation *)location;
@end

NS_ASSUME_NONNULL_END
