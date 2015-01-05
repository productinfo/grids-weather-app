//
//  ViewController.m
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

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <ShinobiGrids/ShinobiDataGrid.h>
#import "SDataGridHighLowCell.h"
#import "SDataGridDayDateCell.h"
#import "SDataGridHumidityCell.h"
#import "SDataGridSpeedCell.h"
#import "SDataGridDirectionCell.h"
#import "SDataGridWeatherCell.h"
#import "SDataGridChillCell.h"
#import "SDataGridRisingCell.h"
#import "SDataGridCustomTextCell.h"
#import "TopGridDataSourceHelperDelegate.h"
#import "BottomGridDataSourceHelperDelegate.h"
#import "UIColor+CustomColors.h"
#import "InvalidLocationException.h"
#import "InvalidWeatherDataException.h"

#define MARGIN 20
#define TOPBAR_HEIGHT 125
#define LOCATIONFINDER_WIDTH 600
#define TODAY_GRIDS_HEIGHT 150
#define HALFWIDTH 492

#define PLACES_TABLE_WIDTH 685
#define PLACES_TABLE_HEIGHT 532
#define PLACES_TABLE_ROW_HEIGHT 53

#define PLACE_FINDER_URL_LAT_LONG @"http://query.yahooapis.com/v1/public/yql?q=select * from geo.placefinder where text='%@,%@' and gflags='R'&appid=test"
#define PLACE_FINDER_URL_PLACE_NAME @"http://query.yahooapis.com/v1/public/yql?q=select * from geo.placefinder where text='%@' and gflags='R'&appid=test"
#define WOEID_URL @"http://weather.yahooapis.com/forecastrss?w=%@&u=c"

@interface ViewController ()

@end

@implementation ViewController{

    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocation;

    UIView *_topView;
    UIImageView *_daytimeIndicatorImageView;
    UILabel *_daytimeIndicatorLabel;
    UITextField *_locationFinder;
    NSString *_previousLocation;
    UILabel *_locationInfoLabel;
    UILabel *_timeInfoLabel;
    UILabel *_avgTempLabel;
    
    UILabel *_leftTopGridLabel;
    UILabel *_rightTopGridLabel;
    ShinobiDataGrid *_topGrid;
    SDataGridDataSourceHelper *_topGridDatasourceHelper;
    TopGridDataSourceHelperDelegate *_topGridDataSourceHelperDelegate;
    
    UIView *_bottomView;
    UILabel *_bottomGridLabel;
    ShinobiDataGrid *_bottomGrid;
    SDataGridDataSourceHelper *_bottomGridDatasourceHelper;
    BottomGridDataSourceHelperDelegate *_bottomGridDataSourceHelperDelegate;
        
    NSArray *_places;
    NSMutableArray *_placeNames;
    
    UIColor *_headerColor;
    UIFont *_headerFont;
    UIColor *_headerBorderColor;
}

static NSDateFormatter *dateFormatterBoundaryDate = nil;

-(id)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        UITapGestureRecognizer *closeKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        [closeKeyboard setDelegate:self];
        [closeKeyboard setCancelsTouchesInView:NO];
        [closeKeyboard setDelaysTouchesBegan:NO];
        [closeKeyboard setDelaysTouchesEnded:NO];
        [[self view] addGestureRecognizer:closeKeyboard];
        [_topView addGestureRecognizer:closeKeyboard];
    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)closeKeyboard{
    [_locationFinder resignFirstResponder];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
  
    [ShinobiDataGrids setLicenseKey:@""]; // TODO: add your trial license key here!
  
    [self setTitle:@"ShinobiGrids Weather Demo App V0.1"];
    [[self view] setBackgroundColor:[UIColor backgroundColor]];
    
    _headerFont = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    int combinedHeight = (TOPBAR_HEIGHT + TODAY_GRIDS_HEIGHT);
    
    // Partition the view into a top view... two subviews a top and a bottom view
    _topView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, ([self view].bounds.size.height - (MARGIN * 2)), combinedHeight)];
    [self styleViewToLookLikeGrid:_topView];
    [self setupTopView];
    
    // ...and view on the bottom
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, (MARGIN * 2) + combinedHeight, ([self view].bounds.size.height - (MARGIN * 2)), [self view].bounds.size.width - (combinedHeight + (MARGIN * 3)))];
    [[self view] addSubview:_bottomView];
    [self styleViewToLookLikeGrid:_bottomView];
    [self setupBottomView];
        
    // Initialise and start location manager so app provides you with local weather information on start up
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate: self];
    [_locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter: kCLDistanceFilterNone];
    [_locationManager startUpdatingLocation];
}

