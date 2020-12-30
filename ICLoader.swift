////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 - 2020, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import UIKit
import NanoFrame

public class ICLoader: UIView {

    public static var logoImageName: String? = nil
    public static var labelFontName: String? = nil

    private(set) var backgroundView: UIView!
    private(set) var logoView: UIImageView!
    private(set) var centerDot: UIView!
    private(set) var leftDot: UIView!
    private(set) var rightDot: UIView!
    private(set) var label: UILabel!

    public class func present() {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            let controller = UIApplication.shared.keyWindow?.rootViewController
            var visibleController: UIViewController?

            if controller is UINavigationController {
                visibleController = (controller as? UINavigationController)?.visibleViewController
            } else {
                visibleController = controller
            }

            let loader = ICLoader(withImageName: logoImageName!)
            DispatchQueue.main.async(execute: {
                visibleController?.view.addSubview(loader)
                visibleController?.view.bringSubviewToFront(loader)
                visibleController?.view.isUserInteractionEnabled = false

                UIView.transition(with: loader, duration: 0.33, options: [], animations: {
                    loader.frame = visibleController!.view.bounds
                })
            })
        }
    }

    public class func dismiss() {
        let controller = UIApplication.shared.keyWindow?.rootViewController
        var visibleController: UIViewController?

        if controller is UINavigationController {
            visibleController = (controller as? UINavigationController)?.visibleViewController
        } else {
            visibleController = controller
        }

        DispatchQueue.main.async(execute: {
            for loader in ICLoader.loaders(for: visibleController?.view) {
                loader.layer.removeAllAnimations()
                UIView.transition(with: loader, duration: 0.25, options: [.transitionFlipFromTop], animations: {
                    loader.alpha = 0.0
                }) { finished in
                    loader.removeFromSuperview()
                    visibleController?.view.isUserInteractionEnabled = true
                }
            }
        })
    }

    public class func loaders(for view: UIView?) -> [ICLoader] {
        var theHUDs: [ICLoader] = []
        for candidate in view?.subviews ?? [] {
            if candidate is ICLoader {
                theHUDs.append(candidate as! ICLoader)
            }
        }
        return theHUDs
    }

    public class func setImageName(_ imageName: String?) {
        logoImageName = imageName
    }

    public class func setLabelFontName(_ fontName: String?) {
        labelFontName = fontName
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Initializers
    //-------------------------------------------------------------------------------------------

    public init(withImageName imageName: String) {
        if (imageName.count) == 0 {
            fatalError("ICLoader requires a logo image. Set with [ICLoader setImageName:anImageName]")
        }

        super.init(frame: CGRect.zero)
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        backgroundView.backgroundColor = UIColor(hex: 0x666677, alpha: 0.8)
        backgroundView.layer.cornerRadius = 45
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)

        initLogo(imageName)
        initDots()
        initLabel()
        animate(toDot: rightDot)
    }

    public required init?(coder: NSCoder) {
        fatalError("init with coder is not supported")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.centerInSuperView()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------

    private func initLogo(_ logoImageName: String) {
        if let image = UIImage(named: logoImageName) {
            logoView = UIImageView(image: image)
            logoView.size = image.size
            logoView.center(in: CGRect(x: 0, y: 7, width: 90, height: 45))

            logoView.contentMode = .scaleAspectFit
            backgroundView.addSubview(logoView)
        }
    }

    private func initDots() {

        let dodWidth: CGFloat = 5
        let centerX = (backgroundView.frame.size.width - dodWidth) / 2
        let dotY = ((backgroundView.frame.size.height - dodWidth) / 2) + 9

        centerDot = UIView(frame: CGRect(x: centerX, y: dotY, width: dodWidth, height: dodWidth))
        centerDot.backgroundColor = UIColor.white
        centerDot.layer.cornerRadius = centerDot.width / 2
        centerDot.layer.opacity = 1.0
        backgroundView.addSubview(centerDot)

        leftDot = UIView(frame: CGRect(x: centerX - 11, y: dotY, width: dodWidth, height: dodWidth))
        leftDot.backgroundColor = UIColor.white
        leftDot.layer.cornerRadius = leftDot.width / 2
        leftDot.layer.opacity = 0.5
        backgroundView.addSubview(leftDot)

        rightDot = UIView(frame: CGRect(x: centerX + 11, y: dotY, width: dodWidth, height: dodWidth))
        rightDot.backgroundColor = UIColor.white
        rightDot.layer.cornerRadius = rightDot.width / 2
        rightDot.layer.opacity = 0.5
        backgroundView.addSubview(rightDot)
    }

    private func initLabel() {
        label = UILabel(frame: CGRect(x: 2 + (backgroundView.frame.size.width - 65) / 2, y: 60, width: 65, height: 14))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = ICLoader.labelFontName != nil ? UIFont(name: ICLoader.labelFontName!, size: 10) :
                UIFont.systemFont(ofSize: 10)
        label.text = "Loading..."
        backgroundView.addSubview(label)
    }

    private func animate(toDot dot: UIView?) {
        weak var weakSelf = self
        weak var centerDot = self.centerDot
        weak var leftDot = self.leftDot
        weak var rightDot = self.rightDot

        if let weakSelf = weakSelf {
            UIView.transition(with: weakSelf, duration: 0.4, options: .curveEaseInOut, animations: {
                centerDot?.layer.opacity = dot == centerDot ? 1.0 : 0.5
                rightDot?.layer.opacity = dot == rightDot ? 1.0 : 0.5
                leftDot?.layer.opacity = dot == leftDot ? 1.0 : 0.5
            }) { complete in
                if dot == centerDot {
                    weakSelf.animate(toDot: rightDot)
                } else if dot == rightDot {
                    weakSelf.animate(toDot: leftDot)
                } else {
                    weakSelf.animate(toDot: centerDot)
                }
            }
        }
    }
}