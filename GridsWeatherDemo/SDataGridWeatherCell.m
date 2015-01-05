//
//  SDataGridWeatherCell.m
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

#import "SDataGridWeatherCell.h"
#import <QuartzCore/CoreAnimation.h>
#import "WeatherTypes.h"
#import "UIColor+CustomColors.h"

@implementation SDataGridWeatherCell{

    UIImageView *_weatherImageView;
    UITextView *_weatherTextView;

}

// Match weather types specified by Yahoo to weather type pictures in the images folder
+ (WeatherType) rssTypeToWeatherType:(RSSType)rss {    
    switch (rss) {
        case RSSTypeTornado:
        case RSSTypeTropicalStorm:
        case RSSTypeHurricane:
        case RSSTypeSevereThunderstorms:
        case RSSTypeThunderstorms:
        case RSSTypeIsolatedThunderstorms:
        case RSSTypeScatteredThunderstorms:
        case RSSTypeScatteredThunderstormsDuplicate:
        case RSSTypeThundershowers:
        case RSSTypeIsolatedThundershowers:
            return thunderstorm;
           
        case RSSTypeFreezingRain:
        case RSSTypeSnowFlurries:
        case RSSTypeLightSnowShowers:
        case RSSTypeBlowingSnow:
        case RSSTypeSnow:

        case RSSTypeSleet:
        case RSSTypeHeavySnow:
        case RSSTypeScatteredSnowShowers:
        case RSSTypeHeavySnowDuplicate:
        case RSSTypeSnowShowers:
            return snow;
           
        case RSSTypeHaze:
        case RSSTypeSmoky:
        case RSSTypeBlustery:
        case RSSTypeCloudy:
        case RSSTypePartlyCloudy:
            return cloudy;
            
        case RSSTypeMixedRainAndSnow:
        case RSSTypeMixedRainAndSleet:
        case RSSTypeMixedSnowAndSleet:
        case RSSTypeFreezingDrizzle:
        case RSSTypeMixedRainAndHail:
            return rainAndSnow;
            
        case RSSTypeDrizzle:
        case RSSTypeShowers:
        case RSSTypeShowersDuplicate:
        case RSSTypeScatteredShowers:
            return rain;
                        
        case RSSTypeClearNight:
        case RSSTypeSunny:
        case RSSTypeFairDay:
        case RSSTypeHot:
            return sun;
            
        case RSSTypeDust:
        case RSSTypeWindy:
        case RSSTypeCold:
        case RSSTypeFoggy:
            return cloudy;
            
        case RSSTypeHail:   
            return hail;
        
        case RSSTypeFairNight:
            return moon;
        
        case RSSTypePartlyCloudyDay:
            return partlyCloudyDay;
        
        case RSSTypePartlyCloudyNight:
            return partlyCloudyNight;
            
        case RSSTypeMostlyCloudyDay:
            return mostlyCloudyDay;
            
        case RSSTypeMostlyCloudyNight:
            return mostlyCloudyNight;
                        
        case RSSTypeNotAvailable:
        default:
            return NA;
    }
}

-(id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    
    if (self) {
        
        // Create UIImageView to display the weather
        _weatherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NA.png"]];
        [_weatherImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_weatherImageView];
                
        // Create UITextView to display the weather
        _weatherTextView = [UITextView new];
        [_weatherTextView setBackgroundColor:[UIColor clearColor]];
        [_weatherTextView setTextAlignment:NSTextAlignmentCenter];
        [_weatherTextView setTextColor:[UIColor blackColor]];
        [_weatherTextView setFont:[UIFont fontWithName:@"Helvetica" size:25]];
        [_weatherTextView setEditable:NO];
        [_weatherTextView setTextColor:[UIColor textColor]];
        [_weatherTextView setScrollEnabled:NO];
        [self addSubview:_weatherTextView];
        
        [_weatherTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        
    }
    
    return self;
}

// This centers the text that describes the weather vertically in the UITextView
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    
    //enter vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];

    // When the cell frame is set, update the frame of the UIView it contains    
    [_weatherImageView setFrame:CGRectMake(15, 0, self.bounds.size.height - 15, self.bounds.size.height)];
    
    [_weatherTextView setFrame:CGRectMake(self.bounds.size.height, 0,  self.bounds.size.width - _weatherImageView.bounds.size.height, self.bounds.size.height)];
    
}

// When the weather property is set, update the image that renders the corresponding image based on that weather type
-(void)setWeatherCode:(NSInteger)newWeather andWeatherString:(NSString*)newWeatherString{
        
    switch ([SDataGridWeatherCell rssTypeToWeatherType:(RSSType)newWeather]) {
        case cloudy:
            _weatherImageView.image = [UIImage imageNamed:@"cloudy.png"];
            break;
        case thunderstorm:
            _weatherImageView.image = [UIImage imageNamed:@"thunderstorm.png"];
            break;
        case snow:
            _weatherImageView.image = [UIImage imageNamed:@"snow.png"];
            break;
        case rainAndSnow:
            _weatherImageView.image = [UIImage imageNamed:@"rainAndSnow.png"];
            break;
        case rain:
            _weatherImageView.image = [UIImage imageNamed:@"rain.png"];
            break;
        case hail:
            _weatherImageView.image = [UIImage imageNamed:@"hail.png"];
            break;
        case sun:
            _weatherImageView.image = [UIImage imageNamed:@"sun.png"];
            break;            
        case moon:
            _weatherImageView.image = [UIImage imageNamed:@"moon.png"];
            break;
        case partlyCloudyDay:
            _weatherImageView.image = [UIImage imageNamed:@"partlyCloudyDay.png"];
            break;
        case partlyCloudyNight:
            _weatherImageView.image = [UIImage imageNamed:@"partlyCloudyNight.png"];
            break;
        case mostlyCloudyDay:
            _weatherImageView.image = [UIImage imageNamed:@"mostlyCloudyDay.png"];
            break;
        case mostlyCloudyNight:
            _weatherImageView.image = [UIImage imageNamed:@"mostlyCloudyNight.png"];
            break;

        case NA:
        default:{
        }
    }
    
    [_weatherTextView setText:[newWeatherString stringByReplacingOccurrencesOfString:@"/" withString:@"\n"]];
}

@end
