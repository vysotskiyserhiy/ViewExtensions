//
//  Extensions.swift
//  ViewExtensions
//
//  Created by Serhiy Vysotskiy on 10/3/18.
//  Copyright © 2018 Serhiy Vysotskiy. All rights reserved.
//

import UIKit

// support

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

