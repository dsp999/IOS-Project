#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define kGOOGLE_API_KEY @"AIzaSyBCvgCLmoU0k2Dw5lYk8bNVtjt-G1vSv18"

@interface displayViewController : UIViewController<MKMapViewDelegate>
{
    MKMapView *mapView;
    
}
-(void)setCoords:(NSString*)cord;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *tempDictionary;



@end
