//
//  RestApiManager.swift
//  Pods
//
//  Created by Chris on 1/25/17.
//
//  A lot of this code comes from here: https://devdactic.com/parse-json-with-swift/
//
//
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

internal class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    // MARK: Perform a GET Request
    public func makeHTTPGetRequest(path: String, accessToken: String, query: String, onCompletion: @escaping ServiceResponse) {
        var queryString = path
        
        if (!query.isEmpty)
        {
            queryString.append("?")
            queryString.append(query)
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: queryString)! as URL)
        
        let session = URLSession.shared
        
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error as NSError?)
            } else {
                onCompletion(nil, error as NSError?)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    public func makeHTTPPostRequest(path: String, json: [String: String], onCompletion: @escaping ServiceResponse)
    {
        do
        {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            makeHTTPPostRequest(path: path, data: data, onCompletion: { json, err in
                
                onCompletion(json, err)
            })
        }
        catch
        {
            // TODO Error Stuffs
            onCompletion(nil, nil)
        }
    }
    
    // MARK: Perform a POST Request
    public func makeHTTPPostRequest(path: String, queryUrlEncoded: String, onCompletion: @escaping ServiceResponse)
    {
        let data = queryUrlEncoded.data(using: .utf8)!
        
        makeHTTPPostRequest(path: path, data: data, onCompletion: { json, err in

            onCompletion(json, err)
        })

    }
    
    private func makeHTTPPostRequest(path: String, data: Data, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            // Set the POST body for the request
            request.httpBody = data
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error as NSError?)
                }
            })
            task.resume()
        } catch {
            // TODO Error Stuffs
            onCompletion(nil, nil)
        }
    }
}