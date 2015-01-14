//
//  Weather.h
//  Trip Planner
//
//  Created by Don Panditha on 15/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define BASE_URL_STRING@"http://api.openweathermap.org/data/2.5/weather"

@interface Weather : NSObject

// Properties
// ==========

// Place and time
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, copy, readonly) NSDate *reportTime;
@property (nonatomic, copy, readonly) NSDate *sunrise;
@property (nonatomic, copy, readonly) NSDate *sunset;

// Qualitative
@property (nonatomic, copy, readonly) NSArray *conditions;

// Quantitative
@property (nonatomic, readonly) NSInteger cloudCover;
@property (nonatomic, readonly) NSInteger humidity;
@property (nonatomic, readonly) NSInteger pressure;
@property (nonatomic, readonly) NSInteger rain3hours;
@property (nonatomic, readonly) NSInteger snow3hours;
@property (nonatomic, readonly) CGFloat tempCurrent;
@property (nonatomic, readonly) CGFloat tempMin;
@property (nonatomic, readonly) CGFloat tempMax;
@property (nonatomic, readonly) NSInteger windDirection;
@property (nonatomic, readonly) CGFloat windSpeed;

//other
@property (nonatomic, copy, readonly) NSString *reach;

// Methods
// =======

- (void)ifreachable:(NSString *)query;

@end
