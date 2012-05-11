#import "BSBlockProvider.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSBlockProvider ()
@property (nonatomic, strong) BSBlock block;
@property (nonatomic, weak) id<BSInjector> injector;

- (id)initWithBlock:(BSBlock)block injector:(id<BSInjector>)injector;

@end

@implementation BSBlockProvider

@synthesize block = _block, injector = _injector;

+ (BSBlockProvider *)providerWithBlock:(BSBlock)block injector:(id<BSInjector>)injector {
    return [[BSBlockProvider alloc] initWithBlock:block injector:injector];
}

- (id)initWithBlock:(BSBlock)block injector:(id<BSInjector>)injector {
    if (self = [super init]) {
        self.block = [block copy];
        self.injector = injector;
    }
    return self;
}

- (id)provide:(NSArray *)args {
    return self.block(args, self.injector);
}

@end
