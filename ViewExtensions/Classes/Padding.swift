//
//  Padding.swift
//  
//
//  Created by Serhiy Vysotskiy on 8/16/18.
//

import UIKit


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


// MARK: - Override point(inside:event:)


extension UIButton {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.point(inside: point)
    }
}

extension UIImageView {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.point(inside: point)
    }
}

extension UILabel {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.point(inside: point)
    }
}
