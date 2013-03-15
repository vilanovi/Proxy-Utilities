//
//  AMProxySelectorHandler.h
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//

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
- (void)__logSelector:(SEL)selector andCallBlock:(void (^)())block;

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
