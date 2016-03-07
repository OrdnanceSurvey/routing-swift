# routing-swift
Client library for Ordnance Survey's [OS Routes API](https://apidocs.os.uk/docs/os-routes-overview) written in swift.

[![Circle CI](https://circleci.com/gh/OrdnanceSurvey/routing-swift.svg?style=svg)](https://circleci.com/gh/OrdnanceSurvey/routing-swift)
[![Coverage Status](https://coveralls.io/repos/github/OrdnanceSurvey/routing-swift/badge.svg?branch=master)](https://coveralls.io/github/OrdnanceSurvey/routing-swift?branch=master)

### Getting Started
You will need an API key from Ordnance Survey to use this sample.
```
printf "your-api-key" > APIKEY
```
Please ensure your APIKEY file doesn't have a trailing new line.

### Using in your own project
Easiest way to use this framework is using carthage. Add
```
github "OrdnanceSurvey/routing-swift"
```
to your Cartfile

### Routing.framework
The framework is usable from both Objective-C and from Swift. If using Objective-C, use [`OSRoutingService`](#osroutingservice). From Swift, use [`RoutingService`](#routingservice).

### Model
* `Route` is the object returned from a successful routing request, which includes metadata about the route, such as time and distance, as well as the points that make up the route and a list of instructions to follow.
* `Instruction` is an object that carries an instruction a user could use to follow the route.
* `Point` is a simple x,y coordinate object, agnostic of the spatial reference system being used.
* `BoundingBox` represents a bounding box for the route.

### `RoutingService`
This is the swift API for interfacing with the routes API. To initialise it, pass your API key, a vehicle type to use and the spatial reference system to use.
```swift
let routingService = RoutingService(apiKey: "api-key", vehicleType: .Car, crs: .BNG)
```
The spatial reference defaults to WGS:84, so you can ignore the last parameter if you wish.

The vehicle type requested decides which data source your request will use. `Car` and `EmergencyVehicle` use the road network to determine a route, `Foot` and `MountainBike` only provide routing on paths within the boundaries of the UK's national parks.

#### Fetching a route
To create a route, simply pass an array of `Point`s to the API and pass a completion handler.
```swift
let points = [
  Point(x: 1234, y: 2345),
  Point(x: 1234, y: 2346)
]
routingService.routeBetween(points: points) { result in
    switch result {
    case .Success(let route):
      displayRoute(route)
    case .Failure(let error):
      print("\(error)")
    }
}
```
There is also a convenience method that will take an array of `CLLocationCoordinate2D` structs, which is useful if using a WGS84 source of points.

### `OSRoutingService`
This is an Objective-C compatible wrapper around `RoutingService` which translates the use of Swift enums in to ObjC friendly types.
```objc
  OSRoutingService *routingService = [[OSRoutingService alloc] initWithApiKey:@"api-key" vehicleType:[OSRoutingService carVehicleType] crs:[OSRoutingService bngCRS]];
```

The values accepted by `OSRoutingService` for `vehicleType` and `crs` are available as class methods on `OSRoutingService`. Passing an unknown value to either of these parameters will result in a fatal error.

#### Fetching a route
To create a route, simply pass an array of `OSPoint`s to the API and pass a completion handler.
```objc
  NSArray<OSPoint *> *points = @[
    [[OSPoint alloc] initWithX:1234 y:2345],
    [[OSPoint alloc] initWithX:1234 y:2346]
  ];
  [routingService routeBetweenCoordinates:points completion:^(OSRoute *route, NSError *error) {
      if (error) {
          NSLog(@"%@", error);
          return;
      }
      [self displayRoute:route];
  }];
```
As with the swift version, there's a convenience method that will take an array of `CLLocationCoordinate2D`, but wrapped in `NSValue` objects. See `NSValue+Coordinate.h`.

### License
This framework is released under the [Apache 2.0 License](LICENSE)
