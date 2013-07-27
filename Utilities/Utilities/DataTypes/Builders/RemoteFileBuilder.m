//
//  RemoteFileBuilder.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemoteFileBuilder.h"
#import "DTConstants.h"

@implementation RemoteFileBuilder

+(NSDictionary *)toDictionary:(RemoteFile *)file
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:file.fileId],kRemoteFileId,file.name,kRemoteFileName,file.remotePath,kRemoteFileRemotePath, nil];
}

+(RemoteFile *)buildFromDict:(NSDictionary *)dic
{
    RemoteFile *file = [[[RemoteFile alloc]init]autorelease];
    file.fileId = [[dic objectForKey:kRemoteFileId] intValue];
    file.name = [dic objectForKey:kRemoteFileName];
    file.remotePath = [dic objectForKey:kRemoteFileRemotePath];
    return file;
}

@end
