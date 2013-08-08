//
//  SqliteDatabaseWrapper.m
//  AuroraPhone
//  Implemented as the simple Objective C style sqlite API
//  Created by Yao Melo on 11/14/12.
//
//

#import "SqliteDatabaseWrapper.h"

@class SqliteColumnDescriptor;

static inline SqliteColumnType typeFromTypeName(const char * typename)
{
    SqliteColumnType type;
    char head = typename[0];
    if(head>'Z')//Capitalize.
    {
        head -= ('a' - 'A');
    }
    switch(head)
    {
        case 'T'://text
            type = eColumnTypeText;
            break;
        case 'I'://integer
            type = eColumnTypeInteger;
            break;
        case 'R'://real
            type = eColumnTypeFloat;
            break;
        case 'B'://blob
            type = eColumnTypeBlob;
            break;
        case 'N'://null
            type = eColumnTypeNull;
            break;
        default:
            type = eColumnTypeText;
    }
    return type;
}

int ColunmInfoCallback(void* outArr,int columnsCount, char** textValue, char** columnNames)
{
    NSMutableArray *array = (NSMutableArray *)outArr;
    NSString *nameStr = nil;
    SqliteColumnType type = eColumnTypeNull;
    for (int i = 0; i<columnsCount; i++) {
        char* text = textValue[i];
        char* columnName = columnNames[i];

        if(strcmp("type", columnName) == 0)
        {
            type = typeFromTypeName(text);
        }
        else if(strcmp("name", columnName) == 0)
        {
            nameStr = [NSString stringWithUTF8String:text];
        }
    }
    if(nameStr!=nil)
    {
        [array addObject:[SqliteColumnDescriptor descriptorWithColumnName:nameStr andType:type]];
    }
    return 0;
}

@implementation SqliteColumnDescriptor
@synthesize name;
@synthesize type;

+(SqliteColumnDescriptor *)descriptorWithColumnName:(NSString *)name andType:(SqliteColumnType)type
{
    SqliteColumnDescriptor *desc = [[[SqliteColumnDescriptor alloc] init]autorelease];
    desc.name = name;
    desc.type = type;
    return desc;
}

-(NSString *)typeRepresentedByString
{
    NSString* strType = nil;
    switch (type) {
        case eColumnTypeText:
            strType = @"TEXT";
            break;
        case eColumnTypeInteger:
            strType = @"INTEGER";
            break;
        case eColumnTypeFloat:
            strType = @"REAL";
            break;
        case eColumnTypeBlob:
            strType = @"BLOB";
            break;
        case eColumnTypeNull:
            strType = @"NULL";
            break;
        default:
            break;
    }
    return strType;
}

- (void)dealloc
{
    [name release];
    [super dealloc];
}
@end

@implementation SqliteDatabaseWrapper

-(id)initWithPath:(NSString *)path
{
    self = [super init];
    if(self)
    {
        _path = [path retain];
    }
    return self;
}


- (void)dealloc
{
    [_path release];
    if(_sqliteDb)
    {
        //just ignore the bad result
        sqlite3_close(_sqliteDb);
    }
    [super dealloc];
}

-(id) getObjcValue:(sqlite3_stmt *)statm index:(int) index forType:(SqliteColumnType) type
{
    id objcType = nil;
    switch (type) {
        case eColumnTypeText:
        {
            const char* ctext = (const char*)sqlite3_column_text(statm, index);
            if(ctext!= NULL)
            {
                objcType = [NSString stringWithUTF8String:ctext];
            }
            break;
        }
        case eColumnTypeInteger:
            //int
            objcType = [NSNumber numberWithLongLong:sqlite3_column_int64(statm, index)];
            break;
        case eColumnTypeFloat:
            objcType = [NSNumber numberWithDouble:sqlite3_column_double(statm, index)];
            break;
        case eColumnTypeBlob:
            objcType = [NSData dataWithBytes:sqlite3_column_blob(statm, index) length:sqlite3_column_bytes(statm, index)];
            break;
        case eColumnTypeNull:
            objcType = [NSNull null];
            break;
        default:
            break;
    }
    return objcType;
}

