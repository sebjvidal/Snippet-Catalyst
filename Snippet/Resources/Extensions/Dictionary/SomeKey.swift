//
//  SomeKey.swift
//  Snippet
//
//  Created by Seb Vidal on 05/03/2022.
//

import Foundation

extension Dictionary where Value: Equatable {
    func key(for value: Value) -> Key? {
        return first(where: { $1 == value })?.key
    }
}
