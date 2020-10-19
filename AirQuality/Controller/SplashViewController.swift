//
//  SplashViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 7/31/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController  {
               
    
    @IBOutlet weak var airQuality: UILabel!
    
    @IBOutlet weak var airParis: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        openMainScreen()
    }
        

    func openMainScreen() {
        Thread.sleep(forTimeInterval: 1)

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateInitialViewController()
      
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
            window.rootViewController = mainVC
        }

    }

}

