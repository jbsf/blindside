#import <Foundation/Foundation.h>

@class BSModule;

@interface BSInjector : NSObject {
    BSModule *module_;
}

@property (nonatomic, retain) BSModule *module;

- (id)initWithModule:(BSModule *)module;

- (id)getInstance:(id)key;
@end
