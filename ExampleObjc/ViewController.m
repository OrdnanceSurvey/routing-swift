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
    OSPoint *point = [[OSPoint alloc] initWithX:touchCoordinate.latitude y:touchCoordinate.longitude];
    [self.tappedPoints addObject:point];
}

@end
