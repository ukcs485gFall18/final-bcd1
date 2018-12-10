//
//  SAButton.swift
//  Beginner-Constraints
//
//  Created by Sean Allen on 11/29/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//
// Reference: https://www.youtube.com/watch?v=m_0_XQEfrGQ
// Reference: https://www.dropbox.com/sh/k00cpu97r9y5hqg/AAA__sDavfP_Tm4y2U4e2fjfa/Beginner-Constraints/CustomViews?dl=0&preview=SAButton.swift&subfolder_nav_tracking=1
//
//  Added by David Mercado on 12/9/18.

import UIKit

class SAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        backgroundColor     = Colors.tropicBlue
        titleLabel?.font    = UIFont(name: Fonts.avenirNextCondensedDemiBold, size: 22)
        layer.cornerRadius  = frame.size.height/2
        setTitleColor(.white, for: .normal)
    }
}
