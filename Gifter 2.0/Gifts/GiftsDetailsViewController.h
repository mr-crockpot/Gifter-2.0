//
//  GiftsDetailsViewController.h
//  Gifter 2.0
//
//  Created by Adam Schor on 4/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface GiftsDetailsViewController : UIViewController

@property (strong,nonatomic) DBManager *dbManager;

@property (strong, nonatomic) NSMutableArray *arrGifts;

@property NSInteger giftID;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldGiftName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtFieldOutlets;

@end
