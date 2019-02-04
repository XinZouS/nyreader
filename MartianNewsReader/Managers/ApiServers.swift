//
//  ApiServers.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation
import UIKit

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
    func getArticleListData(completion: @escaping(([[String:Any]]?) -> Void)) {
        let urlStr = "\(host)\(section)content/v1/articles.plist"
        getPListDataWithUrlRoute(urlStr) { (pList, error) in
            if let list = pList {
                completion(list)
            } else {
                DLog("[ERROR] getArticleListData: unable to parse pList from data;")
            }
        }
    }
    
    func getImageWith(url: URL, completion: @escaping(UIImage?) -> Void) {
        let imageCache = NSCache<AnyObject, AnyObject>()
        if let urlStr = url.absoluteString as? AnyObject,
            let cacheImg = imageCache.object(forKey: urlStr) as? UIImage {
            completion(cacheImg)
            return
        }
        urlSessionDataTask(url: url) { (data, response, error) in
            if let d = data, let img = UIImage(data: d) {
                print("------------ get Image !!!! -------------")
                completion(img)
            } else {
                DLog("[ERROR] getImageWithUrl: unable to unwarp UIImage from data;")
            }
        }
    }
    
    
    // MARK: - GET: basic URLSession dataTasks
    /**
     * ✅ get ([[String:Any]]?) with url string, return NULL
     */
    private func getPListDataWithUrlRoute(_ route: String, completion: @escaping([[String:Any]]?, Error?) -> Void) {
        guard let url = URL(string: route) else {
            debugLog("[ERROR] ⛔️ unable to parse url from string: \(route)")
            completion(nil, nil)
            return
        }
        
        urlSessionDataTask(url: url) { (data, response, error) in
            guard let data = data else {
                DLog("[ERROR] ⛔️ unable to get data in getPListDataWithUrlRoute!")
                completion(nil, error)
                return
            }
            do {
                guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] else {
                    DLog("[GET_ERROR] getPListDataWithUrlRoute try: unable to serialize pList...")
                    completion(nil, nil)
                    return
                }
                completion(plist, nil) // ✅ get [Dictionary]
                
            } catch let error {
                DLog("[GET_ERROR] getPListDataWithUrlRoute: \(error.localizedDescription)")
                DLog("[RESPONSE] \(response.debugDescription)")
                completion(nil, error)
            }
        }
    }
    
    

    /**
     * ✅ get (Data?) with url string, return NULL
     */
    private func urlSessionDataTask(url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
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
                completion(nil, response, err)
                return
            }
            
            if let dt = data {
                completion(dt, response, nil) // ✅ get data

            } else {
                DLog("[GET_ERROR] error value = \(error?.localizedDescription ?? "NULL")")
                DLog("[FULL RESPONSE] = \(response?.debugDescription ?? "NULL")")
                completion(nil, response, error)
            }
        }.resume()
    }
}
