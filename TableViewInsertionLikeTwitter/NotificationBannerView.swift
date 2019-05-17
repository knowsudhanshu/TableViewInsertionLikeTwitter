//
//  NotificationBannerView.swift
//  Gather
//
//  Created by Sudhanshu Sudhanshu on 04/01/19.
//  Copyright © 2019 Tilicho Labs. All rights reserved.
//

import UIKit
import AudioToolbox

let NOTIFICATION_BANNER_HEIGHT: CGFloat = 60
let NOTIFICATION_IMAGE_HEIGHT: CGFloat = 40
class NotificationBannerView: UIView, DropEffect {
    
    var tapAction: (() -> ())?

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = 2
        label.text = "See more"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    
    private func setupSubviews() {
        
        // contentView Constraints
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            contentView.heightAnchor.constraint(equalToConstant: NOTIFICATION_BANNER_HEIGHT),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
        
        contentView.addSubview(textLabel)
        textLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    var dismissAutomatically: Bool = false
    convenience init(autoDismiss: Bool = false) {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + NOTIFICATION_BANNER_HEIGHT)
        self.init(frame: frame)
        
        self.backgroundColor = .clear //UIColor.black.withAlphaComponent(0.5)

        dismissAutomatically = autoDismiss

        setupSubviews()
        setupGestureRecongnizers()
    }
    
    fileprivate func setupGestureRecongnizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func tapGestureHandler(sender: UITapGestureRecognizer) {
        tapAction?()
        self.dropHide()
    }
    
    var panningStartPoint: CGPoint = .zero
    @objc
    private func panGestureHandler(sender: UITapGestureRecognizer) {
        // TODO: Pan hide
        let point = sender.location(in: self)
        
        switch sender.state {
        case .began:
            panningStartPoint = point
        case .ended:
            print("\(self): ended")
            if panningStartPoint.y - point.y >= 40 {
                self.dropHide()
            }
        default: break
            
        }
        
        
        if sender.state == .ended || sender.state == .cancelled {
            print("\(self): panGestureHandler")
            self.dropHide()
        }
    }
    
    func show() {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        self.dropShow()
        
        if dismissAutomatically {
            scheduleAutoHide()
        }
    }
    
    private func scheduleAutoHide() {
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
    @objc
    func hide() {
        DispatchQueue.main.async {
            self.dropHide()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol DropEffect {}

extension DropEffect where Self: UIView {
    func dropShow() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        for view in window.subviews {
            if let bannerView = view as? NotificationBannerView {
                bannerView.removeFromSuperview()
                window.windowLevel = UIWindow.Level.statusBar - 1
            }
        }
        
        window.addSubview(self)
        window.windowLevel = UIWindow.Level.statusBar+1

        self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func dropHide() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        }, completion: { _ in
            self.removeFromSuperview()
            
            guard let window = UIApplication.shared.keyWindow else { return }
            window.windowLevel = UIWindow.Level.statusBar - 1
        })
    }
}

