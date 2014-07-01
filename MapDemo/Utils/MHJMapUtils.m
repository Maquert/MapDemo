//
//  MHJMapUtils.m
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 01/07/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import "MHJMapUtils.h"


@implementation MHJMapUtils

#pragma mark - Init

+(instancetype) mapUtils
{
    return [[self alloc] init];
}



#pragma mark - Utils

+(MKDirectionsRequest *) routeRequestWithSource:(CLLocation *) source
                                 andDestination:(CLLocation *) destination
{
    MKPlacemark *sourcePlace = [[MKPlacemark alloc] initWithCoordinate:source.coordinate addressDictionary:nil];
    MKPlacemark *destinationPlace = [[MKPlacemark alloc] initWithCoordinate:destination.coordinate
                                                          addressDictionary:nil];
    
    MKMapItem *sourceItem = [[MKMapItem alloc] initWithPlacemark:sourcePlace];
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlace];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = sourceItem;
    request.destination = destinationItem;
    
    return request;
}



+(MKCoordinateSpan) spanWithNumber:(NSNumber *) spanNumber
{
    MKCoordinateSpan span; // Space between two points. Visible area of the whole map
    span.latitudeDelta = [spanNumber doubleValue];
    span.longitudeDelta = [spanNumber doubleValue];
    
    return span;
}

+(MKCoordinateRegion) regionWithSpan:(MKCoordinateSpan) span
                 andCenterCoordinate:(CLLocationCoordinate2D) coordinate
{
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    
    return region;
}



@end
