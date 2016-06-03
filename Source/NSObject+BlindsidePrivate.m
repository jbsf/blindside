#import "NSObject+BlindsidePrivate.h"

@implementation NSObject (BlindsidePrivate)

- (NSString *)bsKeyDescription {
    Class protocolClass = NSClassFromString(@"Protocol");
    if (protocolClass != nil && [self isKindOfClass:protocolClass]) {
        return [NSString stringWithFormat:@"@protocol(%@)", NSStringFromProtocol((Protocol *)self)];
    } else {
        return [self description];
    }
}

@end
