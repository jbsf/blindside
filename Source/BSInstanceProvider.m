#import "BSInstanceProvider.h"

@interface BSInstanceProvider ()
@property (nonatomic, strong) id instance;
- (id)initWithInstance:(id)instance;
@end

@implementation BSInstanceProvider

@synthesize instance = _instance;

+ (BSInstanceProvider *)provider:(id)instance {
    return [[BSInstanceProvider alloc] initWithInstance:instance];
}

- (id)initWithInstance:(id)instance {
    if (self = [super init]) {
        self.instance = instance;
    }
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector{
    return self.instance;
}

@end
