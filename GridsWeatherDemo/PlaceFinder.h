//
//  PlaceFinder.h
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
#import "Place.h"

// A class to parse the locations matched to a specific WOEID by Yahoo
// WOEID's are 32-bit identifiers used to represent spatial entities see here for more info: http://developer.yahoo.com/geo/geoplanet/guide/concepts.html
@interface PlaceFinder : NSObject <NSXMLParserDelegate>

-(NSArray*)parseXMLFileAtURL:(NSURLRequest*)URL;

@end
