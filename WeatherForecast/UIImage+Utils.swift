//
//  UIImage+Utils.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 16/09/2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(from url: URL) {
        self.kf.setImage(with: url)
    }
}
