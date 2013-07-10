//
//  BottomGridDataSourceHelperDelegate.m
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

#import "BottomGridDataSourceHelperDelegate.h"
#import "WeatherForecastItem.h"
#import "SDataGridHighLowCell.h"
#import "SDataGridDayDateCell.h"
#import "SDataGridWeatherCell.h"

#define DAY @"day"
#define CODE @"code"
#define HIGH @"high"

@implementation BottomGridDataSourceHelperDelegate

// Handle adding data to custom cells in our DataGrid ourselves
-(BOOL)dataGridDataSourceHelper:(SDataGridDataSourceHelper *)helper populateCell:(SDataGridCell *)cell withValue:(id)value forProperty:(NSString *)propertyKey sourceObject:(id)object
{
    WeatherForecastItem *weatherForecastItem = (WeatherForecastItem*)object;
        
    if([propertyKey isEqualToString:DAY]){
        SDataGridDayDateCell *dayDateCell = (SDataGridDayDateCell *)cell;
        [dayDateCell setDate:[weatherForecastItem date]];
        [dayDateCell setDay:[weatherForecastItem day]];    
        return YES;
    }
    
    if([propertyKey isEqualToString:CODE]){
        
       SDataGridWeatherCell *weatherCell = (SDataGridWeatherCell *)cell;
       [weatherCell setWeatherCode:[[weatherForecastItem code] integerValue] andWeatherString:[weatherForecastItem text]];
        return YES;
    }
    
    if([propertyKey isEqualToString:HIGH]){
        
        SDataGridHighLowCell *highLowCell = (SDataGridHighLowCell *)cell;
        [highLowCell setHighTemperature:[weatherForecastItem high]];
        [highLowCell setLowTemperature:[weatherForecastItem low]];
        return YES;        
    }
    
    // return 'NO' so that the datasource helper populates all the other cells in the grid.
    return NO;
}

@end
