//
//  PhotoCell.swift
//  piexl-city
//
//  Created by Faisal Babkoor on 8/24/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
       let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .redraw
        return im
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    func layout(){
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true


    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
