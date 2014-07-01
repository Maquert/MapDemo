//
//  MHJMapUtils.h
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 01/07/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@import MapKit;

@interface MHJMapUtils : NSObject

+(MKDirectionsRequest *) routeRequestWithSource:(CLLocation *) source
                                 andDestination:(CLLocation *) destination;

+(MKCoordinateSpan) spanWithNumber:(NSNumber *) spanNumber;

+(MKCoordinateRegion) regionWithSpan:(MKCoordinateSpan) span
                 andCenterCoordinate:(CLLocationCoordinate2D) coordinate;

@end
