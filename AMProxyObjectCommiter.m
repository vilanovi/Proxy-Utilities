//
//  AMProxyObjectCommiter.m
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//

#import "AMProxyObjectCommiter.h"

NSString * const AMProxyObjectCommiterNillyfiedValuesKey = @"AMProxyObjectCommiterNillyfiedValuesKey";
NSString * const AMProxyObjectCommiterChangedValuesKey = @"AMProxyObjectCommiterChangedValuesKey";

@implementation AMProxyObjectCommiter
{
    id _object;
    NSMutableDictionary *_keyedValues;
    NSMutableSet *_nilValues;
    
    NSMutableSet *_trackedGetSelectors;
    NSMutableSet *_trackedSetSelectors;
    NSMutableDictionary *_trackedSelectorsMap;
}

- (id)__initWithObject:(id)object
{
    if (self)
    {
        _object = object;
        _keyedValues = [NSMutableDictionary dictionary];
        _nilValues = [NSMutableSet set];
        
        _trackedSetSelectors = [NSMutableSet set];
        _trackedGetSelectors = [NSMutableSet set];
        _trackedSelectorsMap = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Properties

- (id)__object
{
    return _object;
}

#pragma mark NSProxy Methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if (invocation.methodSignature == [_object methodSignatureForSelector:@selector(setValue:forKey:)])
    {
        __unsafe_unretained id tempValue = nil;
        NSString *key = nil;
        [invocation getArgument:&tempValue atIndex:2];
        [invocation getArgument:&key atIndex:3];
        
        id value = tempValue;
        
        if (key != nil)
        {
            id oldValue = [_object valueForKey:key];
            if (![oldValue isEqual:value])
            {
                if (value != nil)
                {
                    [_keyedValues setValue:value forKey:key];
                    [_nilValues removeObject:key];
                }
                else
                {
                    [_nilValues addObject:key];
                }
            }
            else
            {
                [_keyedValues removeObjectForKey:key];
                [_nilValues removeObject:key];
            }
            
            [invocation setTarget:nil];
            [invocation invoke];
        }
        else
        {
            [invocation setTarget:_object];
            [invocation invoke];
        }
    }
    else if (invocation.methodSignature == [_object methodSignatureForSelector:@selector(valueForKey:)])
    {
        NSString *key = nil;
        [invocation getArgument:&key atIndex:2];
        
        
        if ([_keyedValues valueForKey:key])
        {
            [invocation setTarget:_keyedValues];
            [invocation invoke];
        }
        else
        {
            [invocation setTarget:_object];
            [invocation invoke];
        }
    }
    else if ([_trackedGetSelectors containsObject:[NSValue valueWithPointer:invocation.selector]])
    {
        [invocation setTarget:_keyedValues];
        NSValue *value = [NSValue valueWithPointer:invocation.selector];
        [invocation setArgument:&value atIndex:2];
        [invocation invoke];
    }
    else if ([_trackedSetSelectors containsObject:[NSValue valueWithPointer:invocation.selector]])
    {
        __unsafe_unretained id tempValue = nil;
        [invocation getArgument:&tempValue atIndex:2];
        id value = tempValue;
        
        [_keyedValues setValue:value forKey:[_trackedSelectorsMap objectForKey:[NSValue valueWithPointer:invocation.selector]]];
        
        [invocation setTarget:nil];
        [invocation invoke];
    }
    else
    {
        [invocation setTarget:_object];
        [invocation invoke];
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

- (void)__commitChanges
{
    NSDictionary *keyValues = [_keyedValues copy];
    [_object setValuesForKeysWithDictionary:keyValues];
    
    for (NSString *key in _nilValues)
        [_object setValue:nil forKey:key];
    
    [_keyedValues removeAllObjects];
    [_nilValues removeAllObjects];
}

- (void)__commitChangesForKey:(NSString*)key
{
    id value = [_keyedValues valueForKey:key];
    
    if (value)
        [_object setValue:value forKey:key];
    else if ([_nilValues containsObject:key])
        [_object setValue:nil forKey:key];
    
    [_keyedValues removeObjectForKey:key];
    [_nilValues removeObject:key];
}

- (NSDictionary*)__changes
{
    return @{AMProxyObjectCommiterChangedValuesKey : [_keyedValues copy],
             AMProxyObjectCommiterNillyfiedValuesKey : [_nilValues copy]};
}

- (BOOL)__didChangeForKey:(NSString*)key
{
    return [_keyedValues valueForKey:key] != nil || [_nilValues containsObject:key];
}

- (id)__editedValueForKey:(NSString*)key
{
    id value = [_keyedValues valueForKey:key];
    
    if (value)
        return value;
    
    if ([_nilValues containsObject:key])
        return [NSNull null];
    
    return nil;
}

- (id)__originalValueForKey:(NSString*)key
{
    return [_object valueForKey:key];
}

- (void)__trackSetSelector:(SEL)setSelector forGetSelector:(SEL)getSelector
{
    [_trackedSetSelectors addObject:[NSValue valueWithPointer:setSelector]];
    [_trackedGetSelectors addObject:[NSValue valueWithPointer:getSelector]];
    [_trackedSelectorsMap setObject:[NSValue valueWithPointer:getSelector] forKey:[NSValue valueWithPointer:setSelector]];
}

@end

