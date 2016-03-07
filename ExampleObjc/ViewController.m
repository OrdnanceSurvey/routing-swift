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
}

@end
