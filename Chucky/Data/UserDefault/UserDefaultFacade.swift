//
//  UserDefaultFacade.swift
//  Chucky
//
//  Created by Andre Nogueira on 18/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import RxSwift

enum SearchKeys: String {
    case first = "first_access"
    case last = "last_search"
}

protocol UserDefaultFacadeContract {
    var lastSearch: Observable<[String]> {  get }
    var firstAccess: Bool {  get set }
    
    func addSearch(_ string: String)
    func clear()
}

class UserDefaultFacade: UserDefaultFacadeContract {
    
    private let limitToSave = 100
    var firstAccess: Bool {
           get {
            return userDefaults.bool(forKey: SearchKeys.first.rawValue)
           } set {
            userDefaults.set(newValue, forKey: SearchKeys.first.rawValue)
           }
   }
    
    let userDefaults: UserDefaults
    var lastSearch: Observable<[String]> {
           return userDefaults.rx
            .observe([String].self, SearchKeys.last.rawValue)
               .distinctUntilChanged()
               .unwrap()
   }
    
    init(with userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: ["first_access": true])
    }
    
    func addSearch(_ string: String) {
        let current = userDefaults.array(forKey: SearchKeys.last.rawValue) as? [String] ?? []
        let newArray = self.addNewSearch(string.lowercased(), current: current)
        userDefaults.set(newArray, forKey: SearchKeys.last.rawValue)
   }
    
    func addNewSearch(_ string: String, current: [String]) -> [String] {
           var newArray = current
           
           //if there is a repeated element, remove old one
        if let index = newArray.firstIndex(of: string) {
               newArray.remove(at: index)
           }
           
           //if array is not full, always insert item at position 0
           if current.count < limitToSave {
               newArray.insert(string, at: 0)
               return newArray
           } else {
               //add new element at first position of array.remov
               newArray.removeLast()
               newArray.insert(string, at: 0)
               return newArray
           }
    }
           
    
     func clear() {
        userDefaults.removeObject(forKey: SearchKeys.last.rawValue)
        userDefaults.removeObject(forKey: SearchKeys.first.rawValue)
     }
    
   
}
