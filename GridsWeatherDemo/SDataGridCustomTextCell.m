//
//  SDataGridCustomTextCell.m
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

#import "SDataGridCustomTextCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColors.h"

@implementation SDataGridCustomTextCell{
  
    UITextView *_textView;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor backgroundColor]];
                
        // Create the UIView that is used to render the cell contents
        _textView = [UITextView new];
        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setTextAlignment:NSTextAlignmentCenter];
        [_textView setEditable:NO];
        [_textView setTextColor:[UIColor whiteColor]];
        [self addSubview:_textView];
        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    // When the cell frame is set, update the frame of the UIView it contains    
    [_textView setFrame:CGRectMake(0, self.bounds.size.height * 0.25, self.bounds.size.width, self.bounds.size.height/2)];
    
}

// When the wind chill property is set, update the textview that renders this value
-(void)setText:(NSString*)newtext{

    [_textView setText:newtext];
    
}
@end
