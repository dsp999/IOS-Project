#import "displayViewController.h"
#import "AFNetworking.h"

@interface displayViewController ()
{
    UIImage *plimage;
}
@end

@implementation displayViewController

@synthesize mapView;
@synthesize name;
@synthesize tempDictionary;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"] ]];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    

 
}

- (void)mapView:(MKMapView *)mapViews didUpdateUserLocation:(MKUserLocation *)userLocation
{
        
   
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =[[[[tempDictionary objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lat"]  doubleValue];
    zoomLocation.longitude=[[[[tempDictionary objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lng"]  doubleValue];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(zoomLocation, 800, 800);
    MKCoordinateRegion adjustedRegion = [mapViews regionThatFits:region];
    [mapView setRegion:adjustedRegion animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = zoomLocation;
    
    point.title=[tempDictionary objectForKey:@"name"];
    point.subtitle=[tempDictionary   objectForKey:@"vicinity"] ;
    
    
    [self.mapView addAnnotation:point];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end