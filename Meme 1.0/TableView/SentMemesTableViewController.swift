//
//  SentMemesTableViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 11/18/22.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    
    @IBOutlet var memeTableView: UITableView!
    
    //AppDelegate shared model
    var memes: [Meme] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return all sent memes
        return memes.count
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memeTableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath)
        let row = memes[(indexPath as NSIndexPath).row]
        //allows memedImage and top/bottom text display in prototype cell
        cell.imageView?.image = row.memedImage
        cell.textLabel!.text = row.topText + "..." + row.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
    
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    // swipe to detete row action
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.memes.remove(at: indexPath.row)
        }
            
    }
    
    
    
}
