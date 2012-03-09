#import "BSSingleton.h"
#import "BSInstanceProvider.h"

@interface BSSingleton ()
@property (nonatomic, retain) BSInstanceProvider *instanceProvider;
@end

@implementation BSSingleton

@synthesize instanceProvider = instanceProvider_;

+ (BSSingleton *)scope {
    return [[[BSSingleton alloc] init] autorelease];
}

- (id<BSProvider>)scope:(id<BSProvider>)source {
    if (self.instanceProvider == nil) {
        self.instanceProvider = [BSInstanceProvider provider:[source provide]];
    }
    return self.instanceProvider;
}

- (void)dealloc {
    self.instanceProvider = nil;
    [super dealloc];
}

@end
