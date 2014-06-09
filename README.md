![Screenshots_Row1](https://raw.githubusercontent.com/dzenbot/UITableView-DataSet/master/Examples/Applications/Screenshots/Screenshots_row1.png)
![Screenshots_Row2](https://raw.githubusercontent.com/dzenbot/UITableView-DataSet/master/Examples/Applications/Screenshots/Screenshots_row2.png)
###### Real life examples available in the sample project, with many others)

### The Empty DataSet Pattern
Most applications use list of content (datasets), which many turn out to be empty at one point, specially for new user without saved content on their device or cloud. This gives a very bad experience, by not being clear about what's going on, if there's an error or the user is supposed to do something within your app.

That is why in mobile design patterns, the **Empty Datasets** are helpful for:
* Avoiding white-screens, and taking advantage of that circunstance to explain to the user why the screen is empty.
* Calling to action (particularly for boarding process of new users).
* Avoiding other interruptive mechanisms like showing error alerts.
* Delivering a brand presence and a smooth user experience.


### Features
* Uses KVO to observe whenever the tableview calls -reloadData.
* Gives multiple possibilities of layout and appearance, by showing an image and/or title lable and/or description label and/or button.
* Uses NSAttributedString for easier appearance customisation.
* Uses auto-layout to automagically center the content to the tableview, with auto-rotation support.
* Allows tap gesture on the whole tableview bounds (useful for resigning first responder or similar actions).
* Background color customisation.
* iPhone (3.5" & 4") and iPad support. iOS7 compatible only.
* ARC & 64bits support.

This library has been designed in a way where you won't need to use an extended UITableView class. It will still work when using UITableViewController.
By simply conforming to the datasource and delegate you will be able to fully customize the content and appearance of the empty datasets for your application.


## Installation

Available in [Cocoa Pods](http://cocoapods.org/?q=UITableView-DataSet)
```
pod 'UITableView-DataSet'
```


## How to use
For complete documentation, [visit CocoaPods' auto-generated doc](http://cocoadocs.org/docsets/UITableView-DataSet/)

### Step 1: Import
```
#import "UITableView+DataSet.h"
```

### Step 2: Protocol Conformance
Conform to datasource and/or delegate.
```
@interface MainViewController : UITableViewController <DZNTableViewDataSetSource, DZNTableViewDataSetDelegate>
```

### Step 3: Data Source Implementation
Return the content you want to show on the empty datasets, and take advantage of NSAttributedString features to fully customise the text appearance.

##### The title of the dataset.
```
- (NSAttributedString *)titleForTableViewDataSet:(UITableView *)tableView {

    NSString *text = @"Please Allow Photo Access";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
```

##### The description of the dataset.
```
- (NSAttributedString *)descriptionForTableViewDataSet:(UITableView *)tableView {

    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];                      
}
```

##### The title to be used for the specified button state.
```
- (NSAttributedString *)buttonTitleForTableViewDataSet:(UITableView *)tableView forState:(UIControlState)state {

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]

    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}
```

### Step 4: Delegate Implementation
Return the behaviours you would expect from the empty datasets, and receive the user events.

##### Asks for interaction permission. Default is YES.
```
- (BOOL)tableViewDataSetShouldAllowTouch:(UITableView *)tableView {
    return YES;
}
```

##### Asks for scrolling permission. Default is NO.
```
- (BOOL)tableViewDataSetShouldAllowScroll:(UITableView *)tableView {
    return YES;
}
```

##### Notifies when the dataset view was tapped.
```
- (void)tableViewDataSetDidTapView:(UITableView *)tableView {
    
}
```

##### Notifies when the dataset call to action button was tapped.
```
- (void)tableViewDataSetDidTapButton:(UITableView *)tableView {
    
}
```

### Step 5: Deallocation
It is very **important** to set the dataSetSource and dataSetDelegate to nil, on the viewcontroller's -dealloc method. Since this library uses KVO under the hood, the observer must be removed when the tableview is going to be released.

```
- (void)dealloc
{
    self.tableView.dataSetSource = nil;
    self.tableView.dataSetDelegate = nil;
}
```


## Sample project

#### Applications
This sample project replicates several popular application's empty datasets (~20) with their exact content and appearance, such as Airbnb, Dropbox, Facebook, Foursquare, and many others. Use this project for understanding how easy and flexible it is to customize the appearance of your empty datasets.

#### Countries
This other sample project shows a list of the world countries. By searching, it autocompletes and when no content is matched, a simple empty dataset is shown. Use this project for understanding better the interaction between the UITableViewDataSource and the DZNTableDataSetSource protocols.


## Collaboration
I tried to build an easy to use API, while beeing flexible enough for multiple variations, but I'm sure there are ways of improving and adding more features, so feel free to collaborate with ideas, issues and/or pull requests.


## License
(The MIT License)

Copyright (c) 2014 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
