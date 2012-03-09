#import "BSNull.h"

static BSNull *null = nil;

@implementation BSNull

+ (BSNull *)null {
    if (null == nil) {
        null = [[BSNull alloc] init];
    }
    return null;
}
@end
