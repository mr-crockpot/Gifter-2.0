//
//  EventsDetailsViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 4/29/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"



@interface EventsDetailsViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) DBManager *dbManager;


@property (strong, nonatomic) IBOutlet UITextField *txtFieldEventName;



@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewCustomDate;

@property (strong, nonatomic) NSMutableArray *arrMonths;
@property (strong, nonatomic) NSMutableArray *arrDays;
@property (strong, nonatomic) NSMutableArray *arrYears;
@property (strong, nonatomic) NSMutableArray *arrEvents;
@property NSInteger monthRowSelected;

@property BOOL eventRecurs;
- (IBAction)switchRecursMoved:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switchRecurs;
@property (strong, nonatomic) IBOutlet UISwitch *switchDateNoDate;
- (IBAction)swithcDateNoDateMoved:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblNoDate;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property BOOL hasDate;

@property NSInteger day;
@property NSInteger month;
@property NSInteger year;


@end
