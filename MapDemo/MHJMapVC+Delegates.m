//
//  MHJMapVC+Delegates.m
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 01/07/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import "MHJMapVC+Delegates.h"

@implementation MHJMapVC (Delegates)



#pragma mark - CoreLocation Delegate

-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    //NSLog(@"\n\nLocation update from CL to: %@", location);
    self.lastLocation = location;
    [self titleForLocation:location];
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
