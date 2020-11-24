//
//  MemeTableViewController.swift
//  Meme2
//
//  Created by Tommy Lam on 11/23/20.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var memeTable: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //make Sure the tab bar is present and navigation bar are present
        memeTable.reloadData()
        print("size of memes array post reload is : \(memes.count)")

    }

    // Segue Logic
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tableDetail", sender: indexPath)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableDetail" {
            let targetController = segue.destination as! MemeDetailViewController
            let indexPath = sender as! IndexPath
            targetController.passoverMeme = memes[indexPath.row]
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCells", for: indexPath) as! MemeTableViewCell

        let meme = memes[indexPath.row]
        cell.tableCellImage.image = meme.memeImage
        cell.tableCellTopLabel?.text = meme.topText
        cell.tableCellBottomLabel?.text = meme.bottomText

        print(cell.tableCellTopLabel?.text)
        print(cell.tableCellBottomLabel?.text)

        return cell
    }

    func presentMemeEditor(existingMeme: Meme? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "MemeEditor") as! UINavigationController
        if let memeEditorViewController = navController.viewControllers.first as? MemeEditorViewController,
            let meme = existingMeme {
            memeEditorViewController.preloadMeme = meme
        }

        present(navController, animated: true, completion: nil)
    }

    @IBAction func navigateToMemeEditor(_ sender: Any) {
        presentMemeEditor()
    }

}
