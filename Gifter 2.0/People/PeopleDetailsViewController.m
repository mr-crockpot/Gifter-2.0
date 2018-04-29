//
//  PeopleDetailsViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 3/24/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "PeopleDetailsViewController.h"

@interface PeopleDetailsViewController ()

@end

@implementation PeopleDetailsViewController

- (void)viewDidLoad {
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    [super viewDidLoad];
    
    for (UITextField *txtField in _txtFieldOutlets) {
        txtField.layer.borderColor = [[UIColor blueColor] CGColor];
        txtField.layer.borderWidth = 2;
    }
 
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [self saveData];
}
-(void)loadData{
    NSString *queryPerson;
    if (_activePerson != -1) {

    queryPerson = [NSString stringWithFormat:@"Select * from people where peopleID = %li",_activePerson];
    _arrPeopleDetails = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPerson]];
    _txtFieldFirstName.text = _arrPeopleDetails[0][1];
    _txtFieldLastName.text = _arrPeopleDetails [0][2];
    }

}

-(void)saveData {
    NSString *querySave;
    NSString *querySaveGroup;
    NSString *queryFindMax;
    NSMutableArray *arrMaxPeopleID;
    NSInteger maxPeopleID;
    
    if (_activePerson != -1) {
        querySave = [NSString stringWithFormat:@"UPDATE people SET firstname='%@', lastname='%@' where peopleID= %li",_txtFieldFirstName.text,_txtFieldLastName.text,_activePerson];
    } else { // _activePerson is -1, which means we're adding a new person
        if (_txtFieldLastName.text != nil || _txtFieldFirstName !=nil) {
            querySave = [NSString stringWithFormat:@"INSERT INTO people (peopleID,firstname,lastname) VALUES (null, '%@', '%@')", _txtFieldFirstName.text, _txtFieldLastName.text];
            
            //Find new active person value
            queryFindMax = @"select max(people.peopleID) from people";
            arrMaxPeopleID = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryFindMax]];
           
            maxPeopleID = [arrMaxPeopleID[0][0] integerValue] + 1;
            querySaveGroup = [NSString stringWithFormat:@"INSERT INTO peopleGroups VALUES (null,%li,1)",maxPeopleID];
           }
    }
    
    [_dbManager executeQuery:querySave];
    [_dbManager executeQuery:querySaveGroup];
    
#pragma mark TEST AREA
   /* NSString *testQuery = @"SELECT * FROM people";
    NSMutableArray *testArray = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:testQuery]];
    NSLog(@"The people array is now %@",testArray);
    NSString *testQueryGroup = @"SELECT * FROM peopleGroups";
    NSMutableArray *testArrayGroup = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:testQueryGroup]];
    NSLog(@"The group array is now %@",testArrayGroup);
    */
    
    
#pragma mark END TEST AREA
 }
@end
