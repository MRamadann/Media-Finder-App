//
//  MediaCell.swift
//  Media
//
//  Created by Apple on 06/01/2023.
//

import SDWebImage
import MarqueeLabel

class MediaCell: UITableViewCell {

    @IBOutlet weak var DetailsLabel: UILabel!
    @IBOutlet weak var MediaImage: UIImageView!
    @IBOutlet weak var MediaNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configrationCell(type: MediaType, media: Media){
        MediaImage.sd_setImage(with: URL(string: media.artworkUrl! ), placeholderImage: UIImage(named: "1"))
        MediaNameLabel.text = media.artistName
        DetailsLabel.text = media.longDescription
    }
}
