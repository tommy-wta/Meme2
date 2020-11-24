//
//  MemeDetailViewController.swift
//  Meme2
//
//  Created by Tommy Lam on 11/24/20.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var passoverMeme: Meme?

    @IBOutlet weak var memeDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeDetailImage.image =  passoverMeme?.memeImage
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
