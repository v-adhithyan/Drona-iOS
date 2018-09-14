//
//  FeedViewController.swift
//  Drona
//
//  Created by Adhithyan Vijayakumar on 13/09/18.
//  Copyright © 2018 Adhithyan Vijayakumar. All rights reserved.
//

import UIKit
import MBProgressHUD
import FeedKit

class FeedViewController: UIViewController {
    
    var category: String = ""
    
    
    var items = Array<RSSFeedItem>()
    var index = 0
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexcodeToUIColor(hex: "#E53935")
        
        parseFeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func parseFeed() {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        let feedURL = URL(string: "https://jrvarma.wordpress.com/feed")!
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            DispatchQueue.main.async {
                guard let feed = result.rssFeed, result.isSuccess else {
                    print(result.error ?? "")
                    return
                }
                self.items = feed.items!
                let item = feed.items?.first
                self.titleTextView.text = item?.title as! String
                self.dateTextView.text = item?.pubDate as! String
                self.contentTextView.text = item?.description as! String
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
        }
    }
    
    @IBAction func nextStory(_ sender: Any) {
        index = index + 1
        let item = self.items[index % self.items.count]
        self.titleTextView.text = item.title as! String
        self.dateTextView.text = item.pubDate as! String
        self.contentTextView.text = item.description as! String
    }
    
    @IBAction func openCurrentStoryInBrowser(_ sender: Any) {
        let url = NSURL(string: self.items[index % self.items.count].link!)
        UIApplication.shared.openURL(url! as URL)
    }
    
    
}
