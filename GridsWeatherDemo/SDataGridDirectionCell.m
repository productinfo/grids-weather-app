//
//  SDataGridDirectionCell.m
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

#import "SDataGridDirectionCell.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+CustomColors.h"

@implementation SDataGridDirectionCell{

    UITextView *_windDirectionTextView;
    UIImageView *_upArrowImageView;
    
}

static NSArray *_windDirection;

+(NSArray*)_windDirection
{
    if (!_windDirection)
         _windDirection = @[@"N", @"NNE", @"NE", @"ENE", @"E", @"ESE", @"SE", @"SSE", @"S", @"SSW", @"SW", @"WSW", @"W", @"WNW", @"NW", @"NNW", @"N"];
    
    return _windDirection;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
                
        // Create UITextView to display the weather
        _windDirectionTextView = [UITextView new];
        [_windDirectionTextView setBackgroundColor:[UIColor clearColor]];
        [_windDirectionTextView setTextAlignment:NSTextAlignmentRight];
        [_windDirectionTextView setTextColor:[UIColor blackColor]];
        [_windDirectionTextView setFont:[UIFont fontWithName:@"Helvetica" size:25]];
        [_windDirectionTextView setEditable:NO];
        [_windDirectionTextView setTextColor:[UIColor textColor]];
        [self addSubview:_windDirectionTextView];
        
        // Initialise wind direction image 
        UIImage *upArrowImage = [UIImage imageNamed:@"green_up_arrow.png"];
        
        // Create UIImageView view to act as wind direction arrow
        _upArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(94, 16, 60, 60)];
        [_upArrowImageView setImage:upArrowImage];
        _upArrowImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self addSubview:_upArrowImageView];

    } 
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // When the cell frame is set, update the frames of the UIViews it contains    
    [_windDirectionTextView setFrame:CGRectMake(-3, (self.bounds.size.height * 0.25), 90, (self.bounds.size.height/2))];
}

// When the direction property is set, updates the wind direction arrow that changes direction based upon this value
-(void)setDirection:(NSString*)newDirection{
      
    [_windDirectionTextView setText:[SDataGridDirectionCell _windDirection][(int)round(([newDirection floatValue] / 22.5))]];
    
    // When the direction property is set, updates the wind direction arrow that changes direction based upon this value
    _upArrowImageView.transform = CGAffineTransformRotate(_upArrowImageView.transform, ([newDirection floatValue] - [_oldDirection floatValue]) * (M_PI / 180.0));
        
    _oldDirection = newDirection;
        
}

@end