-(void)close
{
    if(_sqliteDb)
    {
        int result = sqlite3_close(_sqliteDb);
        if(result != SQLITE_OK)
        {
             [NSException raise:@"SqliteException" format:@"Database cannot close, error:%d",result];
        }
        _sqliteDb = NULL;
    }
}

-(void)open
{
    int result = sqlite3_open([_path UTF8String], &_sqliteDb);
    if(result != SQLITE_OK)
    {
        _sqliteDb = NULL;
        [NSException raise:@"SqliteException" format:@"Database cannot open, error:%d",result];
    }
}

-(void)createNotExistTableWithName:(NSString *)name primaryKey:(NSString*)keyName columnDescriptors:(NSArray *)columnDescriptors
{
    char* errMsg;
    //make up the sql string
    NSMutableString *sql = [NSMutableString stringWithCapacity:50];
    [sql appendFormat:@"create table if not exists %@ (%@ integer primary key",name,keyName];
    for(SqliteColumnDescriptor* descriptor in columnDescriptors)
    {
        [sql appendFormat:@",%@ %@",descriptor.name,descriptor.typeRepresentedByString];
    }
    [sql appendString:@")"];
    int result =  sqlite3_exec(_sqliteDb, [sql UTF8String], NULL, NULL, &errMsg);
    if(result != SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to create table %@,reason:%s error:%d",name,errMsg, result];
    }
}

-(NSArray*)columnsOfTable:(NSString*) tableName
{
    NSString *sql = [NSString stringWithFormat:@"pragma table_info('%@')",tableName];
    char* errMsg;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    int result = sqlite3_exec(_sqliteDb, [sql UTF8String], ColunmInfoCallback, array, &errMsg);
    if(result != SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to get columns info of table %@,reason:%s error:%d",tableName,errMsg, result];
    }
    return array;
}

-(BOOL)checkColumnExists:(NSString *)columnname from:(NSString*)tablename
{
    NSArray *arr = [self columnsOfTable:tablename];
    for(SqliteColumnDescriptor *desc in arr)
    {
        if([desc.name isEqualToString:columnname])
        {
            return YES;
        }
    }
    return NO;
}

-(void)executeSql:(NSString *)sql withParameterArray:(NSArray *)paramsArray
{
    sqlite3_stmt *statm;
    int result = sqlite3_prepare(_sqliteDb, [sql UTF8String], -1, &statm, NULL);
    if(result !=SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to prepare statement, error:%d", result];
    }
    int index = 1;
    for(id arg in paramsArray)
    {
        //do with the mutiple params
        if([arg isKindOfClass:[NSString class]])
        {
            sqlite3_bind_text(statm, index, [arg UTF8String], -1, SQLITE_TRANSIENT);
        }
        else if([arg isKindOfClass:[NSNumber class]])
        {
            const char* objctype = [arg objCType];
            
            if(strcmp(objctype, @encode(double)) == 0 || strcmp(objctype, @encode(float)) == 0)
            {
                sqlite3_bind_double(statm, index, [arg doubleValue]);
            }
            else
            {
                sqlite3_bind_int64(statm, index, [arg longLongValue]);
            }
        }
        
        index++;
    }
    
    
    if((result = sqlite3_step(statm)) != SQLITE_DONE)
    {
        if(result == SQLITE_ROW)
        {
            [NSException raise:@"SqliteException" format:@"Failed to execute the sql,seems you're running a query,error:%d", result];
        }
        else
        {
            [NSException raise:@"SqliteException" format:@"Failed to execute the sql,error:%d", result];
        }
        
    }
    
    sqlite3_finalize(statm);
}

