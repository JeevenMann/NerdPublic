//
//  logoAnimationView.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-06-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import Foundation
class logoAnimationView: UIView {
    var colorArray: [UIColor] = [.red, .yellow, .green, .purple]
    @IBOutlet var letterLabels: [UILabel]!
    var doAnimation = true

    func letterAnimation(index: Int = 0) {

        if doAnimation {

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { [self] in
                letterLabels[index].transform = .init(rotationAngle: CGFloat.pi / 4)
                letterLabels[index].textColor = self.colorArray[index]
            }, completion: {_ in 
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: { [self] in
                    letterLabels[index].transform = .identity
                    letterLabels[index].textColor = .white
                }, completion: { [self] _ in
                    let newIndex = index + 1
                    if newIndex < letterLabels.count {
                    self.letterAnimation(index: newIndex)
                    } else {
                        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: {(_) in

                            self.letterAnimation()
                        })
                    }
                })
            })
        }
    }

    func startAnimation() {
        self.doAnimation = true
        self.letterAnimation()
    }

    func endAnimation() {
        self.doAnimation = false
    }
}
