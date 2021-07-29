//
//  categoryCell.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-07-14.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class categoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    var categoryName: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20
    }
    
    func setSelected() {
        self.backgroundColor = UIColor(named: "Accent1")
        self.categoryImage.tintColor = .red
        self.categoryLabel.textColor = UIColor(named: "LightAccent")
        self.categoryImage.image = UIImage(named: "\(categoryName)Light")
    }
    
    func setUnselected() {
        self.backgroundColor = UIColor(named: "LightAccent")
        self.categoryLabel.textColor = UIColor(named: "Accent1")
        self.categoryImage.image = UIImage(named: categoryName)
    }
    
    func setInfo(name: String) {
        
        self.categoryLabel.text = name
        self.categoryName = name
        self.categoryImage.image = UIImage(named: name)
    }
}
