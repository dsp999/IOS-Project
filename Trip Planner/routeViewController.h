//
//  routeViewController.h
//  Trip Planner
//
//  Created by Don Panditha on 15/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface routeViewController : UIViewController <MKMapViewDelegate ,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UITextView *steps;
- (IBAction)getRoute:(id)sender;
- (IBAction)zoom:(id)sender;

@property (weak, nonatomic) NSString *allSteps;

@property (nonatomic, strong) NSString *routeName;
@end
