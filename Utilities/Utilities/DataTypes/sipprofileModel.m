//!
//!  sipprofileModel.h
//!  AuroraPhone
//!	Abstract: This model class has all the user registartion info regarding the sip profile
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


#import "sipprofileModel.h"

@implementation sipprofileModel
//SYNTHESIZE_SINGLETON_FOR_CLASS(sipprofileModel);

@synthesize sipauthuser;
@synthesize siphost;
@synthesize sipid;
@synthesize sippassword;
@synthesize sipport;
@synthesize sipproxyhost;
@synthesize sipproxyport;
@synthesize sipstunhost;
@synthesize sipstunport;
@synthesize sipsupporttype;
@synthesize sipgroups;


- (id)init
{
    self = [super init];
	if (self != nil)
    {
       sipauthuser = [[NSString alloc] initWithString:@""];
       siphost = [[NSString alloc] initWithString:@""];
        sipid = [[NSString alloc] initWithString:@""];
        sippassword = [[NSString alloc] initWithString:@""];
        sipport = [[NSString alloc] initWithString:@""];
        sipproxyhost = [[NSString alloc] initWithString:@""];
        sipproxyport = [[NSString alloc] initWithString:@""];
        sipstunhost = [[NSString alloc] initWithString:@""];
        sipstunport = [[NSString alloc] initWithString:@""];
        sipsupporttype = [[NSString alloc] initWithString:@""];
        sipgroups = nil;
    }
    return self;
    
}
-(void) fromDict:(NSDictionary *)jsonDic
{
    for(NSString *key in [jsonDic allKeys])
    {
        @try {
            [self setValue:[jsonDic objectForKey:key] forKey:key];
            DDLogVerbose(@"property value = %@ for key %@ ",[self valueForKey:key], key);
        }
        @catch (NSException *exception) {
            // 
            DDLogVerbose(@"The key %@ has no value assigned", key);
           
        }
        @finally {
            
        }
        
    }
    
}

-(NSDictionary *)toDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.sipauthuser, @"sipauthuser",self.siphost,@"siphost",self.sipid,@"sipid",self.sipport,@"sipport",self.sipproxyhost,@"sipproxyhost",self.sipproxyport,@"sipproxyport",self.sipstunhost,@"sipstunhost",self.sipstunport,@"sipstunport",self.sipsupporttype,@"sipsupporttype", self.sipgroups, @"sipgroups", nil];
}


- (id)valueForUndefinedKey:(NSString *)key
{
    DDLogError(@"The key %@ has no value assigned", key);
    return @"UnDefined";
}

@end
