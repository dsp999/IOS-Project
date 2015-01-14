#import "Weather.h"
#import "AFNetworking.h"

@implementation Weather {
    NSDictionary *weatherServiceResponse;
    NSString *statusrep;
}


-(void)ifreachable:(NSString *)query
{

   
    AFHTTPClient *http= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];
    
    [http setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                // Not reachable
                _reach=@"NO";
                weatherServiceResponse = [self loadData];
                [self parseWeatherServiceResponse];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"Connected to the internet via WiFi");
                _reach=@"YES";
                [self getCurrent:query];

                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"Connected to the internet via WWAN");
                _reach=@"YES";
                [self getCurrent:query];
                
                break;
            }
            default:
                break;
        }
    }];


    
}



- (void)getCurrent:(NSString *)query
{
    
    //get the city name by splitting the string
    NSCharacterSet *separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [query componentsSeparatedByCharactersInSet:separators];
    NSString *nquery;
    if ([words count]>1) {
        nquery= [NSString stringWithFormat: @"%@%@%@", [words objectAtIndex:0], @"%20",[words objectAtIndex:1] ];
        nquery=[nquery stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else
    {
        nquery=query;
    }
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?q=%@",
                                BASE_URL_STRING, nquery];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];
    NSURLRequest *weatherRequest = [NSURLRequest requestWithURL:weatherURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
    
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:weatherRequest
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                    
                                                        [self saveData:JSON];
                                                        weatherServiceResponse = [self loadData];

                                                        [self parseWeatherServiceResponse];
                                                        
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        weatherServiceResponse = @{};
                                                        //user notification for errors
                                                    }
     ];
    
    [operation start];
}

-(void)saveData:(id)JSON
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filename = [documentsPath stringByAppendingPathComponent:@"weather.plist"];
    [JSON writeToFile:filename atomically:YES];

}

-(NSDictionary *)loadData
{

    BOOL success;
    NSDictionary * selectedObjectsDict;
    NSError *error;
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path =[[NSString alloc] initWithString:
                      [documentsDirectory stringByAppendingPathComponent:@"weather.plist"]];
    
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

- (void)parseWeatherServiceResponse
{
    // clouds
    _cloudCover = [weatherServiceResponse[@"clouds"][@"all"] integerValue];
    // coord
    _latitude = [weatherServiceResponse[@"coord"][@"lat"] doubleValue];
    _longitude = [weatherServiceResponse[@"coord"][@"lon"] doubleValue];
    
    // dt
    _reportTime = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"dt"] doubleValue]];
    
    // main
    _humidity = [weatherServiceResponse[@"main"][@"humidity"] integerValue];
    _pressure = [weatherServiceResponse[@"main"][@"pressure"] integerValue];
    _tempCurrent = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
    _tempMin = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_min"] doubleValue]];
    _tempMax = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_max"] doubleValue]];
    
    // name
    _city = weatherServiceResponse[@"name"];
    
    // rain
    _rain3hours = [weatherServiceResponse[@"rain"][@"3h"] integerValue];
    
    // snow
    _snow3hours = [weatherServiceResponse[@"snow"][@"3h"] integerValue];
    
    // sys
    _country = weatherServiceResponse[@"sys"][@"country"];    

    _sunrise = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunrise"] doubleValue]];
    _sunset = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunset"] doubleValue]];
    
    // weather
    _conditions = weatherServiceResponse[@"weather"];
    
    // wind
    _windDirection = [weatherServiceResponse[@"wind"][@"dir"] integerValue];
    _windSpeed = [weatherServiceResponse[@"wind"][@"speed"] doubleValue];
}

+ (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end
