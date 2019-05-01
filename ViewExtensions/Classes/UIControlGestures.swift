//
//  UIControlGestures.swift
//  ViewExtensions
//
//  Created by Serhiy Vysotskiy on 10/3/18.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import UIKit.UIControl

// MARK: - Same mechanism for UIButton
public extension UIControl {
    private static var _handlers: Atomic<[String: () -> ()]> = Atomic([:])
    private static var _animation_handlers: Atomic<[String: () -> ()]> = Atomic([:])
    
    func handle(_ event: UIControl.Event, with action: @escaping () -> ()) {
        UIControl._handlers.mutate { $0[hashString] = action }
        addTarget(self, action: #selector(_callControlHandler), for: event)
    }
    
    @objc private func _callControlHandler() {
        UIControl._handlers.value[hashString]?()
        UIControl._animation_handlers.value[hashString]?()
    }
    
    func removeHandlers() {
        if debug {
            print("Removing handlers on view \(hashString)")
        }
        
        UIControl._handlers.mutate { $0[hashString] = nil }
        UIControl._animation_handlers.mutate { $0[hashString] = nil }
    }
}

public extension UIControl {
    var animation: (() -> ())? {
        set {
            UIControl._animation_handlers.mutate { $0[hashString] = newValue }
        }
        
        get {
            return UIControl._animation_handlers.value[hashString]
        }
    }
}
