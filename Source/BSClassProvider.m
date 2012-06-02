#import "BSClassProvider.h"
#import "BSInjector.h"

@interface BSClassProvider ()
@property (nonatomic, weak) Class klass;

- (id)initWithClass:(Class)class;

@end

@implementation BSClassProvider
@synthesize klass = _klass;

+ (BSClassProvider *)providerWithClass:(Class)class {
    return [[BSClassProvider alloc] initWithClass:class];
}

- (id)initWithClass:(Class)klass {
    self = [super init];
    if (self) {
        self.klass = klass;
    }
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector {
    return [injector getInstance:self.klass];
}

@end