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

#import <Foundation/Foundation.h>


@interface sipprofileModel : NSObject
{
    //! sip authentication user name
   NSString *sipauthuser;
//! sip host IP    
   NSString *  siphost;
//! SIP id    
   NSString * sipid;
//!SIP password    
   NSString * sippassword;
//! sip port to connect on     
   NSString * sipport;
//! sip proxy host    
   NSString * sipproxyhost;
//! sip proxy port    
   NSString * sipproxyport;
//! sip stun host name    
   NSString * sipstunhost;
//! sip stun port    
   NSString * sipstunport;
//! Sip user type for runtime identification
    NSString *sipsupporttype;
    
// To identify the sip groups of the user - AURORA-1068
    NSMutableArray* sipgroups;
}
@property(nonatomic, retain) NSString *sipsupporttype;
@property(nonatomic, retain) NSString *sipauthuser;
@property(nonatomic, retain) NSString *  siphost;
@property(nonatomic, retain) NSString * sipid;
@property(nonatomic, retain) NSString * sippassword;
@property(nonatomic, retain) NSString * sipport;
@property(nonatomic, retain) NSString * sipproxyhost;
@property(nonatomic, retain) NSString * sipproxyport;
@property(nonatomic, retain) NSString * sipstunhost;
@property(nonatomic, retain) NSString * sipstunport;

@property(nonatomic, retain) NSMutableArray* sipgroups;

//+ (sipprofileModel *)sharedclass;
@end
