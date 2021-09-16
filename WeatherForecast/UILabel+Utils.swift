//
//  UILabel+Utils.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 16/09/2021.
//

import UIKit

extension UILabel {
    
    func useDynamicFont(forTextStyle textStyle: UIFont.TextStyle) {
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
        self.adjustsFontForContentSizeCategory = true
    }
}
