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
    _arrSectionData = [[NSMutableArray alloc] init];
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
    NSMutableArray *arrInsertLine;
    NSString *queryPerson;
    if (_activePerson != -1) {

    queryPerson = [NSString stringWithFormat:@"Select * from people where peopleID = %li",_activePerson];
    _arrPeopleDetails = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPerson]];
    _txtFieldFirstName.text = _arrPeopleDetails[0][1];
    _txtFieldLastName.text = _arrPeopleDetails [0][2];
    }
    
    NSString *queryAllGifts =[NSString stringWithFormat:@"select gifts.giftID, gifts.giftname, ifnull(peopleGifts.eventID,-1) from gifts left join peopleGifts on gifts.giftID = peopleGifts.giftID and peopleGifts.peopleID = %li",_activePerson];
    _arrAllGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryAllGifts]];
    
    
    if (_arrAllGifts.count == 0) {
        [_arrAllGifts addObject:@"No gifts"];
    }
    
    NSString *queryPeopleGifts = [NSString stringWithFormat:@"select gifts.giftID, gifts.giftname, ifnull(peopleGifts.eventID,-1) from gifts join peopleGifts on gifts.giftID = peopleGifts.giftID and peopleGifts.peopleID = %li",_activePerson];
    _arrPeopleGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeopleGifts]];
    if (_arrPeopleGifts.count == 0) {
        [_arrPeopleGifts addObject:@"No gifts"];
    }
    
    NSString *queryEvents = [NSString stringWithFormat:@"select events.eventID, events.eventName, ifnull(events.month,-1),ifnull(events.day,-1),ifnull(events.year,-1) from events join peopleEvents on events.eventID = peopleEvents.eventID  and peopleEvents.peopleID = %li",_activePerson];
    _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryEvents]];
    arrInsertLine = [[NSMutableArray alloc] initWithObjects:@-1,@"Unassigned Gifts",@-1,@-1,@-1,nil];
    [_arrEvents addObject:arrInsertLine];
    
    if (_arrEvents.count == 0) {
        arrInsertLine = [[NSMutableArray alloc] initWithObjects:@"Zero",@"No Assigned Events",@"Two", nil];
        [_arrEvents addObject:arrInsertLine];
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
- (IBAction)segmentPeopleDetailsSelected:(id)sender {
    
}


#pragma mark TABLE CODES AREA


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAllGifts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return _arrEvents.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    NSString *eventName;
    NSString *eventDate;
  
   [_arrSectionData addObject:_arrEvents[section][0]];
  
    eventName = _arrEvents[section][1];
    eventDate = [NSString stringWithFormat:@"         (%@/%@/%@)",_arrEvents[section][2],_arrEvents[section][3],_arrEvents[section][3]];
    sectionName = [NSString stringWithFormat:@"       %@ %@",eventName,eventDate];
   // sectionName = @"Name";
   return sectionName;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
        NSString *title;
         NSInteger sectionData =  [_arrSectionData[indexPath.section]integerValue];
         NSInteger giftData = [_arrAllGifts[indexPath.row][2]integerValue];
    
    if (sectionData==giftData) {
        NSLog(@"We have a match %li %li",sectionData,giftData);
        title = _arrAllGifts[indexPath.row][1];
    }
    
    else {
        title = @"blank";
    }
    
    cell.textLabel.text = title;
    return cell;
}

@end
