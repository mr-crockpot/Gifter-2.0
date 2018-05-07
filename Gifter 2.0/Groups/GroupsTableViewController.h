//
//  GroupsTableViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface GroupsTableViewController : UITableViewController

@property (strong,nonatomic) DBManager *dbManager;

@property (strong, nonatomic) NSMutableArray *arrayGroups;

@property NSInteger groupID;

@property BOOL editable;
@end
