//
//  categoryView.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-07-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class categoryView: UIView {

 var categoryImage: UIImageView!
 var categoryLabel: UILabel!
    
    var categoryName: String?
    
     init(frame: CGRect, categoryName: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "LightAccent")
        self.categoryImage = UIImageView(image: UIImage(named: categoryName))
        self.categoryLabel = UILabel()
        
        categoryLabel.text = categoryName
        categoryLabel.textColor = UIColor(named: "Accent1")
        categoryLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 15)
        self.addSubview(categoryImage)
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        categoryImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        categoryImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        categoryImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        self.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant: 10).isActive = true
        categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.roundCorners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setInfo(name: String) {
        self.backgroundColor = UIColor(named: "LightAccent")
        self.categoryImage = UIImageView(image: UIImage(named: name))
        self.categoryLabel = UILabel()
        
        categoryLabel.text = name
        categoryLabel.textColor = UIColor(named: "Accent1")
        categoryLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 15)
        self.addSubview(categoryImage)
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        categoryImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        categoryImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        categoryImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        self.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant: 10).isActive = true
        categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.roundCorners()
    }
}
