//
//  WeatherTypes.h
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

#import <Foundation/Foundation.h>

// Types are defined by Yahoo weather feed
typedef enum RSSType{
    RSSTypeTornado,
    RSSTypeTropicalStorm,
    RSSTypeHurricane,
    RSSTypeSevereThunderstorms,
    RSSTypeThunderstorms,
    RSSTypeMixedRainAndSnow,
    RSSTypeMixedRainAndSleet,
    RSSTypeMixedSnowAndSleet,
    RSSTypeFreezingDrizzle,
    RSSTypeDrizzle,
    RSSTypeFreezingRain,
    RSSTypeShowers,
    RSSTypeShowersDuplicate,
    RSSTypeSnowFlurries,
    RSSTypeLightSnowShowers,
    RSSTypeBlowingSnow,
    RSSTypeSnow,
    RSSTypeHail,
    RSSTypeSleet,
    RSSTypeDust,
    RSSTypeFoggy,
    RSSTypeHaze,
    RSSTypeSmoky,
    RSSTypeBlustery,
    RSSTypeWindy,
    RSSTypeCold,
    RSSTypeCloudy,
    RSSTypeMostlyCloudyNight,
    RSSTypeMostlyCloudyDay,
    RSSTypePartlyCloudyNight,
    RSSTypePartlyCloudyDay,
    RSSTypeClearNight,
    RSSTypeSunny,
    RSSTypeFairNight,
    RSSTypeFairDay,
    RSSTypeMixedRainAndHail,
    RSSTypeHot,
    RSSTypeIsolatedThunderstorms,
    RSSTypeScatteredThunderstorms,
    RSSTypeScatteredThunderstormsDuplicate,
    RSSTypeScatteredShowers,
    RSSTypeHeavySnow,
    RSSTypeScatteredSnowShowers,
    RSSTypeHeavySnowDuplicate,
    RSSTypePartlyCloudy,
    RSSTypeThundershowers,
    RSSTypeSnowShowers,
    RSSTypeIsolatedThundershowers,
    RSSTypeNotAvailable = 3200
} RSSType;

// Types are defined by the pictures available in the images folder of the project
typedef enum WeatherType
{
    cloudy,
    thunderstorm,
    snow,
    rainAndSnow,
    rain,
    hail,
    sun,
    moon,
    partlyCloudyDay,
    partlyCloudyNight,
    mostlyCloudyDay,
    mostlyCloudyNight,
    NA
} WeatherType;
