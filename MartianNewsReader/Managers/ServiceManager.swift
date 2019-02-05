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
            return L("article.change-language.martian")
        default:
            return L("article.change-language.english")
        }
    }
}

enum ReadingLanguage: String {
    case english = "English"
    case martian = "Martian"
}

extension ServiceManager {
    
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


