//
//  Injected.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
