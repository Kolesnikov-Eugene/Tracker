//
//  Configurator.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 28.10.2023.
//

import Swinject
import Foundation

class Configurator {
    
    private static let container = Container()
    
    static func register<T>(name: String, value: T.Type, completion: @escaping (Resolver) -> T) {
        //        container.register(type(of: value), name: name)
        //        container.register(value:, name: name, factory: completion)
        container.register(value, name: name, factory: completion)
    }
    
    static func resolve<T>(service: T.Type, name: String) -> T? {
        return container.resolve(service, name: name)
    }
}

