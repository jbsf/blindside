#import "BSBlockProvider.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSBlockProvider ()
@property (nonatomic, strong) BSBlock block;

- (id)initWithBlock:(BSBlock)block;

@end

@implementation BSBlockProvider

@synthesize block = _block;

+ (BSBlockProvider *)providerWithBlock:(BSBlock)block  {
    return [[BSBlockProvider alloc] initWithBlock:block];
}

- (id)initWithBlock:(BSBlock)block {
    if (self = [super init]) {
        self.block = [block copy];
    }
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector{
    return self.block(args, injector);
}

@end
