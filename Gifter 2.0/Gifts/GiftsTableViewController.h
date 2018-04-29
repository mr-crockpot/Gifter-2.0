//
//  GiftsTableViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface GiftsTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSMutableArray *arrGifts;
@property (nonatomic, strong)  NSMutableArray *arrIndexOfGiftsIDs;

@property NSInteger giftID;

@property BOOL editable;
@property (strong, nonatomic) IBOutlet UITableView *tblViewGifts;







@end
