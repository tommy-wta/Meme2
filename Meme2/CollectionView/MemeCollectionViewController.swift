//
//  MemeCollectionViewController.swift
//  Meme2
//
//  Created by Tommy Lam on 11/23/20.
//
import UIKit

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let dimensionw = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionh = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionw, height: dimensionh)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemeCollection), name: .memeSaved, object: nil)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]

        cell.collectionCellImage.image = meme.memeImage
        // Configure the cell
        return cell
    }

    // Segue Logic
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "collectionDetail", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionDetail" {
            let targetController = segue.destination as! MemeDetailViewController
            let indexPath = sender as! IndexPath
            targetController.passoverMeme = memes[indexPath.row]
        }
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

    @objc func reloadMemeCollection() {
        self.collectionView.reloadData()
    }
}
