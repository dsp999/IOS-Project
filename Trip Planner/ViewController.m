//
//  ViewController.m
//  Trip Planner
//
//  Created by Don Panditha on 13/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import "ViewController.h"
#import "routeViewController.h"
#import "placeViewController.h"
#import "Weather.h"

@interface ViewController ()

@end

@implementation ViewController
{
    Weather *theWeather;

}

@synthesize typeCity;
- (void)viewDidLoad
{
        [super viewDidLoad];
    
    theWeather = [[Weather alloc] init]; 
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"] ]];
    self.typeCity.delegate = self;
  
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([typeCity.text length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Destination cannot be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
[alert show];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"route"])
    {
        routeViewController *routeViewController = segue.destinationViewController;
    routeViewController.routeName = self.typeCity.text;
    }
else if([segue.identifier isEqualToString:@"place"])
{
    
    placeViewController *placeViewController = segue.destinationViewController;
    placeViewController.placeName = self.typeCity.text;
    

}
}

- (IBAction)weather:(id)sender {
    
    
    [theWeather ifreachable:typeCity.text];
    if ([theWeather.reach isEqual:@"NO"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No net work connection: Displaying stored data"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSString *report = [NSString stringWithFormat:
                        @"Weather in %@:\n"
                        @"%@\n"
                        @"Current temp.: %2.1f C\n"
                        @"High: %2.1f C\n"
                        @"Low: %2.1f C\n",
                        theWeather.city,
                        theWeather.conditions[0][@"description"],
                        theWeather.tempCurrent,
                        theWeather.tempMax,
                        theWeather.tempMin
                        ];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current Weather"
                                                    message:report
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
