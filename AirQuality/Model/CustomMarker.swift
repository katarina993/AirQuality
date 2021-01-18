//
//  CustomMarker.swift
//  AirQuality
//
//  Created by Katarina Tomic on 11/26/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMarker: GMSMarker {

    var label: UILabel!


    init(measurementsValue: Int) {
        super.init()

        let iconView = UIImageView(image: UIImage(named: "map_marker_icon"))
       
    
        label = UILabel(frame: CGRect(x: 6, y: 6, width: iconView.bounds.width - 12   , height: iconView.bounds.height - 28  ))
        if measurementsValue <= 12 {
        label.backgroundColor = .white
        }
        else if measurementsValue > 12 && measurementsValue < 55 {
            label.backgroundColor = .yellow
        }
        else if measurementsValue > 55 && measurementsValue < 150 {
            label.backgroundColor = .yellow
            
        } else {
            label.backgroundColor = .red
            label.textColor = .white
        }
        
        label.textAlignment = .center
        label.text = String(measurementsValue)
        iconView.addSubview(label)

        self.iconView = iconView
    }
}

