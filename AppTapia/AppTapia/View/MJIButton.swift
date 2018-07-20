//
//  MJIButton.swift
//  tpconcept
//
//  Created by octto on 2017/11/28.
//  Copyright © 2017 mji. All rights reserved.
//

import UIKit

class MJIButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var highLightColor:UIColor = UIColor.blue
    @IBInspectable var baseColor:UIColor = UIColor.blue {
        didSet {
            backgroundColor = baseColor
        }
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        #if TARGET_INTERFACE_BUILDER
            setup()
        #endif
        
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highLightColor : baseColor
        }
    }
    
    private func setup() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }

}
