#import <Foundation/Foundation.h>

#import "BSProvider.h"

@interface BSInstanceProvider : NSObject<BSProvider> 

+ (BSInstanceProvider *)provider:(id)instance;

@end
