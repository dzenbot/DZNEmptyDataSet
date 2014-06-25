NSManagedObjectContext-Hydrate
==============================

Have you ever wanted to preload an application's CoreData store?<br>
If you did, you must know then that it's a real painful and undocumented process. You probably tried different techniques like using Python or Ruby scripts, but it should be easier than that!<br><br>
This category class helps you by parsing and saving automagically every object from a JSON or CSV data structure into a persistent store with no effort.

## Installation

Available in [Cocoa Pods](http://cocoapods.org/?q=NSManagedObjectContext-Hydrate)
```
pod 'NSManagedObjectContext-Hydrate', '~> 1.0.3'
```

## How to use

[Check out the Doc Set](http://cocoadocs.org/docsets/NSManagedObjectContext-Hydrate/1.0.3/)

### Step 1
```
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Hydrate.h"
```

### Step 2
After initialising your Managed Object Context, you are ready to preload your JSON content into the store.
Call the following method:
```
NSString *path = [[NSBundle mainBundle] pathForResource:@"persons" ofType:@"json"];
NSDictionary *attributes = @{@"firstName":@"first_name", @"lastName":@"last_name", @"age":@"age", @"height":@"height", @"weight":@"weight"};

[_managedObjectContext hydrateStoreWithJSONAtPath:path attributeMappings:attributes forEntityName:@"Person"];
```

Or your CSV content:
```
NSString *path = [[NSBundle mainBundle] pathForResource:@"persons" ofType:@"csv"];
NSDictionary *attributes = @{@"firstName":@"first_name", @"lastName":@"last_name", @"age":@"age", @"height":@"height", @"weight":@"weight"};

[_managedObjectContext hydrateStoreWithCSVAtPath:path attributeMappings:attributes forEntityName:@"Person"];
```

### Sample project
Take a look into the sample project. Everything is there.<br>
Enjoy and collaborate if you feel this library could be improved. (Check the to-do list)


## To-Do's
- Multiple-hydrations at a time.
- Update values for existent entities.
- Refactor Refactor Refactor!


## License
(The MIT License)

Copyright (c) 2012 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
