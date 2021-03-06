//
//  TimeLineCell.swift
//  TwitterClient
//
//  Created by Truong Tran on 6/30/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import AFNetworking



protocol TimeLineCellDelegate {
  func onFavoritedClick(cell: TimeLineCell, isFavorited: Bool)
  func onRetweetClick(cell: TimeLineCell, isRetweet: Bool)
  func onReplyClick(cell: TimeLineCell, timeLine: TimeLine)
}

class TimeLineCell: UITableViewCell, FaveButtonDelegate {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tagNameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var imageRetweeted: UIImageView!
  @IBOutlet weak var nameRetweetedLabel: UILabel!
  @IBOutlet weak var avataImage: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var numberReplyLabel: UILabel!
  @IBOutlet weak var numberRetweetedLabel: UILabel!
  @IBOutlet weak var numberLikeLabel: UILabel!
  
  @IBOutlet weak var likeButton: FaveButton!
  @IBOutlet weak var retweetedButton: FaveButton!
  
  @IBOutlet weak var countTest: UILabel!
  @IBOutlet weak var mediaPhotoImageView: UIImageView!

  @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
  var delegate: TimeLineCellDelegate!
  var isFavorited = false
  var isRetweet = false
  
  
  var timeLine: TimeLine! {
    didSet {
      nameLabel.text = timeLine.user!.name
      tagNameLabel.text = "@" + timeLine.user!.screenName!
      statusLabel.text = timeLine.text
      avataImage.setImageWith(timeLine.user!.profileImageUrl!)
      timeLabel.text = timeLine.timeSinceCreated!
      numberRetweetedLabel.text = "\(timeLine.retweetCount)"
      numberLikeLabel.text = "\(timeLine.favCount)"
      
      isFavorited = timeLine.favorited
      isRetweet = timeLine.retweeted
      likeButton.setSelected(selected: isFavorited, animated: false)
      retweetedButton.setSelected(selected: isRetweet, animated: false)
      
      
      
     // avataImage.layer.borderWidth = 1
      avataImage.layer.masksToBounds = false
      //avataImage.layer.borderColor = UIColor.blackColor().CGColor
      avataImage.layer.cornerRadius = avataImage.frame.height/2
      avataImage.clipsToBounds = true
      
      
      if let userRetweet = timeLine.UserRetweet  {
        nameRetweetedLabel.text = userRetweet.name! + " retweeted"
        imageRetweeted.isHidden = false
        nameRetweetedLabel.isHidden = false

      }else {
        imageRetweeted.isHidden = true
        nameRetweetedLabel.isHidden = true
      }
      
      
      
      
      if let photo = timeLine.photos?.first{
        self.mediaHeightConstraint.constant = self.mediaPhotoImageView.frame.size.width * photo.size.height / photo.size.width
        self.mediaPhotoImageView.setImageWith(photo.photoURL)
      }else{
        self.mediaHeightConstraint.constant = 0
      }
 
    }
    
  }


  
  override func awakeFromNib() {
    likeButton.delegate = self
    retweetedButton.delegate = self
    
  }
  
  @IBAction func onReplyClick(_ sender: UIButton) {
    delegate.onReplyClick(cell: self, timeLine: timeLine)
  }

  func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    if faveButton == likeButton {
      isFavorited = !isFavorited
      delegate.onFavoritedClick(cell: self, isFavorited: isFavorited)
     // print("like button click")
    } else if faveButton == retweetedButton{
      isRetweet = !isRetweet
      delegate.onRetweetClick(cell: self, isRetweet: isRetweet)
     // print("retweet button click")
    }
  
  }
  
//  func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
//    return colors
//  }
  

}



