//
//  CollectionViewCell.swift
//  TestPAger
//
//  Created by MacOS on 07/09/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func configureCell(name:String){
        imageView.image = UIImage(named: name)
    }

    
}
