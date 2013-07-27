//!
//!  fileserverModel.h
//!  AuroraPhone
//!	Abstract: This model class has all the user registartion info regarding the file server
//!	Version: 1.0

/*
 Copyright (c) 2011, Covidien Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list
 of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.
 Neither the name of the Covidien Inc. nor the names of its contributors may be
 used to endorse or promote products derived from this software without specific
 prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 OF THE POSSIBILITY OF SUCH DAMAGE."
 */


#import "fileserverModel.h"
#import "UrlSplitter.h"
#import "constants.h"

@implementation fileserverModel

@synthesize fshost = _fshost;
@synthesize fspath = _fspath;
@synthesize fsport = _fsport;
@synthesize fsHttpProtocol = _fsHttpProtocol;


//SYNTHESIZE_SINGLETON_FOR_CLASS(fileserverModel);
- (id)init
{
    self = [super init];
	if (self != nil)
    {
        _fshost = [[NSString alloc] initWithString:@""];
        _fspath = [[NSString alloc] initWithString:@""];
        _fsport = [[NSString alloc] initWithString:@""];
        UrlSplitResult result;
        //MELO. Keep the same with session server per requirement.
        NSString *sessionUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionServerIPKey];
        splitUrl(sessionUrl, &result);
        _fsHttpProtocol = [[NSString alloc] initWithString:result.scheme];
    }
    return self;
    
}
-(void) fromDict:(NSDictionary *)jsonDic
{
//    NSDictionary *dic = [jsonDic objectForKey:@"fileserver"];
//    NSLog(@"dic %@",dic);
//    NSLog(@"dic %@",[dic allKeys]);
    for(NSString *key in [jsonDic allKeys])
    {
        @try {
            [self setValue:[[jsonDic objectForKey:key]description] forKey:key];   
            DDLogVerbose(@"property value = %@ for key %@ ",[self valueForKey:key], key);
        }
        @catch (NSException *exception) {
            // 
            DDLogWarn(@"The key %@ has no value assigned", key);
          
        }
        @finally {
            
        }
        
    }
    
}

-(NSDictionary *)toDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.fshost, @"fshost",self.fsHttpProtocol,@"fsHttpProtocol",self.fsport,@"fsport",self.fspath,@"fspath", nil];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    DDLogVerbose(@"The key %@ has no value assigned", key);
    return @"UnDefined";
}

@end
