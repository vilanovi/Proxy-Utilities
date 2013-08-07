//
//  AMProxySelectorHandler.h
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//
// Copyright (c) 2013 Joan Martin, vilanovi@gmail.com.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import <Foundation/Foundation.h>

/*!
 * This proxy class add a layer to track and manipulate messages to the original object.
 */
@interface AMProxySelectorHandler : NSProxy

/*!
 * Static initializer
 * @param object The object to track.
 */
+ (AMProxySelectorHandler*)__proxyObject:(id)object;

/*!
 * Default initializer
 * @param object The object to track.
 */
- (id)__initWithObject:(id)object;

/*!
 * Use this method to log a simple message when the given selector is called.
 * @param selector The selector to track.
 */
- (void)__logSelector:(SEL)selector;

/*!
 * This method adds a customized message to log when the given selector is called.
 * @param selector The selector to track.
 * @param message The message to log.
 */
- (void)__logSelector:(SEL)selector andPrintMessage:(NSString*)message;

/*!
 * This method log a simple message and throw an exception when the given selector is called.
 * @param selector The selector to track.
 * @param exception The exception to throw.
 */
- (void)__logSelector:(SEL)selector andThrowException:(NSException*)exception;

/*!
 * Log a simple message and executes the given block when the given selector is called.
 * @param selector The selector to track.
 * @param block The block to call.
 */
- (void)__logSelector:(SEL)selector andCallBlock:(void (^)(id object))block;

/*!
 * This method forwards the message specified by the given selector from the original to the tracked object to a new target.
 * @param selector The selector to track.
 * @param target The object to redirect the message.
 * @discussion Calling this method with a nil target is equivalent to use the method "-__avoidSelector":
 */
- (void)__logSelector:(SEL)selector andRedirectToTarget:(id)target;


/*!
 * This method log a simple message and avoids the calling for the given selector.
 * @param selector The selector to track.
 */
- (void)__avoidSelector:(SEL)selector;

@end
