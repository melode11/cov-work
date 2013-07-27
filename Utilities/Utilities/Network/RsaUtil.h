//
//  SARsaUtil.h
//  Annotation_iPad
//
//  Created by Yao Melo on 4/17/13.
//
//

#import <Foundation/Foundation.h>

@interface RsaUtil : NSObject

+ (NSData*) encryptWithPublicKey:(NSData*)pubKey forData:(NSData*)data;

@end
