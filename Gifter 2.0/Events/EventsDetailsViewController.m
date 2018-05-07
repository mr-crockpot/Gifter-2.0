//
//  EventsDetailsViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 4/29/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "EventsDetailsViewController.h"

@interface EventsDetailsViewController ()

@end

@implementation EventsDetailsViewController

- (void)viewDidLoad {
   
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadMonths];
    [self loadYears];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self saveData];
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows;
    switch (component) {
        case 0:
            rows = _arrMonths.count;
            break;
        case 1:
            rows = _arrDays.count;
            break;
        case 2:
            rows = _arrYears.count;
            break;
        default:
            rows = 0;
            break;
    }
    return rows;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_eventRecurs == YES) {
        return 2;
    }
    else{
        return 3;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle;
    switch (component) {
        case 0:
            rowTitle = _arrMonths[row];
            break;
        case 1:
            rowTitle = [_arrDays[row] stringValue];
            break;
        case 2:
            rowTitle = [_arrYears[row] stringValue];
        default:
            
            break;
    }
   
    return rowTitle;
    
}

-(void)saveData{
    NSString *querySavaData;
    
    querySavaData = [NSString stringWithFormat:@"INSERT INTO events (eventID,eventname,month,day,year) VALUES (null, '%@', %li,%li,%li)",_txtFieldEventName.text,_month,_day,_year];
    
    [_dbManager executeQuery:querySavaData];
    
    
}



-(void)loadMonths{
  
    _arrMonths = [[NSMutableArray alloc] init];
    NSMutableArray *monthNames =  [[NSMutableArray alloc] initWithObjects:@"January", @"February", @"March", @"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
//    for (int r = 0; r<100; r++) {
        
    for (NSInteger m=0; m<12; m++) {
        [_arrMonths addObject:monthNames[m]];
    }
  //  }
    
    

}

-(void)loadDays:(NSString *)month {
    _arrDays = [[NSMutableArray alloc] init];
    int days = 30;
    
    if ([month isEqualToString:@"January"]||[month isEqualToString:@"March"]||[month isEqualToString:@"May"]||[month isEqualToString:@"July"]||[month isEqualToString:@"August"]||[month isEqualToString:@"October"]||[month isEqualToString:@"December"]){
        days = 31;
        
    }
    
    if ([month isEqualToString:@"February"]) {
        days = 29;
    }
    
    
 //   for (int r = 0; r<100; r++) {
       
        for (int x = 1; x <= days; x++) {
       
        [_arrDays addObject:@(x)];
        }
 //   }
    
    [_pickerViewCustomDate reloadAllComponents];
    
}

-(void)loadYears{
    
    _arrYears =[[NSMutableArray alloc] init];
    for (int y = 2018; y<=2038; y++) {
        [_arrYears addObject:@(y)];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    NSString *selectedMonth;
    switch (component) {
        case 0:
            selectedMonth = _arrMonths[row];
            _month = row+1;
            [self loadDays:selectedMonth];
            break;
        
        default:
            break;
    }
 
    if (!_eventRecurs){
    _year = [_arrYears [[_pickerViewCustomDate selectedRowInComponent:2]] integerValue];
    }
    _day = [[NSString stringWithFormat:@"%li",[_pickerViewCustomDate selectedRowInComponent:1] ] integerValue] + 1;
    
    
    
    

   
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchRecursMoved:(id)sender {
    if (_switchRecurs.isOn) {
        _eventRecurs = YES;
        _year = 0;
       
    }
    else {
        _eventRecurs = NO;
      
        
    }
    [_pickerViewCustomDate reloadAllComponents];
}
- (IBAction)swithcDateNoDateMoved:(id)sender {
    _hasDate = !_hasDate;
    
    if (_hasDate == YES) {
        NSLog(@"Has date");
        _lblDate.textColor = [UIColor redColor];
        _lblNoDate.textColor = [UIColor grayColor];
        _pickerViewCustomDate.hidden = NO;
        
    }
    else {
        NSLog(@"No date");
        _lblNoDate.textColor = [UIColor redColor];
        _lblDate.textColor = [UIColor grayColor];
        _pickerViewCustomDate.hidden = YES;
        _month = 0;
        _day = 0;
        _year = 0;
    }
    
}
@end
