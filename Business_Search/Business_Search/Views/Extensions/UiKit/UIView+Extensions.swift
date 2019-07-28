//
//  File.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero,
                centerX: Bool = false, centerY: Bool = false,
                x: NSLayoutDimension? = nil, xMultiply: CGFloat = CGFloat.zero,
                y: NSLayoutDimension? = nil, yMultiply: CGFloat = CGFloat.zero ){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true}
        if let bottom = bottom {bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true}
        if let leading = leading {leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true}
        if let trailing = trailing {trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true}
        if size.height != 0 {heightAnchor.constraint(equalToConstant: size.height).isActive = true}
        if size.width != 0 {widthAnchor.constraint(equalToConstant: size.width).isActive = true}
        if let parent = superview, centerX {centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true}
        if let parent = superview, centerY {centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true}
        if let x = x, xMultiply != CGFloat.zero {widthAnchor.constraint(equalTo: x, multiplier: xMultiply).isActive = true}
        if let y = y, yMultiply != CGFloat.zero {heightAnchor.constraint(equalTo: y, multiplier: yMultiply).isActive = true}
    }
    
    func anchorSize(to view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func fillSafeSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor)
    }
    
    
    func fillSuperview(){
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor)
    }
    
    func centerToSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        guard let centerX = superview?.centerXAnchor, let centerY = superview?.centerYAnchor else {return}
        centerXAnchor.constraint(equalTo: centerX).isActive = true
        centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
}
