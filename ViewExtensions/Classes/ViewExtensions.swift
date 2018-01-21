//
//  ViewExtensions.swift
//  ViewExtensions
//
//  Created by Serhiy Vysotskiy on 21.01.2018.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import UIKit.UIView
import Atom

// MARK: - Gestures
public extension UIView {
    private static var _handlers: Atomic<[String: [String: () -> ()]]> = Atomic([:])
    
    public enum Gesture {
        case tap
        case pan
        case pinch
        case longPress
        case rotation
        case swipe
        case screenEdgePan
        
        public var gesture: UIGestureRecognizer {
            switch self {
            case .tap:
                return UITapGestureRecognizer()
            case .pan:
                return UIPanGestureRecognizer()
            case .pinch:
                return UIPinchGestureRecognizer()
            case .longPress:
                return UILongPressGestureRecognizer()
            case .rotation:
                return UIRotationGestureRecognizer()
            case .swipe:
                return UISwipeGestureRecognizer()
            case .screenEdgePan:
                return UIScreenEdgePanGestureRecognizer()
            }
        }
        
        public init?(gesture: UIGestureRecognizer) {
            switch gesture {
            case is UITapGestureRecognizer:
                self = .tap
            case is UIPanGestureRecognizer:
                self = .pan
            case is UIPinchGestureRecognizer:
                self = .pinch
            case is UILongPressGestureRecognizer:
                self = .longPress
            case is UIRotationGestureRecognizer:
                self = .rotation
            case is UITapGestureRecognizer:
                self = .tap
            case is UISwipeGestureRecognizer:
                self = .swipe
            case is UIScreenEdgePanGestureRecognizer:
                self = .screenEdgePan
            default:
                return nil
            }
        }
    }
    
    @discardableResult
    public func recognize(_ gesture: Gesture, target: Any, action: Selector) -> UIGestureRecognizer {
        let recognizer = gesture.gesture
        recognizer.addTarget(target, action: action)
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        return recognizer
    }
    
    @discardableResult
    public func recognize(_ gesture: Gesture, handler: @escaping () -> ()) -> UIGestureRecognizer {
        let recognizer = gesture.gesture
        recognizer.addTarget(self, action: #selector(_callHandler(_:)))
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        
        UIView._handlers.mutate {
            $0[hashString, default: [:]][recognizer.hashString] = handler
        }
        
        return recognizer
    }
    
    @objc private func _callHandler(_ sender: UIGestureRecognizer) {
        UIView._handlers.value[hashString]?[sender.hashString]?()
    }
    
}


// MARK: - Layer properties
public extension UIView {
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
    }
}


// MARK: - Padding
public extension UIView {
    private static var _paddings: Atomic<[String: CGFloat]> = Atomic([:])
    
    public var padding: CGFloat {
        set {
            UIView._paddings.mutate {
                $0[hashString] = newValue
            }
        }
        
        get {
            return UIView._paddings.value[hashString] ?? 0
        }
    }
    
    public func point(inside point: CGPoint) -> Bool {
        return CGRect(x: bounds.origin.x - padding, y: bounds.origin.y - padding, width: bounds.width + 2 * padding, height: bounds.height + 2 * padding).contains(point)
    }
}

extension Hashable {
    var hashString: String {
        return "\(hashValue)"
    }
}
