
#define AddVarArgsToNSMutableArray(firstKey, argKeys) va_list __argList__;\
va_start(__argList__, firstKey);\
for (id arg = (firstKey); arg != nil; arg = va_arg(__argList__, id)) {\
[(argKeys) addObject:arg];\
}\
va_end(__argList__);
