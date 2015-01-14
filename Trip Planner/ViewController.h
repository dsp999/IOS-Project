//
//  ViewController.h
//  Trip Planner
//
//  Created by Don Panditha on 13/11/2013.
//  Copyright (c) 2013 Don Panditha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *typeCity;
- (IBAction)weather:(id)sender;



@end
