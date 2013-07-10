//
//  SDataGridSpeedCell.m
//  GridsWeatherDemo
//
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <QuartzCore/CoreAnimation.h>
#import "SDataGridSpeedCell.h"
#import "UIColor+CustomColors.h"

// WIND_SPEED_LIMIT is the highest wind speed that can be displayed on the gauge
#define WIND_SPEED_LIMIT 70


@implementation SDataGridSpeedCell{

    UIImageView *_speedometerImageView;
    UIView *_speedIndicator;
    UITextView *_speedTextView;
    
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {

        [self setClipsToBounds:YES];
                
        // Create UIViews to be resized to gauge the current wind speed level
        _speedIndicator = [[UIView alloc] init];
        [self addSubview:_speedIndicator];
        
        // Create UIImageView view to act as speed gauge
        _speedometerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rev.png"]];
        [_speedometerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_speedometerImageView];
        
        // Create UITextView to display the current wind speed level
        _speedTextView = [[UITextView alloc] init];
        [_speedTextView setBackgroundColor:[UIColor clearColor]];
        [_speedTextView setTextAlignment:NSTextAlignmentCenter];
        [_speedTextView setTextColor:[UIColor weatherDemoRed]];
        [_speedTextView setFont:[UIFont fontWithName:@"Digital-7" size:40]];
        [_speedTextView setEditable:NO];
        [self addSubview:_speedTextView];
                
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    // When the cell frame is set, update the frames of the UIViews it contains
    [_speedIndicator setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_speedometerImageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_speedTextView setFrame:CGRectMake(62, 34, 74, 50)];
    
    [self setSpeed:[_speedTextView text]];
}

// When the speed property is set, update the textview and speed indicator gauge that renders this value
-(void)setSpeed:(NSString*)newSpeed{
    
    [self setBackgroundColor:[UIColor backgroundColorGray]];
    
    [_speedIndicator setFrame:CGRectMake(3, 2, ([newSpeed floatValue] * ((self.bounds.size.width-10) / WIND_SPEED_LIMIT)), self.bounds.size.height-7)];
    

    if([newSpeed floatValue] <= (WIND_SPEED_LIMIT / 2)){ // Wind speeds less than or equal to 50% of WIND_SPEED_LIMIT make gauge green to indicate mild wind speed
        
        [_speedIndicator setBackgroundColor:[UIColor weatherDemoGreen]];
        
    }
    else if(([newSpeed floatValue] > (WIND_SPEED_LIMIT / 2)) && ([newSpeed floatValue] <= (WIND_SPEED_LIMIT * 0.9))){// Wind speeds above 50%% of WIND_SPEED_LIMIT and less than 90% of wind speed make gauge yellow to indicate moderate wind speed
        
        [_speedIndicator setBackgroundColor:[UIColor weatherDemoYellow]];
        
    }
    else{ // Wind speeds over 90% of max wind speed make gauge red to indicate high wind speed.
        
        [_speedIndicator setBackgroundColor:[UIColor weatherDemoRed]];
    
    }
    
    [_speedometerImageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [_speedTextView setText:[NSString stringWithFormat:@"%d", [newSpeed intValue]]];
    
}

@end
