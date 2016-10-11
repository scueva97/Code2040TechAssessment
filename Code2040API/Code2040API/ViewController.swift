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
            
            print("Reversed: \(reversedString)")
            
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
            let index = pos != nil ? pos! : -1
            
            print("Needle: \(index)")
            
            params["needle"] = "\(index)"
            self.postRequest(Endpoint.validate(endpoint), parameters: params) { reponse in }
        }
    }
    
    
    @IBAction func prefixStrings() {
        var params: [String : Any] = ["token": Constants.token]
        let endpoint = Endpoint.prefix
        postRequestExpectingJSON(endpoint, parameters: params) { response in
            let prefix = response["prefix"] as! String
            let array = response["array"] as! [String]
            // Filter the elements with the prefix
            let withoutPrefix = array.filter { !$0.hasPrefix(prefix) }
            
            print("Array: \(withoutPrefix)")
            
            params["array"] = withoutPrefix
            self.postRequest(Endpoint.validate(endpoint), parameters: params) { response in }
        }
    }
    
    
    @IBAction func dateAfterInterval(_ sender: UIButton) {
        var params: [String : Any] = ["token": Constants.token]
        let endpoint = Endpoint.dating
        postRequestExpectingJSON(endpoint, parameters: params) { response in
            // Convert string to date object
            let datestamp = response["datestamp"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let date = dateFormatter.date(from: datestamp)!
            // Add time intervale to date and convert date object to string
            let interval = response["interval"] as! Int
            let newDate = date.addingTimeInterval(TimeInterval(interval))
            let newDatestamp = dateFormatter.string(from: newDate)
            
            print("New Date: \(newDatestamp)")
            
            params["datestamp"] = newDatestamp
            self.postRequest(Endpoint.validate(endpoint), parameters: params) { response in }
        }
    }
    
    
    func postRequest(_ endpoint: String, parameters: [String : Any],
                     completionHandler: @escaping ((String) -> Void)) {
        
        let url = "\(Constants.url)\(endpoint)"
        Alamofire.request(url, method: .post, parameters: parameters).responseString { response in
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
    func postRequestExpectingJSON(_ endpoint: String, parameters: [String : Any],
                     completionHandler: @escaping ((NSDictionary) -> Void)) {
        
        let url = "\(Constants.url)\(endpoint)"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
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