-(void)styleViewToLookLikeGrid:(UIView*)view{
    [[view layer] setBorderColor:[UIColor gridBorderColor].CGColor];
    [[view layer] setBorderWidth:5];
    [[view layer] setCornerRadius:20];
    [view setClipsToBounds:YES];
}

-(void)setupTopView{
    
    [_topView setBackgroundColor:[UIColor backgroundColor]];
    
    // Initialise imageView which indicates if it is daytime or nighttime
    _daytimeIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_topView.bounds.origin.x + MARGIN, _topView.bounds.origin.y + 10, TOPBAR_HEIGHT - MARGIN, TOPBAR_HEIGHT - MARGIN)];
    [_topView addSubview:_daytimeIndicatorImageView];
    
    // Initialise label which indicates if it is daytime or nighttime
    _daytimeIndicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topView.bounds.origin.x + MARGIN, _topView.bounds.origin.y + 5, TOPBAR_HEIGHT - MARGIN, TOPBAR_HEIGHT - MARGIN)];
    [_daytimeIndicatorLabel setBackgroundColor:[UIColor clearColor]];
    [_daytimeIndicatorLabel setTextAlignment:NSTextAlignmentCenter];
    [_daytimeIndicatorLabel setTextColor:[UIColor blackColor]];
    [_daytimeIndicatorLabel setFont:[UIFont fontWithName:@"Helvetica" size:25]];
    [_topView addSubview:_daytimeIndicatorLabel];
    
    float middleOfTopBarWidth = ((_topView.bounds.size.width/2) - (LOCATIONFINDER_WIDTH/2));
    
    // Initialise TextField which allows weather data to be changed to that of another location at runtime
    _locationFinder = [[UITextField alloc] initWithFrame:CGRectMake(middleOfTopBarWidth, 0, LOCATIONFINDER_WIDTH, TOPBAR_HEIGHT*0.7)];
    [_locationFinder setBackgroundColor:[UIColor clearColor]];
    [_locationFinder setTextAlignment:NSTextAlignmentCenter];
    [[_locationFinder layer] setBorderWidth:0];
    [_locationFinder setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [_locationFinder setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    [_locationFinder setTextColor:[UIColor textColor]];
    [_topView addSubview:_locationFinder];
    
    // Initialise label which displays the city/county/country of location
    _locationInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleOfTopBarWidth, _locationFinder.bounds.size.height - 2, LOCATIONFINDER_WIDTH * 0.5, TOPBAR_HEIGHT * 0.3)];
    [_locationInfoLabel setBackgroundColor:[UIColor clearColor] ];
    [_locationInfoLabel setTextAlignment:NSTextAlignmentCenter];
    [_locationInfoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [_locationInfoLabel setTextColor:[UIColor textColor]];
    [_topView addSubview:_locationInfoLabel];
    
    // Initialise label which displays the time at which the weather data was accurate
    _timeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleOfTopBarWidth + (LOCATIONFINDER_WIDTH * 0.5), _locationFinder.bounds.size.height - 2, LOCATIONFINDER_WIDTH * 0.5, TOPBAR_HEIGHT * 0.3)];
    [_timeInfoLabel setBackgroundColor:[UIColor clearColor]];
    [_timeInfoLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeInfoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [_timeInfoLabel setTextColor:[UIColor textColor]];
    [_topView addSubview:_timeInfoLabel];
    
    // Initialise label which displays todays average temperature
    _avgTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topView.bounds.size.width - TOPBAR_HEIGHT , _topView.bounds.origin.y + 10, TOPBAR_HEIGHT - MARGIN, TOPBAR_HEIGHT - MARGIN)];
    [_avgTempLabel setBackgroundColor:[UIColor clearColor] ];
    [_avgTempLabel setTextAlignment:NSTextAlignmentCenter];
    [_avgTempLabel setFont:[UIFont fontWithName:@"Helvetica" size:35]];
    [_topView addSubview:_avgTempLabel];
    
    
    int labelHeight = TODAY_GRIDS_HEIGHT * 0.2;
    
    // Initialise "Wind Data" label
    _leftTopGridLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOPBAR_HEIGHT, HALFWIDTH, labelHeight)];
    [_leftTopGridLabel setTextAlignment:NSTextAlignmentCenter];
    [_leftTopGridLabel setBackgroundColor:[UIColor backgroundColorGray]];
    [[_leftTopGridLabel layer] setBorderWidth:1];
    [[_leftTopGridLabel layer] setBorderColor:[UIColor gridBorderColor].CGColor];
    [_leftTopGridLabel setNumberOfLines:0];
    [_leftTopGridLabel setFont:_headerFont];
    [_leftTopGridLabel setText:@"Wind Data"];
    [_leftTopGridLabel  setTextColor:[UIColor textColor]];
    [_topView addSubview:_leftTopGridLabel];
    
    // Initialise "Atmosphere Data" label
    _rightTopGridLabel  = [[UILabel alloc] initWithFrame:CGRectMake(HALFWIDTH, TOPBAR_HEIGHT, HALFWIDTH, labelHeight)];
    [_rightTopGridLabel setTextAlignment:NSTextAlignmentCenter];
    [_rightTopGridLabel setBackgroundColor:[UIColor backgroundColorGray]];
    [[_rightTopGridLabel layer] setBorderWidth:1];
    [[_rightTopGridLabel layer] setBorderColor:[UIColor gridBorderColor].CGColor];
    [_rightTopGridLabel setNumberOfLines:0];
    [_rightTopGridLabel setFont:_headerFont];
    [_rightTopGridLabel setText:@"Atmosphere Data"];
    [_rightTopGridLabel  setTextColor:[UIColor textColor]];
    [_topView addSubview:_rightTopGridLabel];
        
    int gridHeight = TODAY_GRIDS_HEIGHT * 0.80;
    
    // create the grid
    _topGrid = [[ShinobiDataGrid alloc] initWithFrame:CGRectMake(0, (TOPBAR_HEIGHT + labelHeight), ([self view].bounds.size.height - MARGIN), gridHeight)];
    
    // style the grid
    [self styleGrid:_topGrid];
    [_topGrid setUserInteractionEnabled:NO];
    [_topGrid setDefaultRowHeight:@85];
    
    int halfWidthDividedByThree = HALFWIDTH / 3;
    int halfWidthDividedByFour = HALFWIDTH / 4;
    
    // add a chill column    
    [self addColumnToGrid:_topGrid WithTitle:@"Chill" withProperty:@"windChill" withCellType:[SDataGridChillCell class] andWidth:(halfWidthDividedByThree - 6)];
    
    // add a direction column
    [self addColumnToGrid:_topGrid WithTitle:@"Direction"  withProperty:@"windDirection"  withCellType:[SDataGridDirectionCell class] andWidth:(halfWidthDividedByThree)];    
    
    // add a speed column    
    [self addColumnToGrid:_topGrid WithTitle:@"Speed" withProperty:@"windSpeed" withCellType:[SDataGridSpeedCell class] andWidth:halfWidthDividedByThree+4];
    
    // add a pressure column    
    [self addColumnToGrid:_topGrid WithTitle:@"Pressure" withProperty:@"atmospherePressure" withCellType:[SDataGridCustomTextCell class] andWidth:halfWidthDividedByFour];
    
    // add a rising column    
    [self addColumnToGrid:_topGrid WithTitle:@"Rising" withProperty:@"atmosphereRising" withCellType:[SDataGridRisingCell class] andWidth:halfWidthDividedByFour];
    
    // add a humidity column    
    [self addColumnToGrid:_topGrid WithTitle:@"Humidity" withProperty:@"atmosphereHumidity" withCellType:[SDataGridHumidityCell class] andWidth:halfWidthDividedByFour];
    
    // add a visibility column    
    [self addColumnToGrid:_topGrid WithTitle:@"Visibility" withProperty:@"atmosphereVisibility" withCellType:[SDataGridCustomTextCell class] andWidth:halfWidthDividedByFour];
        
    // create the helper
    _topGridDatasourceHelper = [[SDataGridDataSourceHelper alloc] initWithDataGrid:_topGrid];
    
    // set the delegate for the helper
    _topGridDataSourceHelperDelegate = [[TopGridDataSourceHelperDelegate alloc] init];
    _topGridDatasourceHelper.delegate = _topGridDataSourceHelperDelegate;
    
    // add grid to topView
    [_topView addSubview:_topGrid];
    
    // add topView to view
    [[self view] addSubview:_topView];
}

