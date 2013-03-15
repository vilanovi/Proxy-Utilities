Proxy-Utilities
===============

In this repository you can find differents solutions that uses `NSProxy` as the main pattern to solve current problems.

Right now, you can find solutions the following problems:

#Setting & Getting & Commiting values

Use the `AMProxyObjectCommiter` to create a proxy object that responds messages as a given object but where you can "set" and "get" properties and then "commit" them.

You will setup a proxy object commiter doing:

    // This is any object you want
    MyObject *object = [[MyObject alloc] init];
    
    // Creating the proxy object commiter
    AMProxyObjectCommiter *proxyObject = [AMProxyObjectCommiter alloc] __initWithObject:object];
  
Because `AMProxyObjectCommiter` will forward all messages to the original object, you can even cast the instance to usit as a normal original object class.

    MyObject *commiterObject = (MyObject*)proxyObject;
    

Then, you can use the `commiterObject` as a normal object of type `MyObject`. Whenever you want to get or set a value that you want to be able to commit later, you should access these propertys using key value coding.

    // Setting the value for key "name" as "John".
    [commiterObject setValue:@"John" forKey:@"name"];
    
    // Reading the value for key "name"
    NSString *name = [commiterObject valueForKey:@"name"];
    
Finally, you can commit the assignment just by calling:

    // Commit only the change for the value for key "name"
    [proxyObject __commitChangesForKey:@"name"];
    
    // Commit all changes
    [proxyObject __commitChanges];
    
Also, you can check the current changes by calling:

    NSDictionary *changes = [proxyObject __changes];
    
    // Set of keys that have been set to nil
    NSSet *nillyfiedValues = [proxyObject valueForKey:AMProxyObjectCommiterNillyfiedValuesKey];
    
    // Dictionary of key-values with the new values
    NSDictionary *changedValues = [proxyObject valueForKey:AMProxyObjectCommiterChangedValuesKey];
    
###Example of use
To understand what is exactly happening, just check the following lines:

    // Creating object
    MyObject *object = [[MyObject alloc] init];
    
    // Creating proxy
    AMProxyObjectCommiter *proxyObject = [AMProxyObjectCommiter alloc] __initWithObject:object];
    MyObject *commiterObject = (MyObject*)proxyObject;
    
    // Setting the object's "name" as "David".
    object.name = @"David";
    
    // Setting the proxy object's "name" as "John";
    [commiterObject setValue:@"John" forKey:@"name"];
    
    NSLog(@"Name: %@",object.name); // $> Name: David
    NSLog(@"Name: %@",commiterObject.name); // $> Name: David
    NSLog(@"Name: %@",[commiterObject valueForKey:@"name"]); // $> Name: John
    
    // Commiting changes
    [proxyObject __commitChanges];
    
    NSLog(@"Name: %@",object.name); // $> Name: John
    NSLog(@"Name: %@",commiterObject.name); // $> Name: John
    NSLog(@"Name: %@",[commiterObject valueForKey:@"name"]); // $> Name: John
      
#Object Selector Call Tracking & Debugging
    
This proxy class add a layer to track and manipulate messages to a given object. You will be able to be notified when a specific selector is called and even get the chance to cusotmize a specific behaviour by using blocks, forwarding calls, etc.

To initialize your proxy object just do:

    // Creating the original object
    MyObject *object = [[MyObject alloc] init];
    
    // Creating the proxy object
    AMProxySelectorHandler *selectorHandler = [[AMProxySelectorHandler alloc] __initWithObject:object];
    
    // Also you can do it by:
    AMProxySelectorHandler *selectorHandler = [AMProxySelectorHandler __proxyObject:object];

Now you can track when a specific selector is called in the original object just by calling one of those methods:
    
    // Log a simple message (console)
    [selectorHandler __logSelector:@selector(foo)];
    
    // Log a customized message (console)
    [selectorHandler __logSelector:@selector(foo) andPrintMessage:@"Foo has been called now"];
    
    // Log a simple message (console) and throw an exception
    [selectorHandler __logSelector:@selector(foo) andThrowException:exception];
    
    // Log a simple message (console) and call a block
    [selectorHandler __logSelector:@selector(foo) andCallBlock:^(id object){
        // Do some stuff here
        // You can use the original "object" to do even more stuff
    }];
    
    // Log a simple message (console) and redirect the call to a new target
    [selectorHandler __logSelector:@selector(foo) andRedirectToTarget:otherObject];
    
    // Log a simple message (console) and stop the call
    [selectorHandler __avoidSelector:@selector(foo)];

Finaly, because `AMProxySelectorHandler` is forwarding calls to the original object, you can cast it to use it as a normal `MyObject` instance.

    MyObject *proxyObject = (MyObject*)selectorHandler;

###Example of use

    MyObject *object = [[MyObject alloc] init];
    AMProxySelectorHandler *selectorHandler = [AMProxySelectorHandler __proxyObject:object];
    
    NSException *exception = [NSException exceptionWithName:@"DO NOT CALL FOO" reason:@"Foo is a deprecated method" userInfo:nil];
    [selectorHandler __logSelector:@selector(foo) andThrowException:exception];
    
    MyObject *proxyObject = (MyObject*)selectorHandler;
    
    [object fii]; // <-- Does the same as the next line
    [proxyObject fii]; // <-- Does the same as the previous line
    
    [object foo]; // <-- Foo will be called
    [proxyObject foo]; // <--- Will raise exception
    


    


  
