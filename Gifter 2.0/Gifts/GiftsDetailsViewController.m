//
//  GiftsDetailsViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 4/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "GiftsDetailsViewController.h"


@interface GiftsDetailsViewController ()

@end

@implementation GiftsDetailsViewController

- (void)viewDidLoad {
    

    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    for (UITextField *txtField in _txtFieldOutlets) {
        txtField.layer.borderColor = [[UIColor redColor] CGColor];
        txtField.layer.borderWidth = 2;
    }
    
    [self loadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self saveData];
}

-(void)loadData{
    
    NSString *queryGifts;
    if (_giftID != -1) {
        queryGifts = [NSString stringWithFormat:@"SELECT * FROM gifts where giftID = %li",_giftID];
        _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryGifts]];
        _txtFieldGiftName.text = _arrGifts[0][1];
        _textFieldPrice.text = _arrGifts[0][2];
    }
}

-(void)saveData{

    NSString *querySave;
    /*
     UPDATE people SET firstname='%@', lastname='%@' where peopleID= %li",_txtFieldFirstName.text,_txtFieldLastName.text,_activePerson
     */
    if (_giftID != -1) {
        querySave =[NSString stringWithFormat:@"UPDATE gifts SET giftname = '%@', price = %li where giftID = %li",_txtFieldGiftName.text,[_textFieldPrice.text integerValue],_giftID];
    }
    else {
        querySave = [NSString stringWithFormat:@"INSERT INTO gifts (giftID,giftname,price) VALUES (null, '%@', '%@')", _txtFieldGiftName.text, _textFieldPrice.text];
    }


[_dbManager executeQuery:querySave];

    
}


@end