-(void)executeSql:(NSString *)sql withParameters:(id)stringOrNumber, ...
{
    sqlite3_stmt *statm;
    int result = sqlite3_prepare(_sqliteDb, [sql UTF8String], -1, &statm, NULL);
    if(result !=SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to prepare statement, error:%d", result];
    }
    
    va_list args;
    va_start(args, stringOrNumber);
    int index = 1;
    for(id arg =stringOrNumber;arg!=nil;arg = va_arg(args, id))
    {
        //do with the mutiple params
        if([arg isKindOfClass:[NSString class]])
        {
            sqlite3_bind_text(statm, index, [arg UTF8String], -1, SQLITE_TRANSIENT);
        }
        else if([arg isKindOfClass:[NSNumber class]])
        {
            const char* objctype = [arg objCType];
            
            if(strcmp(objctype, @encode(double)) == 0 || strcmp(objctype, @encode(float)) == 0)
            {
                sqlite3_bind_double(statm, index, [arg doubleValue]);
            }
            else
            {
                sqlite3_bind_int64(statm, index, [arg longLongValue]);
            }
        }
        
        index++;
    }


    if((result = sqlite3_step(statm)) != SQLITE_DONE)
    {
        if(result == SQLITE_ROW)
        {
            [NSException raise:@"SqliteException" format:@"Failed to execute the sql,seems you're running a query,error:%d", result];
        }
        else
        {
            [NSException raise:@"SqliteException" format:@"Failed to execute the sql,error:%d", result];
        }

    }

    sqlite3_finalize(statm);

}



-(NSArray *)querySql:(NSString *)sql withParameters:(id)stringOrNumber, ...
{
    sqlite3_stmt *statm;
    int result = sqlite3_prepare(_sqliteDb, [sql UTF8String], -1, &statm, NULL);
    if(result !=SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to prepare statement, error:%d", result];
    }
    
    va_list args;
    va_start(args, stringOrNumber);
    int index = 1;
    for(id arg =stringOrNumber;arg!=nil;arg = va_arg(args, id))
    {
        //do with the mutiple params
        if([arg isKindOfClass:[NSString class]])
        {
            sqlite3_bind_text(statm, index, [arg UTF8String], -1, SQLITE_TRANSIENT);
        }
        else if([arg isKindOfClass:[NSNumber class]])
        {
            const char* objctype = [arg objCType];
            
            if(strcmp(objctype, @encode(double)) == 0 || strcmp(objctype, @encode(float)) == 0)
            {
                sqlite3_bind_double(statm, index, [arg doubleValue]);
            }
            else
            {
                sqlite3_bind_int64(statm, index, [arg longLongValue]);
            }
        }
        
        index++;
    }
    
    int columnCount = sqlite3_column_count(statm);
  
    result = -1;
    NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:sqlite3_data_count(statm)];
    if(columnCount > 0)
    {
        while((result = sqlite3_step(statm)) == SQLITE_ROW)
        {
            NSMutableDictionary *rowDic = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
            for(int i = 0;i<columnCount;i++)//column index from 1
            {
                [rowDic setValue: [self getObjcValue:statm index:i forType:sqlite3_column_type(statm, i)] forKey:[NSString stringWithUTF8String: sqlite3_column_name(statm, i)]];
            }
            [resultArr addObject:rowDic];
            [rowDic release];
        }
    }
    sqlite3_finalize(statm);
    
    if(result != SQLITE_DONE)
    {
        [NSException raise:@"SqliteException" format:@"Failed to get rows ,error:%d", result];
    }
    return resultArr;
}

