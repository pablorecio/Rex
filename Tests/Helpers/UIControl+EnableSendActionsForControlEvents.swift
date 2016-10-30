//
//  UIControl+EnableSendActionsForControlEvents.swift
//  Rex
//
//  Created by David Rodrigues on 24/04/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import UIKit

/// Unfortunately, there's an apparent limitation in using `sendActionsForControlEvents`
/// on unit-tests for any control besides `UIButton` which is very unfortunate since we
/// want test our bindings for `UIDatePicker`, `UISwitch`, `UITextField` and others
/// in the future. To be able to test them, we're now using swizzling to manually invoke
/// the pair target+action.
fileprivate let swizzling: (UIControl.Type) -> () = { control in
    let originalSelector = #selector(control.sendAction(_:to:for:))
    let swizzledSelector = #selector(control.rex_sendAction(_:to:forEvent:))
    
    let originalMethod = class_getInstanceMethod(control, originalSelector)
    let swizzledMethod = class_getInstanceMethod(control, swizzledSelector)
    
    let didAddMethod = class_addMethod(control,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(control,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension UIControl {
    
    open override class func initialize() {
        // make sure this isn't a subclass
        guard self === UIControl.self else { return }
        swizzling(self)
    }
    
    // MARK: - Method Swizzling
    
    func rex_sendAction(_ action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        _ = target?.perform(action, with: self)
    }
}
