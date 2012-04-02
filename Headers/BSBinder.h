#import <Foundation/Foundation.h>

#import "BSBlockProvider.h"

@protocol BSProvider, BSScope;

@protocol BSBinder

- (void)bind:(id)key toInstance:(id)instance;
- (void)bind:(id)key toProvider:(id<BSProvider>)provider;
- (void)bind:(id)key toBlock:(BSBlock)block;
- (void)bind:(id)key toClass:(Class)type;
- (void)bind:(id)key toClass:(Class)type withScope:(id<BSScope>)scope;

- (void)bind:(id)key withScope:(id<BSScope>)scope;

@end
