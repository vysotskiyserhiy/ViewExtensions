//
//  Extensions.swift
//  
//
//  Created by Serhiy Vysotskiy on 8/16/18.
//

import UIKit.UIView

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
