//
//  PeopleTableViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "GeneralMethods.h"



@interface PeopleTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>


@property BOOL editable;

//@property GeneralMethods *generalMethods;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSMutableArray *arrPeople;
//@property (nonatomic, strong) NSMutableArray *arrPeopleCopy;

@property (nonatomic, strong) NSMutableArray *arrGroups;
@property (strong, nonatomic) NSMutableArray *subArrPeople;
@property (strong, nonatomic) NSMutableArray *arrIndexOfPeopleIDs;


@property NSInteger activePerson;


@property (strong, nonatomic) IBOutlet UITableView *tblViewPeople;



@end
