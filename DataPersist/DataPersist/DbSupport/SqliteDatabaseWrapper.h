//
//  DatabaseWrapper.h
//  AuroraPhone
//
//  Created by Yao Melo on 11/14/12.
//
//

#import <Foundation/Foundation.h>
#include "sqlite3.h"

typedef enum _SqliteColumnType
{
    eColumnTypeNull = SQLITE_NULL,
    eColumnTypeText = SQLITE_TEXT,
    eColumnTypeInteger = SQLITE_INTEGER,
    eColumnTypeFloat = SQLITE_FLOAT,
    eColumnTypeBlob = SQLITE_BLOB
}SqliteColumnType;

@interface SqliteColumnDescriptor : NSObject

@property(nonatomic,retain) NSString* name;
@property(nonatomic,assign) SqliteColumnType type;

@property(nonatomic,readonly) NSString* typeRepresentedByString;

+(SqliteColumnDescriptor*) descriptorWithColumnName:(NSString*)name andType:(SqliteColumnType) type;

@end

@interface SqliteDatabaseWrapper : NSObject
{
    NSString* _path;
    sqlite3 *_sqliteDb;
}

-(id)initWithPath:(NSString*) path;

#pragma mark - table operations
-(void)createNotExistTableWithName:(NSString *)name primaryKey:(NSString*)keyName columnDescriptors:(NSArray *)columnDescriptors;

#pragma mark - column operations
-(BOOL)checkColumnExists:(NSString *)columnname from:(NSString*)tablename;

-(NSArray*)columnsOfTable:(NSString*) tableName;

#pragma mark - row operations
-(void)executeSql:(NSString*)sql withParameters:(id)stringOrNumber,... NS_REQUIRES_NIL_TERMINATION;

-(void)executeSql:(NSString*)sql withParameterArray:(NSArray*) paramsArray;

-(NSArray*)querySql:(NSString*)sql withParameters:(id)stringOrNumber,... NS_REQUIRES_NIL_TERMINATION;

-(NSArray*)querySql:(NSString*)sql withParameterArray:(NSArray*) paramsArray;

-(void)insertRow:(NSDictionary*) row toTable:(NSString*) tablename;

-(void)updateRow:(NSDictionary *)row toTable:(NSString *)tablename index:(NSInteger)rowid;

#pragma mark - transactions
-(void) beginTransaction;

-(void) rollbackTransaction;

-(void) commitTransaction;

#pragma mark - db management.
-(void) open;

-(void) close;

@end
