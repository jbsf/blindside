#import <Foundation/Foundation.h>

#import "BSBinder.h"

@interface BSInjector : NSObject<BSBinder>

- (id)getInstance:(id)key;

@end
