#import "Kiwi.h"
#import "CMDate.h"
#import "CMObject.h"
#import "CMObjectSerialization.h"
#import "CMObjectEncoder.h"
#import "CMObjectDecoder.h"

@interface CMDateSerialWrapper : CMObject
- (instancetype)initWithNSDate:(NSDate *)nsDate andCMDate:(CMDate *)cmDate;
@property (nonatomic) NSDate *nsDate;
@property (nonatomic) CMDate *cmDate;
@end

@implementation CMDateSerialWrapper

- (instancetype)initWithNSDate:(NSDate *)nsDate andCMDate:(CMDate *)cmDate
{
    self = [super init];
    if (nil == self) { return nil; }
    
    _nsDate = nsDate;
    _cmDate = cmDate;
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) { return nil; }
    
    _nsDate = [aDecoder decodeObjectForKey:@"nsDate"];
    _cmDate = [aDecoder decodeObjectForKey:@"cmDate"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nsDate forKey:@"nsDate"];
    [aCoder encodeObject:self.cmDate forKey:@"cmDate"];
}

@end

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
    
    // MARK: Document Serialization De-Serialization type changes
    
    it(@"should (not!) convert NSDate to CMDate during encode/decode cycle", ^{
        NSDate *originalNSDate = [NSDate new];
        CMDateSerialWrapper *wrapper = [[CMDateSerialWrapper alloc] initWithNSDate:originalNSDate andCMDate:nil];
        
        NSDictionary *encodedWrapper = [CMObjectEncoder encodeObjects:@[wrapper]];
        CMDateSerialWrapper *codedWrapper = [CMObjectDecoder decodeObjects:encodedWrapper].firstObject;
        
        [[theValue([codedWrapper.nsDate isKindOfClass:[NSDate class]]) should] equal:@YES];
        [[theValue([codedWrapper.nsDate isKindOfClass:[CMDate class]]) should] equal:@YES];
        // ^Current behvior
        // Desired behavior: [[theValue([codedWrapper.nsDate isKindOfClass:[CMDate class]]) should] equal:@NO];
    });
    
    it(@"should encode an NSDate with the correct timestamp schema", ^{
        NSDate *originalNSDate = [NSDate dateWithTimeIntervalSince1970:1.0f];
        CMDateSerialWrapper *wrapper = [[CMDateSerialWrapper alloc] initWithNSDate:originalNSDate andCMDate:nil];
        
        NSDictionary *encodedWrapperObject = [[CMObjectEncoder encodeObjects:@[wrapper]] objectForKey:wrapper.objectId];
        
        NSDictionary *encodedNSDate = [encodedWrapperObject objectForKey:@"nsDate"];
        NSString *encodedNSDateCMClass = [encodedNSDate objectForKey:CMInternalClassStorageKey];
        NSNumber *encodedNSDateCMStamp = [encodedNSDate objectForKey:@"timestamp"];
        
        [[@"datetime" should] equal:encodedNSDateCMClass];
        [[@1.0 should] equal:encodedNSDateCMStamp];
    });
});

SPEC_END
