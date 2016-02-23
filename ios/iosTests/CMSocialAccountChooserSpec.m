//
//  CMSomething.m
//  cloudmine-ios
//
//  Created by Ethan Mick on 8/6/14.
//  Copyright (c) 2016 CloudMine, Inc. All rights reserved.
//

#import "Kiwi.h"
#import "CMSocialAccountChooser.h"

SPEC_BEGIN(CMSocialAccountChooserSpec)

describe(@"CMSocialAccountChooser", ^{
    
    it(@"should return immediately when you do not send a callback", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        [chooser chooseFromAccounts:@[] showFrom:[UIViewController new] callback:nil];
    });
    
    it(@"should return nil when cancel is tapped", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        ACAccount *account = [ACAccount new];
        [chooser chooseFromAccounts:@[account] showFrom:[UIViewController new] callback:^(id account) {
            [[account should] beNil];
        }];
        
        [chooser actionSheet:nil clickedButtonAtIndex:2];
    });
    
    it(@"should return a NSNumber when 'Another Account' is tapped", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        ACAccount *account = [ACAccount new];
        [chooser chooseFromAccounts:@[account] showFrom:[UIViewController new] callback:^(id account) {
            [[account should] beKindOfClass:[NSNumber class]];
        }];
        
        [chooser actionSheet:nil clickedButtonAtIndex:1];
    });
    
    it(@"should return the account when tapped", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        ACAccount *account = [ACAccount new];
        [chooser chooseFromAccounts:@[account] showFrom:[UIViewController new] callback:^(id account) {
            [[account should] beKindOfClass:[ACAccount class]];
        }];
        
        [chooser actionSheet:nil clickedButtonAtIndex:0];
    });
    
    it(@"should popup a uialert view (if it could) and say no", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        [chooser wouldLikeToLogInWithAnotherAccountWithCallback:^(BOOL answer) {
            [[theValue(answer) should] equal:theValue(NO)];
        }];
        
        [chooser alertView:nil clickedButtonAtIndex:0];
    });
    
    it(@"should popup a uialert view (if it could) and say no", ^{
        CMSocialAccountChooser *chooser = [[CMSocialAccountChooser alloc] init];
        [chooser wouldLikeToLogInWithAnotherAccountWithCallback:^(BOOL answer) {
            [[theValue(answer) should] equal:theValue(YES)];
        }];
        
        [chooser alertView:nil clickedButtonAtIndex:1];
    });
});

SPEC_END
