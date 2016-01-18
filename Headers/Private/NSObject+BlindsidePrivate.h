#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BlindsidePrivate)

/// A string used when printing errors about this object, when it used as an injector key
- (NSString *)bsKeyDescription;

@end

NS_ASSUME_NONNULL_END
