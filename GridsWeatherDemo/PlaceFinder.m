//
//  PlaceFinder.m
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

#import "PlaceFinder.h"
#import "InvalidLocationException.h"

@implementation PlaceFinder{
    NSXMLParser *_rssParser;
    NSString *_textBetweenTags;
    Place *_place;
    NSMutableArray *_placeList;
}

-(NSArray*)parseXMLFileAtURL:(NSURLRequest*)URL {
    
    _placeList = [[NSMutableArray alloc] init];
    _textBetweenTags = [NSString new];
    
    _rssParser = [[NSXMLParser alloc] initWithContentsOfURL:[URL URL]];
    
    [_rssParser setDelegate:self];
    
    [_rssParser setShouldProcessNamespaces:NO];
    [_rssParser setShouldReportNamespacePrefixes:NO];
    [_rssParser setShouldResolveExternalEntities:NO];
    
    [_rssParser parse];
    
    return _placeList;
}

#pragma NSXMLParserDelegate Methods

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    @throw([InvalidLocationException exceptionWithName:@"Invalid Location Received By PlaceFinder" reason:[NSString stringWithFormat:@"Location received by place finder is invalid: %@", parseError] userInfo:nil]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"Result"]){
        _place = [Place new];
    }   
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    _textBetweenTags = [_textBetweenTags stringByAppendingString:string];
}

// Parse each XML tag
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"city"]){
        [_place setCity:_textBetweenTags];}
    else if([elementName isEqualToString:@"county"]){
        [_place setCounty:_textBetweenTags];
    }
    else if([elementName isEqualToString:@"state"]){
        [_place setState:_textBetweenTags];
    }
    else if([elementName isEqualToString:@"country"]){
        [_place setCountry:_textBetweenTags];
    }
    else if([elementName isEqualToString:@"countrycode"]){
        [_place setCountrycode:_textBetweenTags];
    }
    else if([elementName isEqualToString:@"woeid"]){
        [_place setWoeid:_textBetweenTags];
    }
    else if([elementName isEqualToString:@"Result"]){
        [_placeList addObject: _place];
    }
    
    _textBetweenTags = @"";
}


@end
