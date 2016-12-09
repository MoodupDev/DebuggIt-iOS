//
//  TokenManager.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 09.12.2016.
//
//

import KeychainAccess

class TokenManager {
    
    // MARK: - Properties
    
    private let serviceName = "com.moodup.debuggit"
    private var keychain: Keychain
    
    static let sharedManager = TokenManager()
    
    private init() {
        self.keychain = Keychain(service: serviceName)
    }
    
    func put(key: String, value: String?) {
        keychain[key] = value
    }
    
    func get(key: String, defaultValue: String? = nil) -> String? {
        return keychain[key] ?? defaultValue
    }
    
    func remove(_ key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("Error while removing key ", key, #function, error)
        }
    }
    
    func removeAll() {
        do {
            try keychain.removeAll()
        } catch let error {
            print("Error while removing all tokens in ", #function, error)
        }
    }
    
    func remove(_ keys: String... ) {
        for key in keys {
            remove(key)
        }
    }
}
