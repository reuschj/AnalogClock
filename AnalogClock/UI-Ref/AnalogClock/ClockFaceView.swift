//
//  ClockFaceView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/15/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import UIKit

class ClockFaceView: UIImageView {
    
    // TODO: Build this out
    
    // Initializer
    // Use this when you want to explicitly pass the image name
    init(withImage imageName: String) {
        let image = UIImage(named: imageName)
        super.init(image: image)
    }
    
    // Required initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
