#import <Foundation/Foundation.h>

#import "BSProvider.h"

@protocol BSScope <NSObject>
- (id<BSProvider>)scope:(id<BSProvider>)source;
@end

