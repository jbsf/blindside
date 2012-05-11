#import "BSClassProvider.h"
#import "BSInjector.h"

@interface BSClassProvider ()
@property (nonatomic, weak) Class klass;
@property (nonatomic, weak) id<BSInjector> injector;

- (id)initWithClass:(Class)class injector:(id<BSInjector>)injector;

@end

@implementation BSClassProvider
@synthesize klass = _klass, injector = _injector;

+ (BSClassProvider *)providerWithClass:(Class)class injector:(id<BSInjector>)injector {
    return [[BSClassProvider alloc] initWithClass:class injector:injector];
}

- (id)initWithClass:(Class)klass injector:(id<BSInjector>)injector {
    self = [super init];
    if (self) {
        self.klass = klass;
        self.injector = injector;
    }
    return self;
}

- (id)provide:(NSArray *)args {
    return [self.injector getInstance:self.klass];
}

@end