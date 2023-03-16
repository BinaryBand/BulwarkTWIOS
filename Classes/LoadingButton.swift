//
//  LoadingButton.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/3/23.
//

import Foundation
@IBDesignable class LoadingUIButton: UIButton {

    //@IBInspectable var indicatorColor : UIColor = self.

    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    var origionalImage: UIImage?
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        origionalImage = self.image(for: .normal)
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        DispatchQueue.main.async(execute: {
            self.setTitle(self.originalButtonText, for: .normal)
            self.setImage(self.origionalImage, for: .normal)
            self.activityIndicator.stopAnimating()
        })
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleLabel?.textColor
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
