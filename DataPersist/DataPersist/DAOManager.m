//
//  DAOManager.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DAOManager.h"
#import "PListPersistImpl.h"
#import "PhoneBookDAO.h"
#import "ClientFeatureDAO.h"
#import "UserProfileDAO.h"
#import "ServerSettingDAO.h"
#import "UserDefaultPersistImpl.h"
#import "Sa2DAO.h"
#import "CallHistoryDAO.h"
#import "CrmodCallerDAO.h"
#import "AppVersionDAO.h"
#import "SecurityDAO.h"

static DAOManager* sharedManagerInstance;

@implementation DAOManager
@synthesize phoneBookDAO = _phonebookDAO;
@synthesize crmodCallerDAO = _crmodCallerDAO;

+(void)initialize
{
    sharedManagerInstance = [[DAOManager alloc]init];
}

+(DAOManager *)sharedInstance
{
    return sharedManagerInstance;
}

-(void)release
{
    
}

-(PhoneBookDAO *)phoneBookDAO
{
    if(_phonebookDAO == nil)
    {
        @synchronized(self)
        {
            if(_phonebookDAO == nil){
                  NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                PListPersistImpl* persistImpl = [[PListPersistImpl alloc]initWithPath:path];
                _phonebookDAO = [[PhoneBookDAO alloc]initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _phonebookDAO;
}

-(ClientFeatureDAO *)clientFeatureDAO
{
    if(_clientFeatureDAO == nil)
    {
        @synchronized(self)
        {
            if(_clientFeatureDAO == nil)
            {
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                PListPersistImpl* persistImpl = [[PListPersistImpl alloc]initWithPath:path];
              
                _clientFeatureDAO = [[ClientFeatureDAO alloc] initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _clientFeatureDAO;
}

-(UserProfileDAO *)userProfileDAO
{
    if(_userProfileDAO == nil)
    {
        @synchronized(self)
        {
            if(_userProfileDAO == nil)
            {
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                PListPersistImpl* persistImpl = [[PListPersistImpl alloc]initWithPath:path];
               
                _userProfileDAO = [[UserProfileDAO alloc] initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _userProfileDAO;
}

-(ServerSettingDAO *)serverSettingDAO
{
    if(_serverSettingDAO == nil)
    {
        @synchronized(self)
        {
            if(_serverSettingDAO == nil)
            {
                UserDefaultPersistImpl* persistImpl = [[UserDefaultPersistImpl alloc]init];             
                _serverSettingDAO = [[ServerSettingDAO alloc] initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _serverSettingDAO;

}

-(Sa2DAO *)sa2DAO
{
    if(_sa2DAO == nil)
    {
        @synchronized(self)
        {
            if(_sa2DAO == nil)
            {
                PListPersistImpl* persistImpl = [[PListPersistImpl alloc]init];             
                _sa2DAO = [[Sa2DAO alloc] initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _sa2DAO;
}

-(CallHistoryDAO *)callHistoryDAO
{
    if(_callHistoryDAO == nil)
    {
        @synchronized(self)
        {
            if(_callHistoryDAO == nil)
            {
                 NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                _callHistoryDAO = [[CallHistoryDAO alloc] initWithPath:path];
            }
        }
    }
    return _callHistoryDAO;
}

-(CrmodCallerDAO *)crmodCallerDAO
{
    if(_crmodCallerDAO == nil)
    {
        @synchronized(self)
        {
            if(_crmodCallerDAO == nil){
                NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                PListPersistImpl* persistImpl = [[PListPersistImpl alloc]initWithPath:path];
                _crmodCallerDAO = [[CrmodCallerDAO alloc]initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _crmodCallerDAO;
}

-(AppVersionDAO *)appVersionDAO
{
    if(_appVersionDAO == nil){
        @synchronized(self){
            if(_appVersionDAO == nil){
                UserDefaultPersistImpl* persistImpl = [[UserDefaultPersistImpl alloc]init];
                _appVersionDAO = [[AppVersionDAO alloc] initWithImpl:persistImpl];
                [persistImpl release];
            }
        }
    }
    return _appVersionDAO;
}

-(SecurityDAO *)securityDAO
{
    if(_securityDAO == nil){
        @synchronized(self){
            if(_securityDAO == nil){
                _securityDAO = [[SecurityDAO alloc] init];
            }
        }
    }
    return _securityDAO;
}

@end
