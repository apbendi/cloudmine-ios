//
//  CMFileSpec.m
//  cloudmine-iosTests
//
//  Copyright (c) 2011 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "Kiwi.h"
#import "NSMutableData+RandomData.h"

#import "CMFile.h"
#import "CMUser.h"

SPEC_BEGIN(CMFileSpec)

describe(@"CMFile", ^{
    
    __block CMFile *file = nil;
    
    context(@"given an app-level CMFile instance", ^{
        beforeEach(^{
            file = [[CMFile alloc] initWithData:[NSMutableData randomDataWithLength:100] named:@"foofile"];
        });
        
        it(@"it should calculate the cache file location correctly", ^{
            NSString *uuid = [file valueForKey:@"uuid"];
            NSArray *cacheLocationPathComponents = [file.cacheLocation pathComponents];
            NSString *fileName = [cacheLocationPathComponents lastObject];
            NSString *fileParentDirectory = [cacheLocationPathComponents objectAtIndex:[cacheLocationPathComponents count] - 2];
            
            [[fileName should] equal:[NSString stringWithFormat:@"%@_foofile", uuid]];
            [[fileParentDirectory should] equal:@"cmFiles"];
        });
    });
    
    context(@"given a user-level CMFile instance", ^{
        beforeEach(^{
            file = [[CMFile alloc] initWithData:[NSMutableData randomDataWithLength:100] named:@"foofile" belongingToUser:[[CMUser alloc] initWithUserId:@"uid" andPassword:@"pw"]];
        });
        
        it(@"it should calculate the cache file location correctly", ^{
            NSString *uuid = [file valueForKey:@"uuid"];
            NSArray *cacheLocationPathComponents = [file.cacheLocation pathComponents];
            NSString *fileName = [cacheLocationPathComponents lastObject];
            NSString *fileParentDirectory = [cacheLocationPathComponents objectAtIndex:[cacheLocationPathComponents count] - 2];
            
            [[fileName should] equal:[NSString stringWithFormat:@"%@_foofile", uuid]];
            [[fileParentDirectory should] equal:@"cmUserFiles"];
        });
    });

});

SPEC_END