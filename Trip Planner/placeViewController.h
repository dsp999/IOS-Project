//
//  placeViewController.h
//  Trip Planner
//
//  Created by Don Panditha on 15/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>



#define kGOOGLE_API_KEY @"AIzaSyBCvgCLmoU0k2Dw5lYk8bNVtjt-G1vSv18"


@interface placeViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *places;
@property (strong, nonatomic) NSArray *googlePlaces;
@property (nonatomic, strong) NSString *reach;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
