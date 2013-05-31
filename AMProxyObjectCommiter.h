//
//  AMProxyObjectCommiter.h
//  Created by Joan Martin.
//  Take a look to my repos at http://github.com/vilanovi
//

#import <Foundation/Foundation.h>

extern NSString * const AMProxyObjectCommiterNillyfiedValuesKey;
extern NSString * const AMProxyObjectCommiterChangedValuesKey;

@interface AMProxyObjectCommiter : NSProxy

/*!
 * Main init method.
 * @param object The object to track.
 * @return The AMProxyObjectCommiter instance initialized.
 */
- (id)__initWithObject:(id)object;

/*!
 * @property The tracked object.
 */
@property (nonatomic, readonly) id __object;

/*!
 * Use this method to commit changes for the given key.
 * @param key The key of the value.
 */
- (void)__commitChangesForKey:(NSString*)key;

/*!
 * This method commits all tracked changes for all keys.
 */
- (void)__commitChanges;

/*!
 * Get the current tracked changes.
 * @return A dictionary containing the changes.
 * @discussion The dictonary contains two keys 'AMProxyObjectCommiterNillyfiedValuesKey' with a value of type array containing all the keys with nil values and 'AMProxyObjectCommiterChangedValuesKey' with a value of type dictionary containing all new key values.
 */
- (NSDictionary*)__changes;

/*!
 * Check if the value for the given key has been modifyed.
 * @param key The key of the value.
 * @return YES if modifyed, otherwise NO.
 */
- (BOOL)__didChangeForKey:(NSString*)key;

/*!
 * Get the current edited value.
 * @param key The key of the value.
 * @return The edited value.
 * @discussion This method is equivalent to method '-valueForKey:' applyed to the proxy object.
 */
- (id)__editedValueForKey:(NSString*)key;

/*!
 * Get the non-edited (original) value for the given key.
 * @param key The key of the value.
 * @return The edited value.
 * @discussion This method is equivalent to method '-valueForKey:' or the current accessor applyed to the original object. Also, you can get the original value just by calling the accessor (via non KVC).
 */
- (id)__originalValueForKey:(NSString*)key;

/*!
 * TODO
 */
- (void)__trackSetSelector:(SEL)setSelector forGetSelector:(SEL)getSelector;

@end
