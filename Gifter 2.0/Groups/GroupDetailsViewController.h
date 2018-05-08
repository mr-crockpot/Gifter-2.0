//
//  GroupDetailsViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 5/7/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface GroupDetailsViewController : UIViewController

@property (strong, nonatomic) DBManager *dbManager;

@property (strong, nonatomic) NSMutableArray *arrGroups;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldGroupName;

@end
