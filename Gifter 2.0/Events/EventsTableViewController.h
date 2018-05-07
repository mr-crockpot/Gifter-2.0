//
//  EventsTableViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface EventsTableViewController : UITableViewController

@property (strong, nonatomic) DBManager *dbManager;

@property (strong, nonatomic) NSMutableArray *arrEvents;
@property NSInteger eventID;

@property (strong, nonatomic) IBOutlet UITableView *tblViewEvents;

@property BOOL editable;

@end