-(NSArray *)querySql:(NSString *)sql withParameterArray:(NSArray *)paramsArray
{
    sqlite3_stmt *statm;
    int result = sqlite3_prepare(_sqliteDb, [sql UTF8String], -1, &statm, NULL);
    if(result !=SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to prepare statement, error:%d", result];
    }
    
    int index = 1;
    for(id arg in paramsArray)
    {
        //do with the mutiple params
        if([arg isKindOfClass:[NSString class]])
        {
            sqlite3_bind_text(statm, index, [arg UTF8String], -1, SQLITE_TRANSIENT);
        }
        else if([arg isKindOfClass:[NSNumber class]])
        {
            const char* objctype = [arg objCType];
            
            if(strcmp(objctype, @encode(double)) == 0 || strcmp(objctype, @encode(float)) == 0)
            {
                sqlite3_bind_double(statm, index, [arg doubleValue]);
            }
            else
            {
                sqlite3_bind_int64(statm, index, [arg longLongValue]);
            }
        }
        
        index++;
    }
    
    int columnCount = sqlite3_column_count(statm);
    result = -1;
    NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:sqlite3_data_count(statm)];
    if(columnCount > 0)
    {
        
        while((result = sqlite3_step(statm)) == SQLITE_ROW)
        {
            NSMutableDictionary *rowDic = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
            for(int i = 0;i<columnCount;i++)
            {
                [rowDic setValue: [self getObjcValue:statm index:i forType:sqlite3_column_type(statm, i)] forKey:[NSString stringWithUTF8String: sqlite3_column_name(statm, i)]];
            }
            [resultArr addObject:rowDic];
            [rowDic release];
        }
    }
    sqlite3_finalize(statm);
    
    if(result != SQLITE_DONE)
    {
        [NSException raise:@"SqliteException" format:@"Failed to get rows ,error:%d", result];
    }
    return resultArr;

}

-(void)insertRow:(NSDictionary *)row toTable:(NSString *)tablename
{

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:6];
    NSMutableString *sql = [NSMutableString stringWithString:@"insert into "];
    [sql appendString:tablename];
    [sql appendString:@" ("];
    NSMutableString *strParams = [NSMutableString stringWithString:@" values ("];
    NSInteger index = 0;
    for(NSString *key in [row keyEnumerator])
    {
        if(index > 0){
            [sql appendString:@","];
            [strParams appendString:@","];
        }
        [sql appendString:key];
        [strParams appendString:@"?"];
        [arr addObject:[row objectForKey:key]];
        index ++;
    }
    [sql appendString:@")"];
    [strParams appendString:@")"];
    [sql appendString:strParams];
    [self executeSql:sql withParameterArray:arr];
}

-(void)updateRow:(NSDictionary *)row toTable:(NSString *)tablename index:(NSInteger)rowid
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:6];
    NSMutableString *sql = [NSMutableString stringWithString:@"update "];
    [sql appendString:tablename];
    [sql appendString:@" set "];
    NSInteger index = 0;
    for(NSString *key in [row keyEnumerator])
    {
        if(index > 0) {
            [sql appendString:@","];
        }
        
        [sql appendString:key];
        [sql appendString:@"=?"];
        [arr addObject:[row objectForKey:key]];
        index ++;
    }
    [sql appendFormat:@" where id=%d", rowid];
    [self executeSql:sql withParameterArray:arr];
}

-(void)beginTransaction
{
    char* errMsg;
    int result = sqlite3_exec(_sqliteDb, "begin transaction", NULL, NULL, &errMsg);
    if(result != SQLITE_OK)
    {
          [NSException raise:@"SqliteException" format:@"Failed to begin transaction,reason:%s error:%d",errMsg, result];
    }
}

-(void)rollbackTransaction
{
    char* errMsg;
    int result = sqlite3_exec(_sqliteDb, "rollback transaction", NULL, NULL, &errMsg);
    if(result != SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to rollback transaction,reason:%s error:%d",errMsg, result];
    }

}

-(void)commitTransaction
{
    char* errMsg;
    int result = sqlite3_exec(_sqliteDb, "commit transaction", NULL, NULL, &errMsg);
    if(result != SQLITE_OK)
    {
        [NSException raise:@"SqliteException" format:@"Failed to commit transaction,reason:%s error:%d",errMsg, result];
    }
}

@end
