//
//  ButtonGestures.swift
//  ViewExtensions
//
//  Created by Serhiy Vysotskiy on 10/3/18.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import UIKit.UIButton

// MARK: - Same mechanism for UIButton
public extension UIButton {
    private static var _handlers: Atomic<[String: () -> ()]> = Atomic([:])
    private static var _animation_handlers: Atomic<[String: () -> ()]> = Atomic([:])
    
    public func handle(_ event: UIControl.Event, with action: @escaping () -> ()) {
        UIButton._handlers.mutate { $0[hashString] = action }
        addTarget(self, action: #selector(_callButtonHandler), for: event)
    }
    
    @objc private func _callButtonHandler() {
        UIButton._handlers.value[hashString]?()
        UIButton._animation_handlers.value[hashString]?()
    }
    
    public func removeHandlers() {
        if debug {
            print("Removing handlers on view \(hashString)")
        }
        
        UIButton._handlers.mutate { $0[hashString] = nil }
        UIButton._animation_handlers.mutate { $0[hashString] = nil }
    }
}

public extension UIButton {
    public var animation: (() -> ())? {
        set {
            UIButton._animation_handlers.mutate { $0[hashString] = newValue }
        }
        
        get {
            return UIButton._animation_handlers.value[hashString]
        }
    }
}
