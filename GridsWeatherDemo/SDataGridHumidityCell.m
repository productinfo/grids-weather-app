//
//  SDataGridHumidityCell.m
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

#import "SDataGridHumidityCell.h"
#import <QuartzCore/CoreAnimation.h>
#import "UIColor+CustomColors.h"

#define PERCENT_MARK_WIDTH 8
#define PERCENT_MARK_HEIGHT 1

#define PERCENT_MARK_TEXTVIEW_INSET 4
#define PERCENT_MARK_TEXTVIEW_WIDTH 50
#define PERCENT_MARK_TEXTVIEW_HEIGHT 30
#define ADJUST_SCALE_POSITION_VERTICALLY 15

@implementation SDataGridHumidityCell{

    CAGradientLayer *_background;
    UIView *_humidityIndicator;    

    UIView *_oneHundredPercentMark;
    UITextView *_oneHundredPercentTextView;
    UIView *_seventyFivePercentMark;
    UITextView *_seventyFivePercentTextView;
    UIView *_fiftyPercentMark;
    UITextView *_fiftyPercentTextView;
    UIView *_twentyFivePercentMark;
    UITextView *_twentyFivePercentTextView;

    UITextView *_humidityTextView;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
               
        [self setClipsToBounds:NO];
                        
        // Create UIView to be resized to gauge the days humidity level 
        _humidityIndicator = [[UIView alloc] init];
        _background = [CAGradientLayer layer];
        
        // Set the gradient of the _humidityIndicator UIIView
        _background.colors = @[
                              (id)[UIColor weatherDemoLighterBlue].CGColor,
                              (id)[UIColor weatherDemoBlue].CGColor,
                              (id)[UIColor weatherDemoDarkerBlue].CGColor,
                              ];
        _background.locations = (@[
                                @0.0f,
                                @0.5f,
                                @1.0f
                                ]);
        [_humidityIndicator.layer insertSublayer:_background atIndex:0];
        [self addSubview:_humidityIndicator];
        
        // Create UIView to mark when gauge shows 100% humidity
        _oneHundredPercentMark = [[UIView alloc] init];
        [[_oneHundredPercentMark layer] setBorderWidth:1];
        [[_oneHundredPercentMark layer] setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:_oneHundredPercentMark];
        
        // Create a UITextView indication to the user which UIVIew is the 10% mark
        _oneHundredPercentTextView = [[UITextView alloc] init];
        [self setText:@"100%" forUITextView: _oneHundredPercentTextView];
        [self addSubview:_oneHundredPercentTextView];
        
        // Create UIView to mark when gauge shows 75% humidity
        _seventyFivePercentMark = [[UIView alloc] init];
        [[_seventyFivePercentMark layer] setBorderWidth:1];
        [[_seventyFivePercentMark layer] setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:_seventyFivePercentMark];
        
        // Create a UITextView indication to the user which UIVIew is the 75% mark
        _seventyFivePercentTextView = [[UITextView alloc] init];
        [self setText:@"75%" forUITextView: _seventyFivePercentTextView];
        [self addSubview:_seventyFivePercentTextView];
        
        // Create UIView to mark wheen gauge shows 50% humidity
        _fiftyPercentMark = [[UIView alloc] init];
        [[_fiftyPercentMark layer] setBorderWidth:1];
        [[_fiftyPercentMark layer] setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:_fiftyPercentMark];
        
        // Create a UITextView indication to the user which UIVIew is the 50% mark
        _fiftyPercentTextView = [[UITextView alloc] init];
        [self setText:@"50%" forUITextView:_fiftyPercentTextView];
        [self addSubview:_fiftyPercentTextView];
        
        // Create UIView to mark wheen gauge shows 25% humidity
        _twentyFivePercentMark = [[UIView alloc] init];
        [[_twentyFivePercentMark layer] setBorderWidth:1];
        [[_twentyFivePercentMark layer] setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:_twentyFivePercentMark];
        
        // Create a UITextView indication to the user which UIVIew is the 25% mark
        _twentyFivePercentTextView = [[UITextView alloc] init];
        [self setText:@"25%" forUITextView:_twentyFivePercentTextView];
        [self addSubview:_twentyFivePercentTextView];
        
        // Create UITextView to display the days humidity level
        _humidityTextView = [[UITextView alloc] init];
        [_humidityTextView setBackgroundColor:[UIColor clearColor]];
        [_humidityTextView setTextAlignment:NSTextAlignmentCenter];
        [_humidityTextView setTextColor:[UIColor whiteColor]];
        [_humidityTextView setFont:[UIFont fontWithName:@"Helvetica" size:27]];
        [self addSubview:_humidityTextView];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    // When the cell frame is set, update the frames of the UIViews it contains
    [_background setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];

    [_humidityIndicator setFrame:CGRectMake(1, 0, self.bounds.size.width-1, self.bounds.size.height)];
    
    [self repositionMarksAndTextViews];
    
    [self setHumidity:[[_humidityTextView text] stringByReplacingOccurrencesOfString:@"%" withString:@""]];
}

