#import "NSObject+Blindside.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSPropertySet.h"

@implementation NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    id instance = [[self alloc] init];
    [injector injectProperties:instance];
    return instance;
}

+ (BSInitializer *)bsInitializer {
    return nil;
}

+ (BSPropertySet *)bsProperties {
    return nil;
}

@end
