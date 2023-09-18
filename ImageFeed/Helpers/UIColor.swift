//
//  UIColor.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 18.09.2023.
//

import UIKit

extension UIColor {
    static var ypBlack: UIColor {UIColor(named: "ypBlack") ?? UIColor.black}
    static var ypWhite: UIColor {UIColor(named: "ypWhite") ?? UIColor.white}
    static var ypBackground: UIColor {UIColor(named: "ypBackground") ?? UIColor.black}
    static var ypRed: UIColor {UIColor(named: "ypRed") ?? UIColor.red}
    static var ypBlue: UIColor {UIColor(named: "ypBlue") ?? UIColor.blue}
    static var ypWhiteAlpha: UIColor {UIColor(named: "ypWhiteAlpha50") ?? UIColor.white.withAlphaComponent(50)}
    static var ypGray: UIColor {UIColor(named: "ypGray") ?? UIColor.gray}
}
