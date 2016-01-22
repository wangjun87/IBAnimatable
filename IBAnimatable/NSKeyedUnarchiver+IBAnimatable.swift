//
//  Created by Jake Lin on 1/22/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import Foundation
import UIKit

// Use Method Swizzling to convert `String` to emun when loading runtime attributes from Storybaord.
// http://nshipster.com/swift-objc-runtime/
public extension NSKeyedUnarchiver {
  public override class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }
    
    // make sure this isn't a subclass
    if self !== NSKeyedUnarchiver.self {
      return
    }
    
    dispatch_once(&Static.token) {
      let originalSelector = Selector("setValue:forUndefinedKey:")
      let swizzledSelector = Selector("iba_setValue:forUndefinedKey:")
      
      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
      
      let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
      
      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
  
  // MARK: - Method Swizzling
  func iba_setValue(value: AnyObject?, forUndefinedKey key: String) {
    if (key == "animationType") {
      setValue(value, forKey: "animationTypeRaw")
    }
  }
}

extension UIViewController {
  public override class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }
    
    // make sure this isn't a subclass
    if self !== UIViewController.self {
      return
    }
    
    dispatch_once(&Static.token) {
      let originalSelector = Selector("viewWillAppear:")
      let swizzledSelector = Selector("nsh_viewWillAppear:")
      
      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
      
      let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
      
      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
  
  // MARK: - Method Swizzling
  
  func nsh_viewWillAppear(animated: Bool) {
    self.nsh_viewWillAppear(animated)
    print("viewWillAppear: \(self)")
  }
}