-(void)setupBottomView{
    
    [_bottomView setBackgroundColor:[UIColor backgroundColorGray]];
    
    // Initialise "Forecast Data" label
    _bottomGridLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottomView.bounds.size.width, _leftTopGridLabel.bounds.size.height)];
    [_bottomGridLabel setTextAlignment:NSTextAlignmentCenter];
    [_bottomGridLabel setBackgroundColor:[UIColor clearColor]];
    [[_bottomGridLabel layer] setBorderWidth:1];
    [[_bottomGridLabel layer] setBorderColor:[UIColor gridBorderColor].CGColor];
    [_bottomGridLabel setNumberOfLines:0];
    [_bottomGridLabel setFont:_headerFont];
    [_bottomGridLabel setText:@"Forecast Data"];
    [_bottomGridLabel  setTextColor:[UIColor textColor]];
    [_bottomView addSubview:_bottomGridLabel];
    
    // create a grid
    _bottomGrid = [[ShinobiDataGrid alloc] initWithFrame:CGRectMake(0, (TODAY_GRIDS_HEIGHT * 0.2), _bottomView.bounds.size.width, _bottomView.bounds.size.height - _bottomGridLabel.bounds.size.height)];
    
    // style the grid
    [self styleGrid:_bottomGrid];
    [_bottomGrid setDefaultHeaderRowHeight:[NSNumber numberWithFloat:_bottomGridLabel.bounds.size.height]];
    [_bottomGrid setDefaultRowHeight:[NSNumber numberWithFloat:((_bottomGrid.bounds.size.height - _bottomGridLabel.bounds.size.height - [[_bottomGrid defaultHeaderRowHeight] floatValue]-3) / 3.25)]];
        
    // add a day/date column    
    [self addColumnToGrid:_bottomGrid WithTitle:@"Day/Date" withProperty:@"day" withCellType:[SDataGridDayDateCell class] andWidth:(_bottomGrid.frame.size.width - 700)];
    
    // add a weather column     
    [self addColumnToGrid:_bottomGrid WithTitle:@"Weather" withProperty:@"code" withCellType:[SDataGridWeatherCell class] andWidth:(350)];
    
    // add a high/low column     
    [self addColumnToGrid:_bottomGrid WithTitle:@"High/Low" withProperty:@"high" withCellType:[SDataGridHighLowCell class] andWidth:345];
            
    // create the helper
    _bottomGridDatasourceHelper = [[SDataGridDataSourceHelper alloc] initWithDataGrid:_bottomGrid];
    
    // set the delegate for the helper
    _bottomGridDataSourceHelperDelegate = [[BottomGridDataSourceHelperDelegate alloc] init];
    _bottomGridDatasourceHelper.delegate = _bottomGridDataSourceHelperDelegate;
    
    _bottomGrid.scrollsToTop = YES;
    
    // add grid to bottomView
    [_bottomView addSubview:_bottomGrid];
}

