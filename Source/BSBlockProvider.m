#import "BSBlockProvider.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSBlockProvider ()
@property (nonatomic, retain) BSBlock block;

- (id)initWithBlock:(BSBlock)block;

@end

@implementation BSBlockProvider

@synthesize block = block_;

+ (BSBlockProvider *)provider:(BSBlock)block {
    return [[[BSBlockProvider alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(BSBlock)block {
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
    return self.block(args);
}

@end
