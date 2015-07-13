DZNEmptyDataSet
=================

[![Pod Version](http://img.shields.io/cocoapods/v/DZNEmptyDataSet.svg)](http://cocoadocs.org/docsets/DZNEmptyDataSet/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

### Projects using this library

[Add your project to the list here](https://github.com/dzenbot/DZNEmptyDataSet/wiki/Projects-using-DZNEmptyDataSet) and provide a (320px wide) render of the result.


### The Empty Data Set Pattern
Also known as *[Empty State](http://emptystat.es/)* or *[Blank Slate](http://patternry.com/p=blank-slate/)*.

Most applications show lists of content (data sets), which many turn out to be empty at one point, specially for new users with blank accounts. Empty screens create confusion by not being clear about what's going on, if there is an error/bug or if the user is supposed to do something within your app to be able to consume the content.

Please read this very interesting article about [*Designing For The Empty States*](http://tympanus.net/codrops/2013/01/09/designing-for-the-empty-states/).

![Screenshots_Row1](https://raw.githubusercontent.com/dzenbot/UITableView-DataSet/master/Examples/Applications/Screenshots/Screenshots_row1.png)
![Screenshots_Row2](https://raw.githubusercontent.com/dzenbot/UITableView-DataSet/master/Examples/Applications/Screenshots/Screenshots_row2.png)
(*These are real life examples, available in the 'Applications' sample project*)

**[Empty Data Sets](http://pttrns.com/?did=1&scid=30)** are helpful for:
* Avoiding white-screens and communicating to your users why the screen is empty.
* Calling to action (particularly as an onboarding process).
* Avoiding other interruptive mechanisms like showing error alerts.
* Beeing consistent and improving the user experience.
* Delivering a brand presence.


### Features
* Compatible with UITableView and UICollectionView. Also compatible with UISearchDisplayController and UIScrollView.
* Gives multiple possibilities of layout and appearance, by showing an image and/or title label and/or description label and/or button.
* Uses NSAttributedString for easier appearance customisation.
* Uses auto-layout to automagically center the content to the tableview, with auto-rotation support. Also accepts custom vertical and horizontal alignment.
* Background color customisation.
* Allows tap gesture on the whole tableview rectangle (useful for resigning first responder or similar actions).
* For more advanced customisation, it allows a custom view.
* Compatible with Storyboard.
* Compatible with iOS 6 or later.
* Compatible with iPhone and iPad.
* **App Store ready**

This library has been designed in a way where you won't need to extend UITableView or UICollectionView class. It will still work when using UITableViewController or UICollectionViewController.
By just conforming to DZNEmptyDataSetSource & DZNEmptyDataSetDelegate, you will be able to fully customize the content and appearance of the empty states for your application.


## Installation

Available in [Cocoa Pods](http://cocoapods.org/?q=DZNEmptyDataSet)
```ruby
pod 'DZNEmptyDataSet'
```
To integrate DZNEmptyDataSet into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "dzenbot/DZNEmptyDataSet"
```


## How to use
For complete documentation, [visit CocoaPods' auto-generated doc](http://cocoadocs.org/docsets/DZNEmptyDataSet/)

### Import
```objc
#import "UIScrollView+EmptyDataSet.h"
```

### Protocol Conformance
Conform to datasource and/or delegate.
```objc
@interface MainViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}
```

### Dealloc
~~You MUST disable the datasource and/or delegate in your view controller's `dealloc` method.
This will unregister internal observers and invalidate private states.~~

Disabling the datasource and/or delegate in your the controller's `dealloc` method is no longer needed. Take a look at [#91](https://github.com/dzenbot/DZNEmptyDataSet/issues/91) for more information.


### Data Source Implementation
Return the content you want to show on the empty state, and take advantage of NSAttributedString features to customise the text appearance.

The image for the empty state:
```objc
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}
```

The attributed string for the title of the empty state:
```objc
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Please Allow Photo Access";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
```

The attributed string for the description of the empty state:
```objc
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
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

The attributed string to be used for the specified button state:
```objc
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};

    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}
```

or the image to be used for the specified button state:
```objc
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [UIImage imageNamed:@"button_image"];
}
```

The background color for the empty state:
```objc
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}
```

If you need a more complex layout, you can return a custom view instead:
```objc
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;
}
```

Additionally, you can modify the horizontal and/or vertical alignments (as when using a tableHeaderView):
```objc
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(0, -self.tableView.tableHeaderView.frame.size.height/2);
}
```


### Delegate Implementation
Return the behaviours you would expect from the empty states, and receive the user events.

Asks to know if the empty state should be rendered and displayed (Default is YES) :
```objc
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
```

Asks for interaction permission (Default is YES) :
```objc
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
```

Asks for scrolling permission (Default is NO) :
```objc
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
```

Notifies when the dataset view was tapped:
```objc
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    // Do something
}
```

Notifies when the data set call to action button was tapped:
```objc
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    // Do something
}
```

### Refresh layout
If you need to refresh the empty state layout, simply call:

```objc
[self.tableView reloadData];
```
or
```objc
[self.collectionView reloadData];
```
depending of which you are using.

### Force layout update
You can also call `[self.tableView reloadEmptyDataSet]` to invalidate the current empty state layout and trigger a layout update, bypassing `-reloadData`. This might be useful if you have a lot of logic on your data source that you want to avoid calling, when not needed. `[self.tableView reloadEmptyDataSet]` is the only way to refresh content when using with UIScrollView.


## Sample projects

#### Applications
This project replicates several popular application's empty states (~20) with their exact content and appearance, such as Airbnb, Dropbox, Facebook, Foursquare, and many others. See how easy and flexible it is to customize the appearance of your empty states. You can also use this project as a playground to test things.

#### Countries
This project shows a list of the world countries loaded from CoreData. It uses NSFecthedResultController for filtering search. When searching and no content is matched, a simple empty state is shown. See how to interact between the UITableViewDataSource and the DZNEmptyDataSetSource protocols, while using a typical CoreData stack.

#### Colors
This project is a simple example of how this library also works with UICollectionView and UISearchDisplayController, while using Storyboards.


## Collaboration
Feel free to collaborate with ideas, issues and/or pull requests.


## License
(The MIT License)

Copyright (c) 2015 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
