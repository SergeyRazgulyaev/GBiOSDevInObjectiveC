//
//  MapViewController.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 24.01.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreDataHelper.h"

@interface MapViewController ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) MKPointAnnotation *theRedSquareAnnotation;
@end

@implementation MapViewController

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMapView];
    [self configureDataManager];
    [self configureNotificationCenter];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: - Data Manager
- (void)configureDataManager {
    [[DataManager sharedInstance] loadData];
}

//MARK: - Notification Center
- (void) configureNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dataLoadedSuccessfully {
    self.locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation: (NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [self.mapView setRegion:region animated:YES];
    
    if (currentLocation) {
        self.origin = [[DataManager sharedInstance] cityForLocation: currentLocation];
        if (self.origin) {
            [[APIManager sharedInstance] mapPricesFor: self.origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

//MARK: - MapView
- (void) configureMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.title = @"Map";
    self.mapView.showsUserLocation = YES;
    [self.view addSubview: self.mapView];
    [self.mapView setDelegate:self];
}

//MARK: - Prices
-(void)setPrices:(NSArray *)prices {
    _prices = prices;
    [self.mapView removeAnnotations:self.mapView.annotations];

    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = price.destination.coordinate;
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld rub.", (long)price.value];
            [self.mapView addAnnotation:annotation];
        });
    }
    [self configureTheRedSquareAnnotation];
}

//MARK: - Annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        UIButton *onAnnotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        onAnnotationButton.frame = CGRectMake(0, 0, 20, 20);
        [onAnnotationButton setImage:[UIImage systemImageNamed:@"star.fill"] forState:UIControlStateNormal];
        onAnnotationButton.tintColor = [UIColor lightGrayColor];
        annotationView.rightCalloutAccessoryView = onAnnotationButton;
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (MapPrice *price in self.prices) {
        if (view.annotation.coordinate.latitude == price.destination.coordinate.latitude && view.annotation.coordinate.longitude == price.destination.coordinate.longitude) {
            if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice:price]) {
                view.rightCalloutAccessoryView.tintColor = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    for (MapPrice *price in self.prices) {
        if (view.annotation.coordinate.latitude == price.destination.coordinate.latitude && view.annotation.coordinate.longitude == price.destination.coordinate.longitude) {
            if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice:price]) {
                [[CoreDataHelper sharedInstance] removeMapPriceFromFavorites:price];
                control.tintColor = [UIColor lightGrayColor];
                break;
            } else {
                [[CoreDataHelper sharedInstance] addMapPriceToFavorites:price];
                control.tintColor = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];
                break;
            }
        }
    }
}

//TheRedSquareAnnotation
- (void) configureTheRedSquareAnnotation {
    self.theRedSquareAnnotation = [[MKPointAnnotation alloc] init];
    self.theRedSquareAnnotation.coordinate = CLLocationCoordinate2DMake(55.753978581590445, 37.62080572697412);
    CLLocation *theRedSquareLocation = [[CLLocation alloc] initWithLatitude:55.753978581590445 longitude:37.62080572697412];
    [self theRedSquareAnnotationWithAddressFromLocation:theRedSquareLocation];
    [self.mapView addAnnotation:self.theRedSquareAnnotation];
}

- (void)theRedSquareAnnotationWithAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                self.theRedSquareAnnotation.title = ((void)(@"%@"), placemark.locality);
                self.theRedSquareAnnotation.subtitle = ((void)(@"%@"), placemark.name);
            }
        }
    }];
}

//MARK: - Address From Location
- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"%@", placemark.locality);
                NSLog(@"%@", placemark.name);
            }
        }
    }];
}

//MARK: - Location From Address
- (void)locationFromAddress:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"%@", placemark.location);
            }
        }
    }];
}

@end
