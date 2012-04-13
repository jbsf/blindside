#import "BSInstanceProvider.h"

@implementation BSInstanceProvider

@synthesize instance = instance_;

+ (BSInstanceProvider *)provider:(id)instance {
    return [[[BSInstanceProvider alloc] initWithInstance:instance] autorelease];
}

- (id)initWithInstance:(id)instance {
    if (self = [super init]) {
        self.instance = instance;
    }
    return self;
}

- (void)dealloc {
    self.instance = nil;
    [super dealloc];
}

- (id)provide:(NSArray *)args {
    return self.instance;
}

@end
