//
//  Numeric.swift
//
//
//  Created by antonin on 02/12/2023.
//

import Foundation

extension Sequence where Element: Numeric {
    /// Sum the elements of the Numeric array
    func sum(start at: Int = 0) -> Element { return reduce(0, +) }
}
