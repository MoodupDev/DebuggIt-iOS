//
//  TokenManager.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 09.12.2016.
//
//

import RNCryptor

class TokenManager {
    
    // MARK: - Properties
    private let serviceName = "com.moodup.debuggit"
    private let storedKeysKey = "debuggit_token_manager_keys"
    
    private var keys: [String]!
    
    private var encryptor: RNCryptor.Encryptor
    private var decryptor: RNCryptor.Decryptor
    
    var defaults: UserDefaults! {
        return UserDefaults.standard
    }
    
    static let sharedManager = TokenManager()
    
    private init() {
        self.encryptor = RNCryptor.Encryptor(password: serviceName)
        self.decryptor = RNCryptor.Decryptor(password: serviceName)
        self.keys = self.defaults.array(forKey: storedKeysKey) as? [String] ?? [String]()
    }
    
    func put(key: String, value: String?) {
        if let data = value?.data(using: .utf8) {
            defaults.setValue(encryptor.encrypt(data: data), forKey: key)
            defaults.synchronize()
            addKey(key)
        }
    }
    
    func get(key: String, defaultValue: String? = nil) -> String? {
        if let value = defaults.data(forKey: key) {
            do {
                return try String(data: decryptor.decrypt(data: value), encoding: .utf8) ?? defaultValue
            } catch {
                return defaultValue
            }
        }
        return defaultValue
    }
    
    func remove(_ key: String) {
        defaults.removeObject(forKey: key)
        deleteKey(key)
    }
    
    func remove(_ keys: [String]) {
        for key in keys {
            remove(key)
        }
    }
    
    func removeAll() {
        remove(self.keys)
    }
    
    private func addKey(_ key: String) {
        if !keys.contains(key) {
            keys.append(key)
            saveKeys()
        }
    }
    
    private func deleteKey(_ key: String) {
        if let index = keys.index(of: key) {
            keys.remove(at: index)
            saveKeys()
        }
    }
    
    private func saveKeys() {
        defaults.setValue(self.keys, forKey: storedKeysKey)
        defaults.synchronize()
    }
}
