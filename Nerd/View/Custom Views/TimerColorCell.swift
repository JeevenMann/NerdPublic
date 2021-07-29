//
//  TimerColorCell.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-20.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

protocol SelectColor: AnyObject {
    func openPicker(view: UIColorPickerViewController)
}

class TimerColorCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: SelectColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSelector))
        self.colorView.addGestureRecognizer(tapGesture)
        self.colorView.layer.cornerRadius = 7
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setValues(title: String, color: UIColor) {
        self.titleLabel.text = title
        self.colorView.backgroundColor = color
    }

   @objc func openSelector() {
    let pickerVC = UIColorPickerViewController()
    pickerVC.delegate = self
    delegate?.openPicker(view: pickerVC)
   }

    func getColor() -> UIColor? {
        return colorView.backgroundColor
    }
}
extension TimerColorCell: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorView.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.colorView.backgroundColor = viewController.selectedColor
    }
}
