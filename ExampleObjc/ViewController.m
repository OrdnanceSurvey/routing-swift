//
//  ViewController.m
//  ExampleObjc
//
//  Created by Dave Hardiman on 07/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "ViewController.h"
@import Routing;
@import MapKit;

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) OSRoutingService *routingService;
@property (strong, nonatomic) NSMutableArray *tappedPoints;
@end

@implementation ViewController

- (NSString *)apiKey {
    return [NSString stringWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"APIKEY" withExtension:nil]
                                    encoding:NSUTF8StringEncoding
                                       error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routingService = [[OSRoutingService alloc] initWithApiKey:self.apiKey vehicleType:[OSRoutingService carVehicleType] crs:nil];
    self.mapView.delegate = self;
    self.tappedPoints = NSMutableArray.array;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    [self.mapView addGestureRecognizer:tap];
}

#pragma mark - Map Tapped
- (void)mapTapped:(UITapGestureRecognizer *)tap {
    if (tap.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint touchPoint = [tap locationInView:self.mapView];
    CLLocationCoordinate2D touchCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchCoordinate;
    [self.mapView addAnnotation:pointAnnotation];
    [self.tappedPoints addObject:[NSValue os_valueWithCoordinate:touchCoordinate]];
    [self updateRoute];
}

- (void)updateRoute {
    [self.routingService routeBetweenCoordinates:self.tappedPoints completion:^(OSRoute *_Nullable route, NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        [self displayRoute:route];
    }];
}

- (void)displayRoute:(OSRoute *)route {
    NSArray *coordinateValues = route.coordinateValues;
    NSInteger numberOfPoints = coordinateValues.count;
    CLLocationCoordinate2D coordinates[numberOfPoints];
    for (NSInteger idx = 0; idx < numberOfPoints; idx++) {
        coordinates[idx] = [coordinateValues[idx] os_coordinateValue];
    }
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coordinates count:numberOfPoints];
    [self.mapView addOverlay:line];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor purpleColor];
    renderer.lineWidth = 3;
    return renderer;
}

#pragma mark - Clear
- (IBAction)clear:(id)sender {
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mapView removeAnnotation:obj];
    }];
    [self.mapView.overlays enumerateObjectsUsingBlock:^(id<MKOverlay>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mapView removeOverlay:obj];
    }];
    [self.tappedPoints removeAllObjects];
}


@end
