//
//  SDataGridRisingCell.m
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

#import "SDataGridRisingCell.h"
#import "UIColor+CustomColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation SDataGridRisingCell{
    
    CAGradientLayer *_background;
    UIView *_risingBackgroundView; 
    
    UITextView *_risingTextView;
    UITextView *_steadyTextView;
    UITextView *_fallingTextView;
    
    int previousPressure;
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
                
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
        UIEdgeInsets edgeInset = UIEdgeInsetsMake(-5,0,0,0);
        
        // background view
        _risingBackgroundView = [[UIView alloc] init];
        
        // Set the gradient of the _background UIView
        _background = [CAGradientLayer layer];
        
        _background.colors = @[
                               (id)[UIColor weatherDemoRed].CGColor,
                               (id)[UIColor weatherDemoYellow].CGColor,
                               (id)[UIColor weatherDemoGreen].CGColor,
                               ];
        _background.locations = (@[
                                 @0.0f,
                                 @0.5f,
                                 @1.0f
                                 ]);
        [_risingBackgroundView.layer insertSublayer:_background atIndex:0];
        [self addSubview:_risingBackgroundView];
        
        // Create the UIViews that are used to render the cell contents
        _risingTextView = [UITextView new];
        [self setFont:font andEdgeInsets:edgeInset forUITextView:_risingTextView];
        [_risingTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_risingTextView];
        
        _steadyTextView = [UITextView new];
        [self setFont:font andEdgeInsets:edgeInset forUITextView:_steadyTextView];
        [_steadyTextView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_steadyTextView];
        
        _fallingTextView = [UITextView new];
        [self setFont:font andEdgeInsets:edgeInset forUITextView:_fallingTextView];
        [_fallingTextView  setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_fallingTextView];
        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    // When the cell frame is set, update the frame of the UIView it contains
    [_risingBackgroundView setFrame:CGRectMake(1, 0, self.bounds.size.width - 1, self.bounds.size.height)];    
    [_background setFrame:CGRectMake(0, 0, self.bounds.size.width - 2, self.bounds.size.height)];
        
    int oneThirdOfHeight = (self.bounds.size.height - 2) / 3;

    // When the cell frame is set, update the frames of the UIViews it contains
    [_risingTextView setFrame:CGRectMake(0, 2, self.bounds.size.width, oneThirdOfHeight)];
    [_steadyTextView setFrame:CGRectMake(0, 2 + oneThirdOfHeight , self.bounds.size.width, oneThirdOfHeight)];
    [_fallingTextView setFrame:CGRectMake(0, 2 + (oneThirdOfHeight * 2), self.bounds.size.width, oneThirdOfHeight)];
    
}

// When the barometric pressure property is set, update the textview that renders the value and the other two textviews that don't
-(void)setRising:(NSString*)newRising{
        
    NSString *risingText, *steadyText, *fallingText = @"";
    
    // Set the new value for the appropriate color and string variables
    if([newRising isEqualToString:@"rising"]){
        risingText = newRising;
    }
    else if([newRising isEqualToString:@"steady"]){
        steadyText = newRising;
    }
    else{
        fallingText = newRising;
    }
    
    [_risingTextView setText:risingText];
    [_steadyTextView setText:steadyText];
    [_fallingTextView setText:fallingText];

}

-(void)setFont:(UIFont*)font andEdgeInsets:(UIEdgeInsets)edgeInsets forUITextView:(UITextView*)uiTextView{
    
    [uiTextView setContentInset:edgeInsets];
    [uiTextView setFont:font];
    
    [uiTextView setTextAlignment:NSTextAlignmentCenter];
    [uiTextView setTextColor:[UIColor blackColor]];
    [uiTextView setEditable:NO];
    
}

@end

