#import "Fixtures.h"
#import "BSInitializer.h"

@implementation Garage : NSObject 
@end

@implementation Driveway : NSObject 
@end

@implementation Address : NSObject 
@end

@implementation House : NSObject

@synthesize 
address = address_, 
garage = garage_,
driveway = driveway_;

+ (BSInitializer *)blindsideInitializer {
    return [BSInitializer initializerWithClass:self selector:@selector(initWithAddress:) argumentKeys:[Address class], nil];
}

+ (NSDictionary *)blindsideProperties {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Garage class], @"garage", 
            [Driveway class], @"driveway", 
            nil];
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

