#import <Foundation/Foundation.h>

#import "BSProvider.h"

@interface BSInstanceProvider : NSObject<BSProvider> {
    id instance_;
}

@property (nonatomic, retain) id instance;

+ (BSInstanceProvider *)provider:(id)instance;

- (id)initWithInstance:(id)instance;

@end