// When the humidity property is set, update the textview and humidity indicator gauge that renders this value
-(void)setHumidity:(NSString*)newHumidity{

    [_humidityIndicator setFrame:CGRectMake(1, (self.bounds.size.height * ((100 - [newHumidity floatValue]) / 100)), _humidityIndicator.bounds.size.width - 1, (self.bounds.size.height * ([newHumidity floatValue] / 100)))];
    
    [_background setFrame:CGRectMake(0, 0, _humidityIndicator.frame.size.width, (self.bounds.size.height * ([newHumidity floatValue] / 100)))];
    
    [self repositionMarksAndTextViews];
    
    [_humidityTextView setText:[newHumidity stringByAppendingString:@"%"]];

}

// Repositions UIView gauge marks and UITextView gauge text containers
-(void)repositionMarksAndTextViews{
    
    [_oneHundredPercentMark setFrame:CGRectMake(0, (self.bounds.size.height * 0.001), PERCENT_MARK_WIDTH, PERCENT_MARK_HEIGHT)];
    [_oneHundredPercentTextView setFrame:CGRectMake(PERCENT_MARK_TEXTVIEW_INSET, -12, PERCENT_MARK_TEXTVIEW_WIDTH, PERCENT_MARK_TEXTVIEW_HEIGHT)];
    
    [_seventyFivePercentMark setFrame:CGRectMake(0, (self.bounds.size.height * 0.25), PERCENT_MARK_WIDTH, PERCENT_MARK_HEIGHT)];
    [_seventyFivePercentTextView setFrame:CGRectMake(PERCENT_MARK_TEXTVIEW_INSET, (self.bounds.size.height * 0.25) - ADJUST_SCALE_POSITION_VERTICALLY, PERCENT_MARK_TEXTVIEW_WIDTH, PERCENT_MARK_TEXTVIEW_HEIGHT)];
    
    [_fiftyPercentMark setFrame:CGRectMake(0, (self.bounds.size.height * 0.50), PERCENT_MARK_WIDTH, PERCENT_MARK_HEIGHT)];
    [_fiftyPercentTextView setFrame:CGRectMake(PERCENT_MARK_TEXTVIEW_INSET, (self.bounds.size.height * 0.5) - ADJUST_SCALE_POSITION_VERTICALLY, PERCENT_MARK_TEXTVIEW_WIDTH, PERCENT_MARK_TEXTVIEW_HEIGHT)];
    
    [_twentyFivePercentMark setFrame:CGRectMake(0, (self.bounds.size.height * 0.75), PERCENT_MARK_WIDTH, PERCENT_MARK_HEIGHT)];
    [_twentyFivePercentTextView setFrame:CGRectMake(PERCENT_MARK_TEXTVIEW_INSET, (self.bounds.size.height * 0.75) - ADJUST_SCALE_POSITION_VERTICALLY, PERCENT_MARK_TEXTVIEW_WIDTH, PERCENT_MARK_TEXTVIEW_HEIGHT)];
    
    [_humidityTextView setFrame:CGRectMake(37, 19, 86, self.bounds.size.height)];
    
}

//Refactored method for setting properties on each of the three textViews that acts as gauge marks
-(void)setText:(NSString*)text forUITextView:(UITextView*)UITextView{
    
    [UITextView setText:text];
    
    [UITextView setBackgroundColor:[UIColor clearColor]];
    [UITextView setTextAlignment:NSTextAlignmentLeft];
    [UITextView setTextColor:[UIColor whiteColor]];
    [UITextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    
    [UITextView setEditable:NO];
    
}

@end
