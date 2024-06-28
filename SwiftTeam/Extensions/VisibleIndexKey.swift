//
//  VisibleIndexKey.swift
//  MyThreads
//
//  Created by Benji Loya on 11.06.2024.
//

import SwiftUI

// MARK: - Prefernce Key for Create Post
struct VisibleIndexKey: PreferenceKey {
static var defaultValue: Int? = nil

    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = nextValue() ?? value
    }
}
