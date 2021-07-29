//
//  UITextView Extension.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-16.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

    func zeroPadding() {
        self.textContainer.lineFragmentPadding =  .zero
        self.contentInset = UIEdgeInsets.zero
    }
}
