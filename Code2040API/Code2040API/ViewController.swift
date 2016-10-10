//
//  ViewController.swift
//  Code2040API
//
//  Created by Sebastian Cueva-Caro on 10/9/16.
//  Copyright © 2016 Sebastian Cueva-Caro. All rights reserved.
//

import Alamofire
import UIKit

class ViewController: UIViewController {

    
    @IBAction func connectToAPI() {
        let params = ["token": Constants.token, "github": Constants.githubURL]
        let endpoint = Endpoint.register
        postRequest(endpoint, parameters: params) { response in }
    }
    
    
    @IBAction func reverseString() {
        var params = ["token": Constants.token]
        let endpoint = Endpoint.reverse
        postRequest(endpoint, parameters: params) { response in
            let reversedString = String(response.characters.reversed())
            params["string"] = reversedString
            self.postRequest(Endpoint.validate(endpoint), parameters: params) { response in }
        }
    }
    
    
    @IBAction func locateNeedle() {
        var params = ["token": Constants.token]
        let endpoint = Endpoint.haystack
        postRequestExpectingJSON(endpoint, parameters: params) { response in
            let needle = response["needle"] as! String
            let haystack = response["haystack"] as! [String]
            let pos = haystack.index(of: needle)
            
            params["needle"] = "\(pos != nil ? pos! : -1)"
            self.postRequest(Endpoint.validate(endpoint), parameters: params) { reponse in }
        }
    }
    
    
    @IBAction func prefixStrings() {
        
    }
    
    
    @IBAction func dateAfterInterval(_ sender: UIButton) {
    }
    
    
    func postRequest(_ endpoint: String, parameters: [String : String],
                     completionHandler: @escaping ((String) -> Void)) {
        
        let url = "\(Constants.url)\(endpoint)"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            if let status = response.response?.statusCode {
                switch(status) {
                case 200..<300:
                    print("Success")
                default:
                    print("Error with response: \(status)")
                }
            }
            
            if let string = response.result.value {
                print("String: \(string)")
                
                completionHandler(string)
            } else {
                print("\(response.result)")
            }
        }
    }
    
    
    // For some reason the API returns a string (not JSON object) for single string responses
    // That or there's something I don't understand about Alamofire
    func postRequestExpectingJSON(_ endpoint: String, parameters: [String : String],
                     completionHandler: @escaping ((NSDictionary) -> Void)) {
        
        let url = "\(Constants.url)\(endpoint)"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status) {
                case 200..<300:
                    print("Success")
                default:
                    print("Error with response: \(status)")
                }
            }
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                completionHandler(JSON as! NSDictionary)
            } else {
                print("\(response.result)")
            }
        }
    }


}

