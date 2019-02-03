//
//  ApiServers.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation

final class ApiServers: NSObject {
    
    static let shared = ApiServers()
    
    private override init() {
        super.init()
    }
    
    enum ServerKey: String {
        case data = "data"
        
        case title = "title"
        case body = "body"
        case images = "images"
        case topImage = "top_image"
        case height = "height"
        case width = "width"
        case url = "url"
    }
    
    private let host = "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/"
    private let section = "candidates/"
    
    
    // MARK: - Get contents from remote
    
    // Target: http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist
    func getArticleListData(completion: @escaping(([String:Any]?) -> Void)) {
        let urlStr = "\(host)\(section)content/v1/articles.plist"
        getPListDataWithUrlRoute(urlStr) { (dictionary, error) in
            if let dictionary = dictionary {
                print(dictionary)
            }
        }
    }
    
    
    // MARK: - basic GET and POST by url
    /**
     * ✅ get data with url string, return NULL
     */
    private func getPListDataWithUrlRoute(_ route: String, completion: @escaping(([String:Any]?, Error?) -> Void)) {
        guard let url = URL(string: route) else {
            debugLog("[ERROR] ⛔️ unable to parse url from string: \(route)")
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            #if DEBUG
            let printText: String = """
            =========================
            [TIME UTC] \(Date())
            [TIME GMT] \(Date().getCurrentLocalizedDate())
            [GET ROUTE] \(route)
            [RESPONSE] \(response?.url?.debugDescription ?? "")
            """
            print(printText)
            #endif
            
            if let err = error {
                DLog("[GET_ERROR] in URLSession dataTask: \(err.localizedDescription)")
                completion(nil, err)
                return
            }
            
            if let data = data {
                do {
                    guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] else {
                            DLog("[GET_ERROR] in getDataFromWows: unable to serialize the Data...")
                            completion(nil, nil)
                            return
                    }
                    print(plist)
//                    completion(getObject, nil) // ✅ get dictionary
                    
                } catch let error {
                    DLog("[GET_ERROR] in getDataFromWows: \(error.localizedDescription)")
                    DLog("[RESPONSE] \(response.debugDescription)")
                    completion(nil, error)
                }
            } else {
                DLog("[GET_ERROR] error value = \(error?.localizedDescription ?? "NULL")")
                DLog("[FULL RESPONSE] = \(response?.debugDescription ?? "NULL")")
                completion(nil, error)
            }
        }.resume()
    }

    
}
