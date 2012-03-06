#import "Fixtures.h"
#import "BSInitializer.h"

@implementation Address : NSObject 

@end

@implementation House : NSObject

@synthesize address = address_;

+ (BSInitializer *)defaultBSInitializer {
    return [BSInitializer initializerWithClass:self selector:@selector(initWithAddress:) argumentKeys:[Address class], nil];
}

- (id)initWithAddress:(Address *)address {
    if (self = [super init]) {
        self.address = address;
    }
    return self;
}

- (void)dealloc {
    self.address = nil;
    [super dealloc];
}

@end