-(void)addColumnToGrid:(ShinobiDataGrid*)grid WithTitle:(NSString*)title withProperty:(NSString*)property withCellType:(Class)cellType andWidth:(NSInteger)width{
    SDataGridColumn *gridColumn = [[SDataGridColumn alloc] initWithTitle:title forProperty:property];
    [gridColumn setCellType:cellType];
    [grid addColumn:gridColumn];
    [gridColumn setWidth:[NSNumber numberWithLong:width]];
}

-(void)styleGrid:(ShinobiDataGrid*)dataGrid{
    
    // Perform some additional methods on both grids such as setting the back ground color...   
    [dataGrid setBounces:NO];
    [dataGrid setSelectionMode:SDataGridSelectionModeNone];
    [dataGrid setDefaultHeaderRowHeight:[NSNumber numberWithFloat:_leftTopGridLabel.bounds.size.height]];
    
    //... setting the header cell styles...
    SDataGridCellStyle *sDataGridStyleHeaderRow = [SDataGridCellStyle new];
    [sDataGridStyleHeaderRow setTextAlignment:NSTextAlignmentCenter];
    [sDataGridStyleHeaderRow setFont:_headerFont];
    [sDataGridStyleHeaderRow setTextColor:[UIColor textColor]];
    [sDataGridStyleHeaderRow setBackgroundColor:[UIColor backgroundColorGray]];
    [dataGrid setDefaultCellStyleForHeaderRow:sDataGridStyleHeaderRow];
    
    //..and cell style...
    SDataGridCellStyle *sDataGridStyleRows = [SDataGridCellStyle new];
    [sDataGridStyleRows setTextAlignment:NSTextAlignmentCenter];
    [sDataGridStyleRows setFont:_headerFont];
    [sDataGridStyleRows setTextColor:[UIColor textColor]];
    [sDataGridStyleRows setBackgroundColor:[UIColor backgroundColor]];
    [dataGrid setDefaultCellStyleForRows:sDataGridStyleRows];
    [dataGrid setDefaultCellStyleForAlternateRows:sDataGridStyleRows];
  
    //... and the grid line style.
    SDataGridLineStyle *sDataGridLineStyle = [SDataGridLineStyle new];
    [sDataGridLineStyle setColor:[UIColor gridBorderColor]];
    [sDataGridLineStyle setWidth:1];
    [dataGrid setDefaultGridLineStyle:sDataGridLineStyle];
  
}

