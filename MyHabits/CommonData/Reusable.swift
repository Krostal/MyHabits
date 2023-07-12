//
//  Reusable.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 08.07.2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
