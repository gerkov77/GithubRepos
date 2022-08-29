//
//  Appearance.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import UIKit
import SwiftUI

typealias Appfonts = GTHR.Appearance.Font

enum GTHR {
    enum Appearance {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeigth = UIScreen.main.bounds.height
    }
}

extension GTHR.Appearance {
    enum Font {
        case light(size: CGFloat)
        case regular(size: CGFloat)
        case medium(size: CGFloat)
        case bold(size: CGFloat)

        var font: SwiftUI.Font {

            switch self {
            case let .light(size: size):
                return SwiftUI.Font.custom("Helvetica Neue Light", size: size)
            case let .regular(size: size):
                return SwiftUI.Font.custom("Helvetica Neue", size: size)
            case let .medium(size: size):
                return SwiftUI.Font.custom("Helvetica Neue Medium", size: size)
            case let .bold(size: size):
                return SwiftUI.Font.custom("Helvetica Neue Bold", size: size)
            }
        }
    }
}
