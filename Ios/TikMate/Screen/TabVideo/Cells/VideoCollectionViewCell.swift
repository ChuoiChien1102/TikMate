//
//  VideoCollectionViewCell.swift
//  TikMate
//
//  Created by ChuoiChien on 12/19/20.
//

import UIKit
import Kingfisher
import MarqueeLabel

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var labelDesc: MarqueeLabel!
    @IBOutlet weak var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelDesc.animationDelay = 0
        labelDesc.speed = .rate(50)
    }
        
    func configCell(video: VideoModel) -> Void {
        imgCover.kf.setImage(with: URL(string: video.coverImage))
        labelDesc.text = video.desc
    }
}
