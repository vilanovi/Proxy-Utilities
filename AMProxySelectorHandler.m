//
//  AMProxySelectorHandler.m
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//

#import "AMProxySelectorHandler.h"

typedef enum
{
    AMProxySelectorObserverTypeEmpty,
    AMProxySelectorObserverTypeString,
    AMProxySelectorObserverTypeException,
    AMProxySelectorObserverTypeBlock,
    AMProxySelectorObserverTypeRedirectTarget
} AMProxySelectorObserverType;

@implementation AMProxySelectorHandler
{
    id _object;
    NSMutableDictionary *_logSelectors;
    NSMutableSet *_selectorsToAvoid;
}

+ (AMProxySelectorHandler*)__proxyObject:(id)object
{
    return [[AMProxySelectorHandler alloc] __initWithObject:object];
}

- (id)__initWithObject:(id)object
{
    if (self)
    {
        _object = object;
        _logSelectors = [NSMutableDictionary dictionary];
        _selectorsToAvoid = [NSMutableSet set];
    }
    return self;
}

#pragma mark NSProxy Methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    id target = _object;
    
    NSArray *array = [_logSelectors objectForKey:[self __keyForSelector:anInvocation.selector]];
    if (array)
    {
        AMProxySelectorObserverType logType = [array[0] integerValue];
        
        NSString *logString = [NSString stringWithFormat:@"WILL INVOKE SELECTOR <%@> TO TARGET <%@>", NSStringFromSelector(anInvocation.selector), [_object description]];
        
        if (logType == AMProxySelectorObserverTypeEmpty)
        {
            NSLog(@"%@",logString);
        }
        else if (logType == AMProxySelectorObserverTypeString)
        {
            NSLog(@"%@ :: %@", logString, array[1]);
        }
        else if (logType == AMProxySelectorObserverTypeException)
        {
            NSLog(@"%@",logString);
            NSException *exception  = array[1];
            @throw exception;
        }
        else if (logType == AMProxySelectorObserverTypeBlock)
        {
            NSLog(@"%@",logString);
            void (^block)(id object) = array[1];
            block(_object);
        }
        else if (logType == AMProxySelectorObserverTypeRedirectTarget)
        {
            NSLog(@"%@",logString);
            target = array[1];
        }
    }
    
    if (![_selectorsToAvoid containsObject:[self __keyForSelector:anInvocation.selector]])
    {
        [anInvocation setTarget:target];
        [anInvocation invoke];
    }
    else
    {
        NSLog(@"AVOIDING INVOKE SELECTOR <%@> TO TARGET <%@>", NSStringFromSelector(anInvocation.selector), [_object description]);
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds)
        responds = [_object respondsToSelector:aSelector];
    
    return responds;
}

#pragma mark Public Methods

- (void)__logSelector:(SEL)selector
{
    if (selector == NULL)
        return;
    
    [_logSelectors setObject:@[@(AMProxySelectorObserverTypeEmpty)] forKey:[self __keyForSelector:selector]];
}

- (void)__logSelector:(SEL)selector andPrintMessage:(NSString*)message
{
    if (selector == NULL)
        return;
    
    if (!message)
        [self __logSelector:selector];
    else
        [_logSelectors setObject:@[@(AMProxySelectorObserverTypeString), message] forKey:[self __keyForSelector:selector]];
}

- (void)__logSelector:(SEL)selector andThrowException:(NSException*)exception
{
    if (selector == NULL)
        return;
    
    if (!exception)
        [self __logSelector:selector];
    else
        [_logSelectors setObject:@[@(AMProxySelectorObserverTypeException), exception] forKey:[self __keyForSelector:selector]];
}

- (void)__logSelector:(SEL)selector andCallBlock:(void (^)(id object))block
{
    if (selector == NULL)
        return;
    
    if (block == NULL)
        [self __logSelector:selector];
    else
        [_logSelectors setObject:@[@(AMProxySelectorObserverTypeBlock), block] forKey:[self __keyForSelector:selector]];
}

- (void)__logSelector:(SEL)selector andRedirectToTarget:(id)target
{
    if (selector == NULL)
        return;
    
    if (!target)
        [self __avoidSelector:selector];
    else
        [_logSelectors setObject:@[@(AMProxySelectorObserverTypeRedirectTarget), target] forKey:[self __keyForSelector:selector]];
}

- (void)__avoidSelector:(SEL)selector
{
    if (selector == NULL)
        return;
    
    [_selectorsToAvoid addObject:[self __keyForSelector:selector]];
}

#pragma mark Private Methods

- (id<NSCopying>)__keyForSelector:(SEL)selector
{
    return [NSValue valueWithPointer:selector];
}

@end
