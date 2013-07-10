//
//  RSSFeedReader.m
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

#import "RSSFeedReader.h"
#import "InvalidWeatherDataException.h"

@implementation RSSFeedReader{
    
    NSXMLParser *_rssParser;
    NSString *_textBetweenTags;
    bool item;
    WeatherDataObject *_weatherDataObject;
    
    NSDictionary *_weekDays;
}


-(WeatherDataObject*)parseXMLFileAtURL:(NSString *)URL {
        
    _textBetweenTags = [NSString new];
    _weatherDataObject = [WeatherDataObject new];
    [_weatherDataObject setListOfWeatherForecastItems:[NSMutableArray new]];
    item = NO;
    
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
    
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    _rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [_rssParser setDelegate:self];
    
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [_rssParser setShouldProcessNamespaces:NO];
    [_rssParser setShouldReportNamespacePrefixes:NO];
    [_rssParser setShouldResolveExternalEntities:NO];
    
    [_rssParser parse];
        
    return _weatherDataObject;
}

#pragma NSXMLParserDelegate Methods

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
        
    @throw([InvalidWeatherDataException exceptionWithName:@"Invalid Weather Data XML Received By RSSFeedReader" reason:[NSString stringWithFormat:@"Invalid Weather Data XML Received By RSSFeedReader: %@", parseError] userInfo:nil]);
    
}

// Parse each XML tag and its associated attributes
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"yweather:location"]) {
        [_weatherDataObject setLocationCity:[attributeDict objectForKey:@"city"]];
        [_weatherDataObject setLocationRegion:[attributeDict objectForKey:@"region"]];
        [_weatherDataObject setLocationCountry:[attributeDict objectForKey:@"country"]];
    }
    else if([elementName isEqualToString:@"yweather:units"]) {
        [_weatherDataObject setUnitsTemperature:[attributeDict objectForKey:@"temperature"]];
        [_weatherDataObject setUnitsDistance:[attributeDict objectForKey:@"distance"]];
        [_weatherDataObject setUnitsPressure:[attributeDict objectForKey:@"pressure"]];
        [_weatherDataObject setUnitsSpeed:[attributeDict objectForKey:@"speed"]];
    }
    else if([elementName isEqualToString:@"yweather:wind"]) {
        [_weatherDataObject setWindChill:[attributeDict objectForKey:@"chill"]];
        [_weatherDataObject setWindDirection:[attributeDict objectForKey:@"direction"]];
        [_weatherDataObject setWindSpeed:[attributeDict objectForKey:@"speed"]];
    }
    else if([elementName isEqualToString:@"yweather:atmosphere"]) {
        [_weatherDataObject setAtmosphereHumidity:[attributeDict objectForKey:@"humidity"]];
        [_weatherDataObject setAtmosphereVisibility:[[attributeDict objectForKey:@"visibility"] stringByAppendingString:@" km"]];
        [_weatherDataObject setAtmospherePressure:[[attributeDict objectForKey:@"pressure"] stringByAppendingString:@" mb"]];
        
        if([[attributeDict objectForKey:@"rising"] isEqualToString:@"0"]){
            [_weatherDataObject setAtmosphereRising:@"steady"];
        }
        else if([[attributeDict objectForKey:@"rising"] isEqualToString:@"1"]){
            [_weatherDataObject setAtmosphereRising:@"rising"];
        }        
        else{
            [_weatherDataObject setAtmosphereRising:@"falling"];
        }        
    }
    else if([elementName isEqualToString:@"yweather:astronomy"]) {
        [_weatherDataObject setAstronomySunrise:[attributeDict objectForKey:@"sunrise"]];
        [_weatherDataObject setAstronomySunset:[attributeDict objectForKey:@"sunset"]];
    }
    else if([elementName isEqualToString:@"item"]) {
        item = YES;
    }
    else if([elementName isEqualToString:@"yweather:condition"]) {
        [_weatherDataObject setItemConditionText:[attributeDict objectForKey:@"text"]];
        [_weatherDataObject setItemConditionTemp:[attributeDict objectForKey:@"temp"]];
        [_weatherDataObject setItemConditionDate:[attributeDict objectForKey:@"date"]];
    }
    else if([elementName isEqualToString:@"yweather:forecast"]) {
        
        WeatherForecastItem *wfi = [WeatherForecastItem new];
               
        [wfi setDay:[attributeDict objectForKey:@"day"]];
        [wfi setDate:[attributeDict objectForKey:@"date"]];
        [wfi setLow:[attributeDict objectForKey:@"low"]];
        [wfi setHigh:[attributeDict objectForKey:@"high"]];
        [wfi setText:[attributeDict objectForKey:@"text"]];
        [wfi setCode:[attributeDict objectForKey:@"code"]];
        
        [[_weatherDataObject listOfWeatherForecastItems] addObject:wfi];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
        
    _textBetweenTags = @"";
}

@end
