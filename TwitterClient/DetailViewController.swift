//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Truong Tran on 7/1/17.
//  Copyright © 2017 Truong Tran. All rights reserved.
//

import UIKit
import AFNetworking

protocol DetailViewControllerDelegate {
  func detailViewController(viewController: DetailViewController, timeLine: TimeLine, ip: Int)
}

class DetailViewController: UIViewController, FaveButtonDelegate {
  
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
  
  var ip: Int!
		
  
  
  var isFavorited = false
  var isRetweet = false
  
  var delegate: DetailViewControllerDelegate!
		
  
  var timeLine: TimeLine!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      likeButton.delegate = self
      retweetedButton.delegate = self
      
      
      // set navibar color
      navigationController!.navigationBar.barTintColor = UIColor.white

      nameLabel.text = timeLine.user!.name
      tagNameLabel.text = "@" + timeLine.user!.screenName!
      statusLabel.text = timeLine.text
      avataImage.setImageWith(timeLine.user!.profileImageUrl!)
      timeLabel.text = "\(timeLine.createdAt!)"
      numberRetweetedLabel.text = "\(timeLine.retweetCount)"
      numberLikeLabel.text = "\(timeLine.favCount)"
      
      isFavorited = timeLine.favorited
      isRetweet = timeLine.retweeted
      
      print("****isFavorited: \(isFavorited)")
      print("****isRetweet: \(isRetweet)")
//      likeButton.isSelected = timeLine.favorited
//      retweetedButton.isSelected = timeLine.retweeted
      
      likeButton.setSelected(selected: isFavorited, animated: false)
      retweetedButton.setSelected(selected: isRetweet, animated: false)
      
      if let userRetweet = timeLine.UserRetweet  {
        nameRetweetedLabel.text = userRetweet.name! + "retweeted"
        imageRetweeted.isHidden = false
        nameRetweetedLabel.isHidden = false
        
      }else {
        imageRetweeted.isHidden = true
        nameRetweetedLabel.isHidden = true
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    if faveButton == likeButton {
      isFavorited = !isFavorited
      if !isFavorited {
        TwitterAPI.sharedInstance?.unFavoriteStatus(id: timeLine.idStr) {
          (timeLine, error) in
          if error == nil {
            print("***unfavoried success")
            
            self.delegate.detailViewController(viewController: self, timeLine: timeLine!, ip: self.ip)
            
            self.numberLikeLabel.text = "\(timeLine!.favCount)"
            self.numberRetweetedLabel.text = "\(timeLine!.retweetCount)"
          } else {
            print("have error when unfavoried \(error!)")
          }
        }
      } else {
        TwitterAPI.sharedInstance?.favoriteStatus(id: timeLine.idStr) {
          (timeLine, error) in
          if error == nil {
            print("***favorite success")
            
            self.delegate.detailViewController(viewController: self, timeLine: timeLine!, ip: self.ip)
            
            self.numberLikeLabel.text = "\(timeLine!.favCount)"
            self.numberRetweetedLabel.text = "\(timeLine!.retweetCount)"
           
            //self.timeLines[ip!].favorited = isFavorited
          } else {
            print("have error when favorited \(error!)")
            
          }
        }
      }
      
      
      //delegate.onFavoritedClick(cell: self, isFavorited: isFavorited)
     // print("like button click")
    } else if faveButton == retweetedButton{
      isRetweet = !isRetweet
      // if Retweet button is select then unRetweet else Retweet
      if !isRetweet {
        TwitterAPI.sharedInstance?.unRetweetStatus(id: timeLine.idStr) {
          (timeLine, error) in
          if error == nil {
            print("***unRetweet success")
            
            self.delegate.detailViewController(viewController: self, timeLine: timeLine!, ip: self.ip)
            
           // print("&&&&&&&\(timeLine?.retweeted)")
            
            self.numberLikeLabel.text = "\(timeLine!.favCount)"
           self.numberRetweetedLabel.text = "\(timeLine!.retweetCount)"
            //self.timeLines[ip!].retweeted = isRetweet
          } else {
            print("have error when unRetweet \(error!)")
            
          }
        }
      } else {
        TwitterAPI.sharedInstance?.retweetStatus(id: timeLine.idStr) {
          (timeLine, error) in
          if error == nil {
            print("***retweet success")
            
            self.delegate.detailViewController(viewController: self, timeLine: timeLine!, ip: self.ip)
           // print("&&&&&&&\(timeLine?.retweeted)")
            
            self.numberLikeLabel.text = "\(timeLine!.favCount)"
            self.numberRetweetedLabel.text = "\(timeLine!.retweetCount)"
            //self.timeLines[ip!].retweeted = isRetweet
          } else {
            print("have error when retweet \(error!)")
            
          }
        }
      }
      
      //delegate.onRetweetClick(cell: self, isRetweet: isRetweet)
     // print("retweet button click")
    }
    
  }
    

  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ReplyViewController
      
      controller.timeLine = timeLine
  }
  

}
