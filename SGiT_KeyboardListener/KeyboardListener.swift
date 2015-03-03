//
//  KeyboardListener.swift
//  me-Metrics
//
//  Created by Sylvain on 25/02/2015.
//  Copyright (c) 2015 S.G. inTech. All rights reserved.
//

import UIKit

/** Obvious class to show input fields that could be hidden by keyboard.

    This object will listen to keyboard display and hidden events to
    ensure that active field zill always be in visible area.
*/
public class KeyboardListener: NSObject
{
    /** View controller that delegates us the works. */
    let controller: UIViewController
    
    /** Scroll view to manage. */
    let scrollView: UIScrollView
    
    /** Accessor to the active field. 
        This shall be managed by the controller object.
     */
    let activeField: () -> UIView?
    
    /** Maintain inset state when keyboard was hidden. */
    var initialInsets = UIEdgeInsetsZero
    
    
    /** Constructor.

        @param scrollView
            Scrollview to manage inset for.
        @param controller
            The boss: view controller we will do the job for.
        @param activeFieldBloc
            Getter to access the active field to show.
     */
    public init(
        scrollView aScrollView: UIScrollView,
        controller aController: UIViewController,
        activeFieldBloc aGetter: () -> UIView?
        )
    {
        controller  = aController
        scrollView  = aScrollView
        activeField = aGetter
        
        super.init()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self,
            selector: Selector("keyboardWasShown:"),
            name: UIKeyboardDidShowNotification,
            object: nil)

        notificationCenter.addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }

    
    /** Destructor.
    
        Takes care to unsubscribe from the notification center.
     */
    deinit
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.removeObserver(self)
    }

    
    
    /** The keyboard was shown, reduce the scrollview inset.
    
        This will save the actual inset value to restore it when keyboard will
        hide again.
    
     */
    dynamic func keyboardWasShown(notification: NSNotification)
    {
        var info = notification.userInfo
        var keyboardSize = info![ UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        
        let zero = CGFloat(0.0)
        
        var contentInsets = UIEdgeInsetsMake(
            zero, zero,
            keyboardSize!.height, zero
        )
        
        // Save insets
        initialInsets = scrollView.contentInset
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets;
        
        var rect = controller.view.frame
        rect.size.height -= keyboardSize?.height ?? zero
        
        if let active = activeField()
        {
            if ( !CGRectContainsPoint(rect, active.frame.origin) ) {
                scrollView.scrollRectToVisible(active.frame, animated: true)
            }
        }
    }
    
    
    /** Keyboard is going to be dismissed, this will restore previous insets of scroll view.
     */
    dynamic func keyboardWillHide(notification: NSNotification)
    {
        var insets = initialInsets
        
        scrollView.contentInset = insets;
        scrollView.scrollIndicatorInsets = insets
    }
}
