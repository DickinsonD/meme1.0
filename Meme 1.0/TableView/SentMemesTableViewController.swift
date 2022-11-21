//
//  SentMemesTableViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 11/18/22.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    
    @IBOutlet var memeTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memeTableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath)
        let row = memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = row.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
    
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    
    
    
}
