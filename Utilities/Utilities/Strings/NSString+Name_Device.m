//
//  NSString+Name_Device.m
//  AuroraPhone
//
//  Created by Mick Lester on 10/26/12.
//
//

#import "NSString+Name_Device.h"
#import "constants.h"

// The catergory receives a string that has a username like "mick.lester.iphone"
// It returns a dictionary that has name = "Mick Lester" and device = "iPhone"

@implementation NSString (Name_Device)

-(NSString *)name {
     NSArray *componentsArray = [self componentsSeparatedByString:@"."];
    int size = [componentsArray count];
    if([self rangeOfString:@".ipad"].location != NSNotFound || [self rangeOfString:@".iphone"].location != NSNotFound){
        size = size - 1;
    }
    NSString *name = @"";
    for (int i=0; i < size; i++) {
          name = [name stringByAppendingFormat:@" %@", [[componentsArray objectAtIndex:i] capitalizedString]];
    }
    
   return [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 * Favourite Phonebook sort name, use display name
 */
-(NSString *)lastNameFirstName {

    NSArray *componentsArray = [self componentsSeparatedByString:@" "];
    int size = componentsArray.count;
    NSString *name = @"";
    if(size == 0){
        return name;
    } else if(size == 1){ // Format: A
        name = [[componentsArray objectAtIndex:0] capitalizedString];
    } else { // Format: A B C
         name = [name stringByAppendingFormat:@"%@ ", [[componentsArray objectAtIndex:size-1] capitalizedString]];
        for(int i = 0; i <= size -2; i++){
           name = [name stringByAppendingFormat:@"%@ ", [[componentsArray objectAtIndex:i] capitalizedString]];
        }
    }
    return name;
}

-(NSString*)lastName{

    NSArray *componentsArray = [self componentsSeparatedByString:@"."];
    int size = [componentsArray count];
    if([self rangeOfString:@".ipad"].location != NSNotFound || [self rangeOfString:@".iphone"].location != NSNotFound){
        size = size - 1;
    }
    // if xx.xx.iphone,remove first name, avoid xx.ipad or xx.iphone 
    if(size >=2){
        size = size -1; 
    }
    NSString *name = @"";
    for (int i = 0; i < size; i++) {
        name = [name stringByAppendingFormat:@"%@ ", [[componentsArray objectAtIndex:i] capitalizedString]];
    }
    // Remove last white space
    if(name.length > 0){
        name = [name substringToIndex:name.length-1];
    }
    return name;
}

-(NSString*)firstName{

    NSArray *componentsArray = [self componentsSeparatedByString:@"."];
    int size = [componentsArray count];
    if([self rangeOfString:@".ipad"].location != NSNotFound || [self rangeOfString:@".iphone"].location != NSNotFound){
        size = size - 1;
    }
    NSString *name = @"";
    if(size > 1){
        name = [[componentsArray objectAtIndex:size -1] capitalizedString];
    }
    return name;
}

-(NSString *)device {

    NSArray *componentsArray = [self componentsSeparatedByString:@"."];

    NSString *device = [componentsArray lastObject];

    if ([device isEqualToString:@"iphone"]) {
        device = DEVICENAME_IPHONE;
    }

    if ([device isEqualToString:@"ipad"]) {
        device = DEVICENAME_IPAD;
    }

    if (!([device isEqualToString:@"iPad"] || [device isEqualToString:@"iPhone"])) {
        device = @"Group";
    }

    return device;
}

// remove username's device name
- (NSString *)userRealName
{
    int index = [self length];
    if([self rangeOfString:@".ipad"].location != NSNotFound || [self rangeOfString:@".iphone"].location != NSNotFound){
        index = (int)([self rangeOfString:@"." options:NSBackwardsSearch].location);
    }
    return [self substringToIndex:index];
}

@end
