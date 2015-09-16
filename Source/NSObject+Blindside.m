#import "NSObject+Blindside.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSPropertySet.h"
#import "BSUtils.h"

static NSString *const BSMissingInitializerException;

@implementation NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    SEL overriddenInitializer = bsOverriddenInitializerForClass(self);
    if (overriddenInitializer != NULL) {
        [NSException raise:BSMissingInitializerException
                    format:@"Cannot create an instance of class %@ which provides initializer -%s but does not implement +bsInitializer", NSStringFromClass(self), sel_getName(overriddenInitializer)];
    }

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

- (void)bsAwakeFromPropertyInjection {
    
}

@end
