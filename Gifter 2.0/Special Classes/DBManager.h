//
//  DBManager.h
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFileName;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrResults;
-(void)runQuery: (const char*)query isQueryExecutable: (BOOL)queryExectutable;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(NSMutableArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;


@end
