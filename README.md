Proxy-Utilities
===============

In this repository you can find differents solutions that uses NSProxy as the main pattern to solve current problems.

Right now, you can find solutions the following problems:

###1. Setting & Getting & Commiting values

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
    
Also, you can check the current changes by calling:

    NSDictionary *changes = [proxyObject __changes];
    
    // Set of keys that have been set to nil
    NSSet *nillyfiedValues = [proxyObject valueForKey:AMProxyObjectCommiterNillyfiedValuesKey];
    
    // Dictionary of key-values with the new values
    NSDictionary *changedValues = [proxyObject valueForKey:AMProxyObjectCommiterChangedValuesKey];
  

    
    


  
