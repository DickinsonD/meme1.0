//
//  DetailViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 11/21/22.
//

import Foundation
import UIKit


class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailViewImage: UIImageView!
    
    var memes: Meme!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailViewImage.image = memes.memedImage
    }
    
   
    
    
    
}
