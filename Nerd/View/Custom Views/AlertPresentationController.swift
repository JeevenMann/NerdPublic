//
//  AlertPresentationController.swift
//  Nerd
//
//  Created by Navjeeven Mann on 2021-06-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
class AlertPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
               size: CGSize(width: self.containerView!.frame.width, height: 260))
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        containerView?.frame = CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
                                         size: CGSize(width: self.containerView!.frame.width, height: 260))
        presentedView!.roundTopCorner()
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                self.presentedView?.frame = CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
                                                   size: CGSize(width: self.containerView!.frame.width, height: 300))
            })

            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.35, animations: {
                self.presentedView?.frame = CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
                                                   size: CGSize(width: self.containerView!.frame.width, height: 330))
            })

            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.45, animations: {
                self.presentedView?.frame = CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
                                                   size: CGSize(width: self.containerView!.frame.width, height: 300))
            })

            UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.6, animations: {
                self.presentedView?.frame = CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 260),
                                                   size: CGSize(width: self.containerView!.frame.width, height: 260))
            })
        }, completion: nil)
    }
}
