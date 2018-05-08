//
//  GroupDetailsViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 5/7/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "GroupDetailsViewController.h"

@interface GroupDetailsViewController ()

@end

@implementation GroupDetailsViewController

- (void)viewDidLoad {
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    [self loadData];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
    [self saveData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    NSString *queryLoadData = @"SELECT * FROM groups";
    _arrGroups = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryLoadData]];
    
}

-(void)saveData {
    
    /*
      querySavaData = [NSString stringWithFormat:@"INSERT INTO events (eventID,eventname,month,day,year) VALUES (null, '%@', %li,%li,%li)",_txtFieldEventName.text,_month,_day,_year];
     
     */
    NSString *querySaveData = [NSString stringWithFormat:@"INSERT INTO groups (groupID,groupname) VALUES (null,'%@')",_txtFieldGroupName.text];
    
    [_dbManager executeQuery:querySaveData];
    
    NSLog(@"The updated group array is %@",_arrGroups);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
