//
//  SDataGridChillCell.m
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

#import "SDataGridChillCell.h"
#import "UIColor+CustomColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation SDataGridChillCell{
    UITextView *_chillTextView;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor backgroundColor]];
        
        // Create the UIView that is used to render the cell contents
        _chillTextView = [UITextView new];
        [_chillTextView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [_chillTextView setFont:[UIFont fontWithName:@"Helvetica" size:40]];
        [_chillTextView setBackgroundColor:[UIColor clearColor]];
        [_chillTextView setTextAlignment:NSTextAlignmentCenter];
        [_chillTextView setEditable:NO];
        [self addSubview:_chillTextView];
            
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
        
    // When the cell frame is set, update the frame of the UIView it contains    
    [_chillTextView setFrame:CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height)];
    
}

// When the wind chill property is set, update the textview that renders this value
-(void)setChill:(NSString*)newChill{
            
    if([newChill integerValue] > 25){
        [_chillTextView setTextColor:[UIColor weatherDemoRed]];
    }
    else{
        [_chillTextView setTextColor:[UIColor weatherDemoBlue]];
    }
    

    [_chillTextView setText:[NSString stringWithFormat:@"%@°C", newChill]];

}
@end
