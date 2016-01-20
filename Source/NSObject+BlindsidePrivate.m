#import "NSObject+BlindsidePrivate.h"
#import <objc/Protocol.h>
#import <objc/runtime.h>

@implementation NSObject (BlindsidePrivate)

- (NSString *)bsKeyDescription {
    return [self description];
}

@end

@implementation Protocol (BlindsidePrivate)

- (NSString *)bsKeyDescription {
    return [NSString stringWithFormat:@"@protocol(%@)", NSStringFromProtocol(self)];
}

@end
