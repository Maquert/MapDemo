//
//  MHJMapVC.m
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 29/05/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import "MHJMapVC.h"
#import "MHJMapUtils.h"

@interface MHJMapVC ()

// Core Location Properties
@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation MHJMapVC


typedef NS_ENUM(NSInteger, MapOptions)
{
    MapOptionsStandard = 0,
    MapOptionsSatellite,
    MapOptionsHybrid
};


#pragma mark - LifeCycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.map setDelegate:self];
    [self.manager startUpdatingLocation];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupMapView];
    [self addRefreshButton];
}

-(void) setupMapView
{
    CLLocation *defaultLocation = [self defaultLocation];
    [self setupMapWithLocation:defaultLocation];
    [self setupPinWithLocation:defaultLocation
                         title:@"Apple Store"
                   andSubtitle:@"Puerta del Sol"];
    [self setupRouteFromLocation:(CLLocation *) self.manager.location
                              to:(CLLocation *) defaultLocation];
}


#pragma mark - MapView

-(void) setupMapWithLocation:(CLLocation *) location
{
    // Coordinates
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = location.coordinate.latitude;
    locationCoordinate.longitude = location.coordinate.longitude;
    
    // Region
    MKCoordinateRegion region = [MHJMapUtils regionWithSpan:[self defaultSpan]
                                 andCenterCoordinate:locationCoordinate];
    
    // Setup Map
    [self.map setRegion:region
               animated:YES]; // Animates to the current region
    [self.map regionThatFits:region];
    [self.map setMapType:MKMapTypeHybrid];
}


-(void) setupPinWithLocation:(CLLocation *) location
                       title:(NSString *) title
                 andSubtitle:(NSString *) subtitle
{
    if (location) {
        CLLocationCoordinate2D pinCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:pinCoordinate];
        [annotation setTitle:title];
        [annotation setSubtitle:subtitle];
        
        [self.map addAnnotation:annotation];
    }
}


-(void) setupRouteFromLocation:(CLLocation *) source
                            to:(CLLocation *) destination
{
    MKDirectionsRequest *request = [MHJMapUtils routeRequestWithSource:source
                                                 andDestination:destination];
    NSLog(@"Routing \nFrom \n%@ \nTo \n%@", source, destination);
    
    [self routeWithRequest:request];
    
}





-(void) routeWithRequest:(MKDirectionsRequest *) request
{
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        
        if (error)
        {
            NSLog(@"Error with routes: %@", error.debugDescription);
        }
        else
        {
            MKRoute *route = response.routes[0];
            MKPolyline *line =  route.polyline;
            [self.map addOverlay:line];
            
            NSArray *steps = [route steps];
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }
    }];
}


-(void) setup3DView
{
    MKMapCamera* currentCamera  = self.map.camera;
    currentCamera.pitch = [@700 floatValue];
    [self.map setCamera:currentCamera animated:YES];
}




#pragma mark - Defaults

-(MKCoordinateSpan) defaultSpan
{
    MKCoordinateSpan span; // Space between two points. Visible area of the whole map
    NSNumber *spanNumber = @0.001;
    span.latitudeDelta = [spanNumber doubleValue];
    span.longitudeDelta = [spanNumber doubleValue];
    
    return span;
}


-(CLLocation *) defaultLocation
{
    // Apple Store - Puerta del Sol
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.4169163 longitude:-3.702427];
    return location;
}





#pragma mark - Properties

-(CLLocationManager *) manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}


-(void) titleForLocation:(CLLocation *) location
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             self.title = @"No location";
         }
         else
         {
             MKPlacemark *place = [placemarks lastObject];
             NSString *address = [NSString stringWithFormat:@"%@", place.locality];
             self.title = address;
         }
         
    }];
    
}








#pragma mark - Events

-(IBAction)mapButtonTapped:(UISegmentedControl *)segmentedButton
{
    switch (segmentedButton.selectedSegmentIndex) {
        case MapOptionsSatellite:
            [self.map setMapType:MKMapTypeSatellite];
            break;
        case MapOptionsHybrid:
            [self.map setMapType:MKMapTypeHybrid];
            break;
        default:
            [self.map setMapType:MKMapTypeStandard];
            break;
    }
}


-(IBAction)pinWasTapped:(id)sender
{
    [self setupRouteFromLocation:[self defaultLocation]
                              to:[self.manager location]];
}

-(void)refreshRoute:(id)sender
{
    MKDirectionsRequest *request = [MHJMapUtils routeRequestWithSource:[self defaultLocation] andDestination:self.lastLocation];
    
    MKCoordinateSpan span = [MHJMapUtils spanWithNumber:@10];
    MKCoordinateRegion region = [MHJMapUtils regionWithSpan:span andCenterCoordinate:[[self defaultLocation] coordinate]];
    
    [self.map setRegion:region animated:YES];
    
    [self routeWithRequest:request];
    
    [self titleForLocation:self.lastLocation];
}


#pragma mark - NavigationBar

-(void) addRefreshButton
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoute:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}


@end
