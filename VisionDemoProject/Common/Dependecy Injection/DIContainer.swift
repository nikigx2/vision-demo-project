//
//  DIContainer.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import Foundation

final class DIContainer {
    typealias Resolver = () -> Any

    private var resolvers = [String: Resolver]()

    static let shared = DIContainer()

    init() {
        registerDependencies()
    }

    func register<T, R>(_ type: T.Type, service: @escaping () -> R) {
        let key = String(reflecting: type)
        resolvers[key] = service
    }

    func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        if let resolver = resolvers[key], let service = resolver() as? T {
            print("🥣 Resolving new instance of \(T.self).")

            return service
        }

        fatalError("🥣 \(key) has not been registered.")
    }
}

extension DIContainer {
    func registerDependencies() {
        register(VisionServicing.self) {
            VisionService()
        }

        register(CacheServicing.self) {
            CacheService()
        }
    }
}
