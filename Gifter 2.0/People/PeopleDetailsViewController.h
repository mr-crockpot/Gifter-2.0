//
//  PeopleDetailsViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/24/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"



@interface PeopleDetailsViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property DBManager *dbManager;



@property (strong, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldLastName;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtFieldOutlets;

@property NSInteger activePerson;

//ARRAYS
@property (strong, nonatomic) NSMutableArray *arrPeopleDetails;
@property (strong, nonatomic) NSMutableArray *arrAllGifts;
@property (strong, nonatomic) NSMutableArray *arrSelectedGifts;

@property (strong, nonatomic) NSMutableArray *arrPeopleGifts;
@property (strong, nonatomic) NSMutableArray *arrEvents;
@property (strong, nonatomic) NSMutableArray *arrSectionData;



@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentPeopleDetails;
- (IBAction)segmentPeopleDetailsSelected:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblViewPeopleDetails;


@end
