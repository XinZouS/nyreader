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







// constants

//let APPLE_LANGUAGE_KEY = "AppleLanguages"
//
//class L102Language {
//    class func currentAppleLanguage() -> String{
//        return UserDefaults.getAppLanguage().rawValue
//    }
//    class func setAppleLAnguageTo(lang: String) {
//        UserDefaults.setAppLanguage(.english) // TODO: this is test only!!!!
//    }
//}
//
//class L012Localizer: NSObject {
//    class func DoTheSwizzling() {
//        // 1
//        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: Selector("localizedStringForKey:value:table:"), overrideSelector: Selector("specialLocalizedStringForKey:value:table:"))
//    }
//}
//extension Bundle {
//
//    func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
//        /*2*/let currentLanguage = L102Language.currentAppleLanguage()
//        var bundle = Bundle();
//        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
//            bundle = Bundle(path: _path)!
//        } else {
//            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
//            bundle = Bundle(path: _path)!
//        }
//        /*4*/return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
//    }
//}
//
///// Exchange the implementation of two methods for the same Class
//func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
//
//    let origMethod: Method = class_getInstanceMethod(cls, originalSelector) ?? nil
//    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector) ?? nil
//    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
//        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
//    } else {
//        method_exchangeImplementations(origMethod, overrideMethod);
//    }
//}
