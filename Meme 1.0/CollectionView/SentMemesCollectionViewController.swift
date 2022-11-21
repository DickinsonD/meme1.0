//
//  SentMemesCollectionViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 11/18/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

       // let space:CGFloat = 3.0
       // let dimension = (view.frame.size.width - (2 * space)) / 3.0

       // flowLayout.minimumInteritemSpacing = space
       // flowLayout.minimumLineSpacing = space
       // flowLayout.itemSize = CGSize(width: dimension, height: dimension)
       

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    
    
    // MARK: UICollectionViewDataSource

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    
   
    
    

}
