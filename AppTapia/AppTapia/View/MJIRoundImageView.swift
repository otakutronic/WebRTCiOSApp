//
//  MJIRoundImageView.swift
//  AppTapia
//
//  Created by octto on 2017/10/05.
//  Copyright © 2017 com.mji.tapia. All rights reserved.
//

import UIKit

@IBDesignable class MJIRoundImageView: UIImageView {

    @IBInspectable var borderWidth:CGFloat = 2 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.darkGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
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
    
    func setup() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
