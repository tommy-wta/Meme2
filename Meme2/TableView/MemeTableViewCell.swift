//
//  MemeTableViewCell.swift
//  Meme2
//
//  Created by Tommy Lam on 11/23/20.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var tableCellTopLabel: UILabel!
    @IBOutlet weak var tableCellBottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
