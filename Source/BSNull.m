#import "BSNull.h"

static BSNull *null = nil;

@implementation BSNull

+ (BSNull *)null {
    if (null == nil) {
        null = [[BSNull alloc] init];
    }
    return null;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
