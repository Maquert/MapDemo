//
//  MHJMapVC.h
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 29/05/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;

@interface MHJMapVC : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


// Properties
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocation *lastLocation;


// Methods
-(void) titleForLocation:(CLLocation *) location;
-(void) routeWithRequest:(MKDirectionsRequest *) request;

-(CLLocation *) defaultLocation;
-(MKCoordinateSpan) defaultSpan;


// Events
-(IBAction)mapButtonTapped:(UISegmentedControl *)segmentedButton;
-(IBAction)pinWasTapped:(id)sender;


@end
