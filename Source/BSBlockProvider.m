#import "BSBlockProvider.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSBlockProvider ()
@property (nonatomic, retain) BSBlock block;
@property (nonatomic, assign) id<BSInjector> injector;

- (id)initWithBlock:(BSBlock)block injector:(id<BSInjector>)injector;

@end

@implementation BSBlockProvider

@synthesize block = _block, injector = _injector;

+ (BSBlockProvider *)providerWithBlock:(BSBlock)block injector:(id<BSInjector>)injector {
    return [[[BSBlockProvider alloc] initWithBlock:block injector:injector] autorelease];
}

- (id)initWithBlock:(BSBlock)block injector:(id<BSInjector>)injector {
    if (self = [super init]) {
        self.block = [block copy];
    }
    return self;
}

- (void)dealloc {
    self.block = nil;
    [super dealloc];
}

- (id)provide:(NSArray *)args {
    return self.block(args, self.injector);
}

@end
