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
        let response = Alamofire.request(Constants.apiURL, method: .post, parameters: parameters)
        print("Reponse:\n\(response)")
    }
    

}

