//
//  UIColor+CustomColors.m
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

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *) backgroundColor{
    return [UIColor blackColor];
}

+ (UIColor *) backgroundColorGray{
    return [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:255.0/255];
}

+ (UIColor *) gridBorderColor{
    return [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:255.0/255];
}

+ (UIColor *) textColor{
    return [UIColor whiteColor];
}

+ (UIColor *) weatherDemoRed{
    return [UIColor colorWithRed:240.0/255 green:50.0/255 blue:50.0/255 alpha:255.0/255];
}

+ (UIColor *) weatherDemoLighterBlue{
    return [UIColor colorWithRed:90.0/255 green:150.0/255 blue:232.0/255 alpha:255.0/255];
}

+ (UIColor *) weatherDemoBlue{
     return [UIColor colorWithRed:45.0/255 green:120.0/255 blue:232.0/255 alpha:255.0/255];
}

+ (UIColor *) weatherDemoDarkerBlue{
    return [UIColor colorWithRed:0.0/255 green:90.0/255 blue:255.0/255 alpha:255.0/255];
}

+ (UIColor *) weatherDemoGreen{
    return [UIColor colorWithRed:52.0/255 green:190.0/255 blue:38.0/255 alpha:255.0/255];
}

+ (UIColor *) weatherDemoYellow{
    return [UIColor colorWithRed:255.0/255 green:247.0/255 blue:153.0/255 alpha:255.0/255];
}

@end
