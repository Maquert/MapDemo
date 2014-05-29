//
//  MHJMapVC.m
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 29/05/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import "MHJMapVC.h"


@interface MHJMapVC ()

// Core Location Properties
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation MHJMapVC



#pragma mark - LifeCycle

-(void) viewDidLoad
{
    [self.map setDelegate:self];
    [self.manager startUpdatingLocation];
}

-(void) viewWillAppear:(BOOL)animated
{
    CLLocation *defaultLocation = [self defaultLocation];
    [self setupMapWithLocation:defaultLocation];
    [self setupPinWithLocation:defaultLocation
                         title:@"Apple Store"
                   andSubtitle:@"Puerta del Sol"];
    
    [self setupRouteFromLocation:(CLLocation *) self.manager.location
                              to:(CLLocation *) defaultLocation];
}




#pragma mark - Utils

-(void) setupMapWithLocation:(CLLocation *) location
{
    // We set the coordinates by a CL object
    CLLocationCoordinate2D defaultLocation;
    defaultLocation.latitude = location.coordinate.latitude;
    defaultLocation.longitude = location.coordinate.longitude;
    
    // We set the parameters to the CoordinateRegion
    MKCoordinateRegion region; // Portion of a map to display
    region.center = defaultLocation;
    region.span = [self defaultSpan];
    
    // Init Map
    [self.map setRegion:region
               animated:YES]; // Moves to the current region
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
    else
    {
        NSLog(@"No valid location");
    }
}


-(void) setupRouteFromLocation:(CLLocation *) source
                            to:(CLLocation *) destination
{
    NSLog(@"Routing \nFrom \n%@ \nTo \n%@", source, destination);
    MKPlacemark *sourcePlace = [[MKPlacemark alloc] initWithCoordinate:source.coordinate addressDictionary:nil];
    MKPlacemark *destinationPlace = [[MKPlacemark alloc] initWithCoordinate:destination.coordinate addressDictionary:nil];
    
    MKMapItem *sourceItem = [[MKMapItem alloc] initWithPlacemark:sourcePlace];
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlace];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = sourceItem;
    request.destination = destinationItem;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // Code
        if (error) {
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
    // Apple Store Puerta del Sol
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




#pragma mark - Events

-(IBAction)mapButtonTapped:(UISegmentedControl *)segmentedButton
{
    switch (segmentedButton.selectedSegmentIndex) {
        case 1:
            [self.map setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [self.map setMapType:MKMapTypeHybrid];
            break;
        default:
            [self.map setMapType:MKMapTypeStandard];
            break;
    }
}


-(IBAction)pinWasTapped:(id)sender
{
    [self setupRouteFromLocation:[self defaultLocation] to:[self.manager location]];
}





#pragma mark - CoreLocation Delegate

-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    //NSLog(@"\n\nLocation update from CL to: %@", location);
    self.lastLocation = location;
}



#pragma mark - MapKit Delegate

-(void) mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"\n\nLocation update from MK to: %@", userLocation.location);
    //[self.map setCenterCoordinate:userLocation.location.coordinate animated:YES];
}


-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]
                                initWithAnnotation:annotation
                                reuseIdentifier:AnnotationIdentifier];
    
    // Customize Pin
    [pin setAnimatesDrop:YES];
    [pin setPinColor:MKPinAnnotationColorPurple];
    [pin setCanShowCallout:YES]; // Shows extra info
    
    // Image
    UIImageView *pinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    [pinImage setFrame:CGRectMake(0, 0, 30, 30)];
    [pin setLeftCalloutAccessoryView:pinImage];
    
    // Button
    UIButton *pinbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [pin setRightCalloutAccessoryView:pinbutton];
    [pinbutton addTarget:self
                  action:@selector(pinWasTapped:)
        forControlEvents:UIControlEventTouchUpInside];
    
    return pin;
}


- (MKOverlayView *) mapView:(MKMapView *)mapView
             viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}


@end
