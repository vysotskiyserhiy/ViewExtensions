//
//  ViewExtensions.swift
//  ViewExtensions
//
//  Created by Serhiy Vysotskiy on 21.01.2018.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import UIKit.UIView
import RxSwift
import Atom

// MARK: - Gestures
public extension UIView {
    private static var _handlers: Atomic<[String: [Gesture: () -> ()]]> = Atomic([:])
    private static var _rxHandlers: Atomic<[String: [Gesture: Variable<()>]]> = Atomic([:])
    
    private static var _removeHandlers: Atomic<[String: [Gesture: () -> ()]]> = Atomic([:])
    
    public enum Gesture {
        case tap
        case pan
        case pinch
        case longPress
        case rotation
        case swipe
        case screenEdgePan
        case none
        
        init(gesture: UIGestureRecognizer) {
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
            case is UISwipeGestureRecognizer:
                self = .swipe
            case is UIScreenEdgePanGestureRecognizer:
                self = .screenEdgePan
            default:
                self = .none
            }
        }
        
        var gesture: UIGestureRecognizer? {
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
            case .none:
                return nil
            }
        }
    }
    
    func observe(_ gesture: Gesture, setup: (UIGestureRecognizer) -> () = { _ in }) -> Observable<()> {
//        print("Adding handler on view \(hashString), for gesture \(gesture)")
        let variable = Variable(())
        
        guard let recognizer = gesture.gesture else {
            return variable.asObservable()
        }
        
        setup(recognizer)
        recognizer.addTarget(self, action: #selector(_callRxHandler(_:)))
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        
        UIView._rxHandlers.mutate {
            $0[hashString, default: [:]][gesture] = variable
        }
        
        UIView._removeHandlers.mutate { (val) in
            val[hashString, default: [:]][gesture] = { [weak recognizer, weak self] in
//                print("Removing handler on view \(self?.hashString ?? "nil"), for gesture \(gesture)")
                recognizer?.removeTarget(self, action: #selector(UIView._callRxHandler(_:)))
            }
        }
        
        return variable.asObservable()
    }
    
    @discardableResult
    public func recognize(_ gesture: Gesture, target: Any, action: Selector, setup: (UIGestureRecognizer) -> () = { _ in }) -> UIGestureRecognizer? {
//        print("Adding handler on view \(hashString), for gesture \(gesture)")
        guard let recognizer = gesture.gesture else {
            return nil
        }
        
        setup(recognizer)
        recognizer.addTarget(target, action: action)
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        
        UIView._removeHandlers.mutate { (val) in
            val[hashString, default: [:]][gesture] = { [weak recognizer] in
//                print("Removing handler on view \(self?.hashString ?? "nil"), for gesture \(gesture)")
                recognizer?.removeTarget(target, action: action)
            }
        }
        
        return recognizer
    }
    
    @discardableResult
    public func recognize(_ gesture: Gesture, setup: (UIGestureRecognizer) -> () = { _ in }, handler: @escaping () -> ()) -> UIGestureRecognizer? {
//        print("Adding handler on view \(hashString), for gesture \(gesture)")
        guard let recognizer = gesture.gesture else {
            return nil
        }
        
        setup(recognizer)
        recognizer.addTarget(self, action: #selector(_callHandler(_:)))
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        
        UIView._handlers.mutate {
            $0[hashString, default: [:]][gesture] = handler
        }
        
        UIView._removeHandlers.mutate { (val) in
            val[hashString, default: [:]][gesture] = { [weak recognizer, weak self] in
//                print("Removing handler on view \(self?.hashString ?? "nil"), for gesture \(gesture)")
                recognizer?.removeTarget(self, action: #selector(UIView._callHandler(_:)))
            }
        }
        
        return recognizer
    }
    
    func removeRecognizers() {
//        print("Removing handlers on view \(hashString)")
        UIView._removeHandlers.mutate { $0.removeValue(forKey: hashString)?.valuesArray.forEach({$0()}) }
        UIView._handlers.mutate { $0[hashString] = [:] }
        UIView._rxHandlers.mutate { $0[hashString] = [:] }
    }
    
    @objc private func _callHandler(_ sender: UIGestureRecognizer) {
        let gesture = Gesture(gesture: sender)
        UIView._handlers.value[hashString]?[gesture]?()
//        print("Calling handler on view \(hashString), for gesture \(gesture)")
    }
    
    @objc private func _callRxHandler(_ sender: UIGestureRecognizer) {
        let gesture = Gesture(gesture: sender)
        UIView._rxHandlers.value[hashString]?[gesture]?.value = ()
    }
}


// MARK: - Layer properties
public extension UIView {
    public var layerCornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    public var layerBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    public var layerBorderColor: UIColor? {
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

extension UIView {
    var hashString: String {
        return "\(hash)"
    }
}

extension Dictionary {
    var keySet: Set<Key> {
        return Set(keys)
    }
    
    var valuesArray: [Value] {
        return Array(values)
    }
}


