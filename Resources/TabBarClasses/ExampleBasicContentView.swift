//
//  ExampleBasicContentView.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2018年 Egg Swift. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ExampleBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(named: "Accent1") ?? .white
        iconColor = UIColor(named: "Accent1") ?? .white

        if traitCollection.userInterfaceStyle == .dark {
            highlightTextColor =  .white
            highlightIconColor = .white
        } else {
            highlightTextColor = .gray
            highlightIconColor = .gray
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
