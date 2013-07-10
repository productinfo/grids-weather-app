//
//  SDataGridHighLowCell.m
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

#import "SDataGridHighLowCell.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+CustomColors.h"

#define TEXTVIEW_WIDTH 170
#define IMAGE_WIDTH_AND_HEIGHT 30

@implementation SDataGridHighLowCell{
        
    UIImageView *_backgroundImageView;
    
    UIImageView *_highTempArrowImageView;
    UITextView *_highTempTextView;

    UIImageView *_lowTempArrowImageView;
    UITextView *_lowTempTextView;
    
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
                                
        // Create UITextView to display high temperature for the day
        _highTempTextView = [[UITextView alloc] init];
        [_highTempTextView setBackgroundColor:[UIColor clearColor]];
        [_highTempTextView setTextAlignment:NSTextAlignmentRight];
        [_highTempTextView setTextColor:[UIColor weatherDemoRed]];
        [_highTempTextView setFont:[UIFont fontWithName:@"Helvetica" size:42]];
        [_highTempTextView setEditable:NO];
        [_highTempTextView setScrollEnabled:NO];
        [self addSubview:_highTempTextView];
        
        // Load high temperature image as UIImage
        UIImage *highArrowImage = [UIImage imageNamed:@"red_up_arrow.png"];
        
        // Create UIImageView to contain previously loaded high temperature image
        _highTempArrowImageView = [[UIImageView alloc] init];
        [_highTempArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_highTempArrowImageView setImage:highArrowImage];
        [self addSubview:_highTempArrowImageView];
        
        // Create UITextView to display low temperature for the day
        _lowTempTextView = [[UITextView alloc] init];
        [_lowTempTextView setBackgroundColor:[UIColor clearColor]];
        [_lowTempTextView setTextAlignment:NSTextAlignmentRight];
        [_lowTempTextView setTextColor:[UIColor weatherDemoBlue]];
        [_lowTempTextView setFont:[UIFont fontWithName:@"Helvetica" size:42]];
        [_lowTempTextView setEditable:NO];
        [_lowTempTextView setScrollEnabled:NO];
        [self addSubview:_lowTempTextView];
        
        // Load low temperature image as UIImage
        UIImage *lowTempArrowImage = [UIImage imageNamed:@"blue_down_arrow.png"];
        
        // Create UIImageView to contain previously loaded low temperature image
        _lowTempArrowImageView = [[UIImageView alloc] init];
        [_lowTempArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_lowTempArrowImageView setImage:lowTempArrowImage];
        [self addSubview:_lowTempArrowImageView];        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
        
    [super setFrame:frame];
        
    // When the cell frame is set, update the frames of the UIViews it contains    
    [_highTempTextView setFrame:CGRectMake(-40, 15, TEXTVIEW_WIDTH, (self.bounds.size.height * 0.6))];
        
    [_highTempArrowImageView setFrame:CGRectMake(TEXTVIEW_WIDTH - 45, 35, IMAGE_WIDTH_AND_HEIGHT, IMAGE_WIDTH_AND_HEIGHT)];
        
    [_lowTempTextView setFrame:CGRectMake((self.bounds.size.width / 2) - 40, 15, TEXTVIEW_WIDTH, (self.bounds.size.height * 0.6))];
    
    [_lowTempArrowImageView setFrame:CGRectMake((self.bounds.size.width / 2) + TEXTVIEW_WIDTH - 45, 35, IMAGE_WIDTH_AND_HEIGHT, IMAGE_WIDTH_AND_HEIGHT)];

}

// When the high temperature property is set, update the textview that renders this value
-(void)setHighTemperature:(NSString*)newHighTemp{
    [_highTempTextView setText:[newHighTemp stringByAppendingString:@"°C"]];
}

// When the low temperature property is set, update the textview that renders this value
-(void)setLowTemperature:(NSString*)newLowTemp{
    [_lowTempTextView setText:[newLowTemp stringByAppendingString:@"°C"]];
}

@end
