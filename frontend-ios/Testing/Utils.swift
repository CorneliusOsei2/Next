//
//  Utils.swift
//  Testing
//
//  Created by Joey Morquecho on 5/5/22.
//

import Foundation
import UIKit

struct Utils {
    /// [hexStr] must be of format '#000000'
    static func colorFromHexStr(hexStr: String, alpha: CGFloat = 1.0) -> UIColor {
        let parsedStr = String(hexStr.dropFirst())
        
        var rgbValue: UInt64 = 0
        Scanner(string: parsedStr).scanHexInt64(&rgbValue)

        let red = (rgbValue >> 16) & 0xFF
        let green = (rgbValue >> 8) & 0xFF
        let blue = rgbValue & 0xFF
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
}

