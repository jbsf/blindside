#import "NSObject+Blindside.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSPropertySet.h"

@implementation NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    return [[self alloc] init];
}

+ (BSInitializer *)bsInitializer {
    return nil;
}

+ (BSPropertySet *)bsProperties {
    return nil;
}

@end
