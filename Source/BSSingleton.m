#import "BSSingleton.h"
#import "BSProvider.h"

@interface BSSingleton ()
@property (nonatomic, strong) id<BSProvider> source;
@property (nonatomic, strong) id instance;
@end

@implementation BSSingleton

@synthesize source = _source, instance = _instance;

+ (BSSingleton *)scope {
    return [[BSSingleton alloc] init];
}

- (id<BSProvider>)scope:(id<BSProvider>)source {
    self.source = source;
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector {
    if (self.instance == nil) {
        self.instance = [self.source provide:args injector:injector];
        self.source = nil;
    }
    return self.instance;
}

@end
