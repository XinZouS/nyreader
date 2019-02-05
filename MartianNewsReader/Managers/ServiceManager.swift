//
//  ServiceManager.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/4/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation

final class ServiceManager: NSObject {
    
    static let shared = ServiceManager()
    
    private override init() {
        super.init()
    }
    
}

// MARK: - Language

enum SystemLanguage {
    case en, mr
}

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case martian = "mr"
    
    func selectorTitle() -> String {
        switch self {
        case .martian:
            return L("settings.change-language.tranditional-chinese")
        default:
            return L("settings.change-language.english")
        }
    }
}

enum ReadingLanguage: String {
    case english = "English"
    case martian = "Martian"
}

extension ServiceManager {
    
    // MARK: - App UI language
    func getAppLanguage() -> AppLanguage {
        // User setted language:
        if let locality = UserDefaults.standard.object(forKey: UserDefaultKeys.appLanguages.rawValue) as? [String] {
            if let currentLanguage = locality.first, let appLanguage = AppLanguage(rawValue: currentLanguage) {
                return appLanguage
            }
        }
        // if user does NOT setup AppLanguae, use System default language:
        let systemLanguage = getSystemLanguage()
        switch systemLanguage {
        case .mr:
            return AppLanguage.martian
        case .en:
            return AppLanguage.english
        }
    }
    
    func setAppLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set([language.rawValue], forKey: UserDefaultKeys.appLanguages.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    // MARK: - Reading language
    func getReadingLanguage() -> AppLanguage {
        // User setted language:
        if let locality = UserDefaults.standard.object(forKey: UserDefaultKeys.readingLanguage.rawValue) as? [String] {
            if let currentLanguage = locality.first, let appLanguage = AppLanguage(rawValue: currentLanguage) {
                return appLanguage
            }
        }
        // if user does NOT setup AppLanguae, use System default language:
        let systemLanguage = getSystemLanguage()
        switch systemLanguage {
        case .mr:
            return AppLanguage.martian
        case .en:
            return AppLanguage.english
        }
    }
    
    func setReadingLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set([language.rawValue], forKey: UserDefaultKeys.readingLanguage.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - System language
    func getSystemLanguage() -> SystemLanguage {
        if let currLanguage = Bundle.main.preferredLocalizations.first {
            switch String(describing: currLanguage) {
            case "en", "EN", "en-US", "en-CN":
                return SystemLanguage.en // English
            case "mr":
                return SystemLanguage.mr // Martian
            default:
                return SystemLanguage.en
            }
        }
        return SystemLanguage.en
    }
    
}

