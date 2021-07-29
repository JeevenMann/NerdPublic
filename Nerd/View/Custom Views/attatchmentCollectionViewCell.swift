//
//  attatchmentCollectionViewCell.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

protocol AttatchmentProtocol: NSObject {
    func removeAttatchment(_ rowLocation: Int)
    func viewAttatchment(_ attatchment: Attatchment)
}

class attatchmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var fileImage: UIButton!

    weak var delegate: AttatchmentProtocol?
    var attatchment: Attatchment?
    var rowLocation: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

    func setProprties(_ attatchment: Attatchment, _ location: Int, allowDelete: Bool) {
        if !allowDelete {
            deleteButton.isHidden = true
            deleteButton.isEnabled = false
            fileImage.translatesAutoresizingMaskIntoConstraints = false
            fileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            self.layoutSubviews()
        }

        self.attatchment = attatchment
        self.fileImage.setImage(attatchment.image, for: .normal)
        self.fileImage.imageView?.contentMode = .scaleAspectFill
        self.rowLocation = location
    }

    @IBAction func deleteButton(_ sender: Any) {
        self.delegate?.removeAttatchment(self.rowLocation!)
    }

    @IBAction func viewFile(_ sender: Any) {
        print("here")
        self.delegate?.viewAttatchment(attatchment!)
    }
}
