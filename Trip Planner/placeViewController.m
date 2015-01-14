//
//  placeViewController.m
//  Trip Planner
//
//  Created by Don Panditha on 15/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import "placeViewController.h"
#import "displayViewController.h"
#import "AFNetworking.h"


@interface placeViewController ()
{
    CLPlacemark *thePlacemark;
    float latitude, longitude;
    NSDictionary *placeServiceResponse;
    NSArray *allplace;
    NSString *pltype;
    

}
@end

@implementation placeViewController
@synthesize placeName;
@synthesize type;
@synthesize places;
@synthesize googlePlaces;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"] ]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"] ]];
    
        [self addressSearch:placeName];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)addressSearch:(NSString *)sender
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:sender completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The operation couldn’t be completed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            placeServiceResponse = [self loadData];
            places = [placeServiceResponse objectForKey:@"results"];
            
            [self.tableView reloadData];


            
        } else {
            thePlacemark = [placemarks lastObject];
            
          latitude = thePlacemark.location.coordinate.latitude;
            longitude = thePlacemark.location.coordinate.longitude;
            
            [self makeRestuarantRequests:latitude :longitude];
           
        }
    }];
    
}


//get information from url
-(void)makeRestuarantRequests:(float)lat:(float)lon
{
    
    NSString *placeurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=500&sensor=true&key=%@", lat, lon, kGOOGLE_API_KEY];
    
    NSURL *url=[NSURL URLWithString:placeurl ];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.0];
    //AFNetworking asynchronous url request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
                                         {
                                             [self saveData:responseObject];
                                             placeServiceResponse = [self loadData];
                                             places = [placeServiceResponse objectForKey:@"results"];
                                            
                                             [self.tableView reloadData];
                                             
                                             
                                             
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject)
                                         {
                                             NSLog(@"Request Failed: %@, %@", error, error.userInfo);
                                         }];
  
    [operation start];
    
}


//save data to file
-(void)saveData:(id)JSON
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filename = [documentsPath stringByAppendingPathComponent:@"place.plist"];
    [JSON writeToFile:filename atomically:YES];
    
}


//load data from file
-(NSDictionary *)loadData
{
    
    BOOL success;
    NSDictionary * selectedObjectsDict;
    NSError *error;
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"place" ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:
                      [documentsDirectory stringByAppendingPathComponent:@"place.plist"]];
    
    success = [fileManager fileExistsAtPath:path];
    if (success) {
        selectedObjectsDict=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else
    {
        
        success = [fileManager copyItemAtPath:filePath  toPath:path error:&error];
        selectedObjectsDict=[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        
    }
    
    return selectedObjectsDict;
    
}

//set the table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. NSLog(@"%lu", (unsigned long)[places count]);
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSDictionary *tempDictionary= [self.places objectAtIndex:indexPath.row];
    
    
    NSString *name=[tempDictionary objectForKey:@"name"];
    
    
     cell.textLabel.text = name;
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        displayViewController *destViewController = segue.destinationViewController;
        destViewController.tempDictionary = [self.places objectAtIndex:indexPath.row];
    }
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    NSLog(@"ERROR %@", error);
}

@end
