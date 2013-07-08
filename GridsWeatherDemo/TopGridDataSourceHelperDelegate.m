//
//  TopGridDataSourceHelperDelegate.m
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

#import "TopGridDataSourceHelperDelegate.h"
#import "SDataGridHumidityCell.h"
#import "SDataGridSpeedCell.h"
#import "SDataGridDirectionCell.h"
#import "SDataGridChillCell.h"
#import "SDataGridRisingCell.h"
#import "SDataGridCustomTextCell.h"
#import "WeatherDataObject.h"

@implementation TopGridDataSourceHelperDelegate

// Handle adding data to custom cells in our DataGrid ourselves
-(BOOL)dataGridDataSourceHelper:(SDataGridDataSourceHelper *)helper populateCell:(SDataGridCell *)cell withValue:(id)value forProperty:(NSString *)propertyKey sourceObject:(id)object
{
    
    WeatherDataObject *weatherDataObject = (WeatherDataObject*)object;
        
    if([propertyKey isEqualToString:@"windChill"]){
        
        SDataGridChillCell *chillCell = (SDataGridChillCell *)cell;
        [chillCell setChill:[weatherDataObject windChill]];
        return YES;
    }
    
    if([propertyKey isEqualToString:@"windDirection"]){
        
        SDataGridDirectionCell *directionCell = (SDataGridDirectionCell *)cell;
        [directionCell setDirection:[weatherDataObject windDirection]];
        return YES;        
    }
    
    if([propertyKey isEqualToString:@"windSpeed"]){
        
        SDataGridSpeedCell *speedCell = (SDataGridSpeedCell *)cell;
        [speedCell setSpeed:[weatherDataObject windSpeed]];
        return YES;        
    }
    
    if([propertyKey isEqualToString:@"atmospherePressure"]){
        
        SDataGridCustomTextCell *customTextCell = (SDataGridCustomTextCell *)cell;
        [customTextCell setText:[weatherDataObject atmospherePressure]];
        return YES;
    }
        
    if([propertyKey isEqualToString:@"atmosphereRising"]){
        
        SDataGridRisingCell *risingCell = (SDataGridRisingCell *)cell;
        [risingCell setRising:[weatherDataObject atmosphereRising]];
        return YES;
    }
        
    if([propertyKey isEqualToString:@"atmosphereHumidity"]){
        
        SDataGridHumidityCell *humidityCell = (SDataGridHumidityCell *)cell;
        [humidityCell setHumidity:[weatherDataObject atmosphereHumidity]];
        return YES;
    }
    
    if([propertyKey isEqualToString:@"atmosphereVisibility"]){
        
        SDataGridCustomTextCell *customTextCell = (SDataGridCustomTextCell *)cell;
        [customTextCell setText:[weatherDataObject atmosphereVisibility]];
        return YES;
    }
    
    // return 'NO' so that the datasource helper populates all the other cells in the grid.
    return NO;
}

@end
