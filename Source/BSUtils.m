#import "BSUtils.h"
#import <objc/runtime.h>

static const char * const kInitName = "init";
static const size_t kInitLength = 4;

SEL bsOverriddenInitializerForClass(Class klass) {
    Method *methodList = class_copyMethodList(klass, NULL);

    if (!methodList) {
        return NULL;
    }

    SEL initializerSelector = NULL;
    Method nextMethod;
    NSInteger i = 0;

    while ((nextMethod = methodList[i]) != NULL && initializerSelector == NULL) {
        SEL selector = method_getName(nextMethod);
        const char *selName = sel_getName(selector);

        if (strncmp(selName, kInitName, kInitLength) == 0 && strnlen(selName, kInitLength+1) > kInitLength) {
            initializerSelector = selector;
        }

        i++;
    }

    free(methodList);

    return initializerSelector;
}
