//
//  SDataGridDayDateCell.m
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

#import "SDataGridDayDateCell.h"
#import "UIColor+CustomColors.h"
#import <QuartzCore/CoreAnimation.h>

@implementation SDataGridDayDateCell{

    UITextView *_dateTextView;
    UIView *_line;
    UITextView *_dayTextView;
    
}

static NSDictionary *_weekDays;

+(NSDictionary*)_weekDays{
    
    if(!_weekDays){
        _weekDays = [[NSDictionary alloc] initWithObjects:@[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"] forKeys:@[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"]];
    }
    
    return _weekDays;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
                
        // Create UITextView to display the date
        _dateTextView = [UITextView new];
        [_dateTextView setBackgroundColor:[UIColor clearColor]];
        [_dateTextView setTextAlignment:NSTextAlignmentCenter];
        [_dateTextView setTextColor:[UIColor blackColor]];
        [_dateTextView setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [_dateTextView setEditable:NO];
        [_dateTextView setScrollEnabled:NO];
        [_dateTextView setTextColor:[UIColor textColor]];
        [self addSubview:_dateTextView];
        
        // Create UIView to give the illusion that the cell is split horizontally
        _line = [[UIView alloc] init];
        [[_line layer] setBorderWidth:1];
        [[_line layer] setBorderColor:[UIColor gridBorderColor].CGColor];
        [self addSubview:_line];
        
        // Create UITextView to display the day of the week
        _dayTextView = [UITextView new];
        [_dayTextView setBackgroundColor:[UIColor clearColor]];
        [_dayTextView setTextAlignment:NSTextAlignmentCenter];
        [_dayTextView setTextColor:[UIColor blackColor]];
        [_dayTextView setFont:[UIFont fontWithName:@"Helvetica" size:40]];
        [_dayTextView setEditable:NO];
        [_dayTextView setTextColor:[UIColor textColor]];
        [self addSubview:_dayTextView];
        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];

    // When the cell frame is set, update the frames of the UIViews it contains    
    [_dateTextView setFrame:CGRectMake(0, -5, self.bounds.size.width, 25)];
    
    [_line setFrame:CGRectMake(0, 20, self.bounds.size.width, 1)];
        
    [_dayTextView setFrame:CGRectMake(0, 28, self.bounds.size.width, 100)];
    
}

// When the date property is set, update the textview that renders this value
-(void)setDate:(NSString*)newDate{
    [_dateTextView setText:newDate];
}

// When the day property is set, update the textview that renders this value
-(void)setDay:(NSString*)newDay{
    [_dayTextView setText:[[SDataGridDayDateCell _weekDays] objectForKey:newDay]];
}

@end
