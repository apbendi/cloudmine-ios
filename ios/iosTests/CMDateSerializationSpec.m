#import "Kiwi.h"
#import "CMDate.h"

SPEC_BEGIN(CMDateSerializationSpec)

describe(@"CMDateSerialization", ^{
    
    // MARK: Document Legacy CMDate Comparison Behavior
    
    it(@"should think two CMDates within the same second are equal", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.1f]];
        CMDate *dateTwo = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.5f]];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@YES];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@YES];
    });
    
    it(@"should think two CMDates in different seconds are not equal", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.999f]];
        CMDate *dateTwo = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:2.001f]];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@NO];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@NO];
    });
    
    it(@"should treat the edge of a new second as the same second", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.001f]];
        CMDate *dateTwo = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:2.0f]];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@YES];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@YES];
    });
    
    it(@"should think a CMDate is equal to an NSDate within the same second, but not vice versa", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.1f]];
        NSDate *dateTwo = [NSDate dateWithTimeIntervalSince1970:1.5f];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@YES];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@NO];
    });
    
    it(@"should always think a CMDate and NSDate in different seconds are not equal", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.999f]];
        NSDate *dateTwo = [NSDate dateWithTimeIntervalSince1970:2.001f];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@NO];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@NO];
    });
    
    it(@"should treat the edge of a new second as the same second with CMDate, but not NSDate", ^{
        CMDate *dateOne = [[CMDate alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1.001f]];
        NSDate *dateTwo = [NSDate dateWithTimeIntervalSince1970:2.0f];
        
        [[theValue([dateOne isEqual:dateTwo]) should] equal:@YES];
        [[theValue([dateTwo isEqual:dateOne]) should] equal:@NO];
    });
});

SPEC_END