// When keyboard hides, search for weather data at newly specified location
-(void)keyboardDidHide:(NSNotification *)aNotification {
    
    NSString *urlString = [NSString stringWithFormat:PLACE_FINDER_URL_PLACE_NAME, [_locationFinder text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
    @try{
        
        PlaceFinder *placeFinder = [PlaceFinder new];
        _places = [placeFinder parseXMLFileAtURL:request];
            
        NSString *WOEID = [self getUserToPickNewWOEID];
        
        if(WOEID != nil){
            [self getAndDisplayWeatherDataForWOEID:WOEID];
        }
    }
    @catch(InvalidLocationException *e){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, we weren't able to find that location. Please try a different location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_locationFinder setText:_previousLocation];
}

// Pass location name URL request to Yahoo and retreives associated WOEID
-(NSString*)getUserToPickNewWOEID{
            
    NSInteger totalLocations = [_places count];
    
    if(totalLocations < 1){ // If yahoo returns no matches for entered place name return nil
        @throw([InvalidLocationException exceptionWithName:@"Invalid Location" reason:@"Location in request is invalid" userInfo:nil]);
    }
    else if(totalLocations == 1){ // If yahoo returns one match for entered place name then return WOEID
        return [_places[0] woeid];
    }
    else{ // If yahoo more then one WOEID for given place name then ask the user to pick which one they meant
        
        _placeNames = [NSMutableArray new];
        for(Place *place in _places){
        
            NSMutableArray *placeInfo = [@[[place city], [place county], [place state], [place country], [place countrycode]] mutableCopy];
            [_placeNames addObject:[self getLocationNameFromArray:placeInfo]];
        
        }
        
        NSInteger height = (PLACES_TABLE_HEIGHT < ([_places count] * PLACES_TABLE_ROW_HEIGHT)) ? PLACES_TABLE_HEIGHT : ([_places count] * PLACES_TABLE_ROW_HEIGHT);
             
        UITableView *clarificationTable = [[UITableView alloc] initWithFrame:CGRectMake((([self view].bounds.size.width / 2) - (PLACES_TABLE_WIDTH / 2)), MARGIN + (TOPBAR_HEIGHT * 0.7), PLACES_TABLE_WIDTH, height)];
        [[clarificationTable layer] setCornerRadius:5];
        [clarificationTable setBounces:NO];
        clarificationTable.dataSource = self;
        clarificationTable.delegate = self;
        clarificationTable.hidden = NO;
        [[self view] addSubview:clarificationTable];
        
        [_locationFinder setUserInteractionEnabled:NO];

        return nil;
    }
}

// Get weather data from yahoo pertaining to a specific location as speficied by a WOEID
-(void) getAndDisplayWeatherDataForWOEID:(NSString*)WOEID{
    WeatherDataObject *weatherDataObject;
    
    RSSFeedReader *feedReader = [RSSFeedReader new];
    NSString *feedAddressString = [NSString stringWithFormat:WOEID_URL, WOEID];
    
    @try{
        
        weatherDataObject = [feedReader parseXMLFileAtURL:feedAddressString];
        [self updateUIWithWeatherAtLocation:weatherDataObject];
    }
    @catch(InvalidWeatherDataException *e){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, we weren't able to obtain weather data for that location. Please try a different location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        weatherDataObject = nil;
        
    }
}

// Updates the UI with weather information provided by Yahoo for specific WOEID
-(void) updateUIWithWeatherAtLocation:(WeatherDataObject*)weatherDataObject{
    
    [_locationFinder setText:[weatherDataObject locationCity]];
    
    // If we have region data (e.g. city, state, county, country) about the location then display it in the UI
    NSMutableArray *locationInformation = [[NSMutableArray alloc] init];
    
    if([weatherDataObject locationCity] != nil) {
        [locationInformation addObject:[weatherDataObject locationCity]];
    }
    if([weatherDataObject locationRegion] != nil){
        [locationInformation addObject:[weatherDataObject locationRegion]];
    }
    if([weatherDataObject locationCountry] != nil){
        [locationInformation addObject:[weatherDataObject locationCountry]];
    }
    if([locationInformation count] > 0){
        [_locationInfoLabel setText:[self getLocationNameFromArray:locationInformation]];
    }
    else{
        [_locationInfoLabel setText:@""];
    }  
    
    if([weatherDataObject itemConditionDate]){
        
        // Yahoo provides time for sunrise and sunset e.g. 7:02 am and sunset e.g. 4:51 pm
        // We then convert the NSStrings provided into NSDates
        if(dateFormatterBoundaryDate == nil){
            dateFormatterBoundaryDate = [[NSDateFormatter alloc] init];
            [dateFormatterBoundaryDate setDateFormat:@"h:mm a"];
        }
        
        // Parse the NSString given to us by Yahoo (e.g. Thu, 30 May 2013 5:28pm AEST) because the provided Times Zones e.g. BST and AEST don't always equate to those used by iOS, and because parsing days of the week can be a problem if we expect them to be in English but they are not
        NSArray *currentTimeFragment = [[weatherDataObject itemConditionDate] componentsSeparatedByString:@" "];
        NSDate *currentTime = [dateFormatterBoundaryDate dateFromString: [NSString stringWithFormat:@"%@ %@", currentTimeFragment[4], currentTimeFragment[5]]];
        
        NSDate *sunriseTime = [dateFormatterBoundaryDate dateFromString:[weatherDataObject astronomySunrise]];
        NSDate *sunsetTime = [dateFormatterBoundaryDate dateFromString:[weatherDataObject astronomySunset]];
        
        // However we are only interested in the times and not dates so the date related information is discarded.
        unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSDateComponents* components = [calendar components:flags fromDate:currentTime];
        currentTime = [calendar dateFromComponents:components];
        
        components = [calendar components:flags fromDate:sunriseTime];
        sunriseTime = [calendar dateFromComponents:components];
        
        components = [calendar components:flags fromDate:sunsetTime];
        sunsetTime = [calendar dateFromComponents:components];
        
        // We then compare the dates to see if is daytime or night time according to time Yahoo provides for sunrise and sunset
        UIImage *daytimeIndicatorImage;
        if(([currentTime compare:sunriseTime] == NSOrderedDescending) && ([currentTime compare:sunsetTime] == NSOrderedAscending)){
            daytimeIndicatorImage = [UIImage imageNamed:@"sun.png"];
            [_daytimeIndicatorLabel setTextColor:[UIColor blackColor]];
        }
        else{
            daytimeIndicatorImage = [UIImage imageNamed:@"moon.png"];
            [_daytimeIndicatorLabel setTextColor:[UIColor whiteColor]];
        }
        [_daytimeIndicatorLabel setText:currentTimeFragment[5]];
        [_daytimeIndicatorImageView setImage:daytimeIndicatorImage];
        
        // If we have data on when the weather data was last accurate then display it in the UI
        [_timeInfoLabel setText:[weatherDataObject itemConditionDate]];
    }
    else{
        [_timeInfoLabel setText:@""];
    }
    
    // Display todays average temperature in the UI
    if([weatherDataObject itemConditionTemp]){
        NSString *avgTemp = [[weatherDataObject itemConditionTemp] mutableCopy];
        avgTemp = [[avgTemp stringByAppendingString:@"°C"] mutableCopy];
        if([avgTemp integerValue] > 25){
            [_avgTempLabel setTextColor:[UIColor weatherDemoRed]];
        }
        else{
            [_avgTempLabel setTextColor:[UIColor weatherDemoBlue]];
        }
        [_avgTempLabel setText:[NSString stringWithString:avgTemp]];
    }
    
    // supply data to the topGridDatasourcehelper
    NSArray *topGridData = [[NSArray alloc] initWithObjects:weatherDataObject, nil];
    _topGridDatasourceHelper.data = topGridData;
    
    // supply data to the bottomGridDatasourcehelper
    NSArray *bottomGridData = [[NSMutableArray alloc] initWithArray:[weatherDataObject listOfWeatherForecastItems]];
    _bottomGridDatasourceHelper.data = bottomGridData;
    
    _previousLocation = [_locationFinder text];
}


-(NSString*)getLocationNameFromArray:(NSMutableArray*)array{
    [array removeObject:@""];
    return [array componentsJoinedByString:@", "];
}

-(void)setDaytimeIndicatorWithImageNamed:(NSString*)imageName andWithText:(NSString*)text{
    UIImage *daytimeIndicatorImage = [UIImage imageNamed:imageName];
    [_daytimeIndicatorImageView setImage:daytimeIndicatorImage];
    [_daytimeIndicatorLabel setText:text];
}

-(void)updateUIForLatitude:(NSString*)latitude andLongitude:(NSString*)longitude{
    
    // Prepare URL
    NSString *urlString = [NSString stringWithFormat:PLACE_FINDER_URL_LAT_LONG, latitude, longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    @try{
        PlaceFinder *placeFinder = [PlaceFinder new];
        _places = [placeFinder parseXMLFileAtURL:request];
        
        NSString *WOEID = [self getUserToPickNewWOEID];
        
        [self getAndDisplayWeatherDataForWOEID:WOEID];
    }
    @catch(InvalidLocationException *e){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, we weren't able to find that location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get iPad location:\n\nUsing default location instead." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSString *latitude = @"54.255000";
    NSString *longitude = @"-1.600000";
    [self updateUIForLatitude:latitude andLongitude:longitude];    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{    
    _currentLocation = [newLocation coordinate];
    NSString *latitude = [NSString stringWithFormat:@"%f", _currentLocation.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", _currentLocation.longitude];
    [_locationManager stopUpdatingLocation];
    
    [self updateUIForLatitude:latitude andLongitude:longitude];
}

#pragma UITable DataSource Methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Please clarify which of the following locations you meant:"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_placeNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *cellValue = [_placeNames objectAtIndex:indexPath.row];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.text = cellValue;
    
    return cell;
}

#pragma UITable Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self getAndDisplayWeatherDataForWOEID:[[_places objectAtIndex:indexPath.row] woeid]];
    
    [tableView removeFromSuperview];
    
    [_locationFinder setUserInteractionEnabled:YES];
}

@end
