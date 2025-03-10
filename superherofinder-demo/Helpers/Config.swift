//
//  Config.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 9/3/25.
//

import Foundation

enum Config {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var apiKey: String {
        return try! Config.value(for: "API_KEY")
    }
    
    static var apiBaseURL: URL {
        return try! URL(string: Config.value(for: "API_BASE_URL"))!
    }
}
