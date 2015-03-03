# Swift - SGiTKeyboardListener

A simple listener on keyboard to use with fields in scrollviews.

This is a ultra-simple framework for Xcode that provide a single object that
can be used to track keyboard events and ensure that current input field in
visible.

This is based on Apple sample code.

You need to provide:

- a controller class to access the frame of the controlled view
- a scrollview on which insets will be updated to ensure keyboard size do not overlaps.
- a getter closure that will return the active view that must be visible.

All you need to do is to create this object. It will take care of the rest.
A bit less code in your controller and some code you can share among other controllers.

How can you use this class?

Just import the framework:

``` Swift
import SGiT_KeyboardListener
```

Then your controller shall declare a variable to keep reference to the listener:

``` Swift
var keyboardListener: KeyboardListener?
``` 

Creat the listener when the view is loaded:

```Swift
override public func viewDidLoad()
{
    super.viewDidLoad()

    keyboardListener = KeyboardListener(scrollView: tableView, controller: self) {
        return self.activeField
    }

    // to be continued...
}
```

And that's all.
