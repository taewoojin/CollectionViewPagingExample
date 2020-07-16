//
//  CollectionViewCell.swift
//  CollectionViewPagingExample
//
//  Created by 진용호 on 2018. 7. 20..
//  Copyright © 2018년 진용호. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
    }
}
