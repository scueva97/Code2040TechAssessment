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
        let parameters = ["token": Constants.token, "github": Constants.githubURL]
        
        postRequest(endpoint: Endpoint.register, parameters: parameters) { response in }
    }
    
    
    @IBAction func reverseString() {
        var parameters = ["token": Constants.token]
        postRequest(endpoint: Endpoint.reverse, parameters: parameters) { response in
            let string = response.result.value!
            let reversedString = String(string.characters.reversed())
            parameters["string"] = reversedString
            self.postRequest(endpoint: Endpoint.reverseValidate, parameters: parameters) { response in }
        }
    }
    
    func postRequest(endpoint: String, parameters: [String : String],
                     completionHandler: @escaping ((DataResponse<String>) -> Void)) {
        
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
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                completionHandler(response)
            } else {
                print("\(response.result)")
            }
        }
    }

}

