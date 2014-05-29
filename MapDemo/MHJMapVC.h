//
//  MHJMapVC.h
//  MapDemo
//
//  Created by Miguel Hernández Jaso on 29/05/14.
//  Copyright (c) 2014 Miguel Hernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;
@import CoreLocation;

@interface MHJMapVC : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


// Properties
@property (weak, nonatomic) IBOutlet MKMapView *map;


// Events

-(IBAction)mapButtonTapped:(UISegmentedControl *)segmentedButton;


@end
