#import <SenTestingKit/SenTestingKit.h>
#import "ISDiskCache.h"

@interface ISDiskCacheTests : SenTestCase {
    ISDiskCache *cache;
    id <NSCoding> key;
    id <NSCoding> value;
}

@end

@implementation ISDiskCacheTests

- (void)setUp
{
    [super setUp];
    
    cache = [[ISDiskCache alloc] init];
    key = @"foo";
    value = @"bar";
}

- (void)tearDown
{
    cache = nil;
    key = nil;
    value = nil;
    
    [super tearDown];
}

- (void)testSetObject
{
    [cache setObject:value forKey:key];
    
    STAssertEqualObjects([cache objectForKey:key], value, @"object did not match set object.");
}

- (void)testRemoveObject
{
    [cache setObject:value forKey:key];
    [cache removeObjectForKey:key];
    
    STAssertNil([cache objectForKey:key], @"object for removed key should be nil.");
}

- (void)testUpdateModificationDateOnAccessing
{
    [cache setObject:value forKey:key];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
    [cache objectForKey:key];
    
    NSDate *accessedDate = [NSDate date];
    NSString *path = [cache filePathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *getAttributesError = nil;
    NSMutableDictionary *attributes = [[fileManager attributesOfItemAtPath:path error:&getAttributesError] mutableCopy];
    NSDate *modificationDate = [attributes objectForKey:NSFileModificationDate];
    
    STAssertTrue(ABS([accessedDate timeIntervalSinceDate:modificationDate]) < 1.0, nil);
}

@end
