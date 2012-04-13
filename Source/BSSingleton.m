#import "BSSingleton.h"
#import "BSProvider.h"

@interface BSSingleton ()
@property (nonatomic, assign) id<BSProvider> source;
@property (nonatomic, retain) id instance;
@end

@implementation BSSingleton

@synthesize source = _source, instance = _instance;

+ (BSSingleton *)scope {
    return [[[BSSingleton alloc] init] autorelease];
}

- (id<BSProvider>)scope:(id<BSProvider>)source {
    self.source = source;
    return self;
}

- (id)provide:(NSArray *)args {
    if (self.instance == nil) {
        self.instance = [self.source provide:args];
    }
    return self.instance;
}

- (void)dealloc {
    self.instance = nil;
    [super dealloc];
}

@end
