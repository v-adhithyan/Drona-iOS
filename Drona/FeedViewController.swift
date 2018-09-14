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
import ReadabilityKit
import Kingfisher

class FeedViewController: UIViewController {
    
    var category: String = ""
    
    
    var items = Array<RSSFeedItem>()
    var index = -1
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateTextView: UITextView!
    
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexcodeToUIColor(hex: "#E53935")
        
        titleTextView.font = UIFont.proximaNovaBold(size: 28)
        dateTextView.font = UIFont.proximaNovaRegular(size: 14)
        contentTextView.font = UIFont.proximaNovaRegular(size: 20)
        parseFeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func parseFeed() {
        showProgressBar()
        let feedURL = URL(string: "https://www.engadget.com/rss.xml")!
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            DispatchQueue.main.async {
                guard let feed = result.rssFeed, result.isSuccess else {
                    print(result.error ?? "")
                    return
                }
                self.items = feed.items!
                self.index = 0
                self.parseArticle()
            }
            
        }
    }
    
    @IBAction func nextStory(_ sender: Any) {
        showProgressBar()
        index = index + 1
        parseArticle()
    }
    
    @IBAction func openCurrentStoryInBrowser(_ sender: Any) {
        let url = NSURL(string: self.items[index % self.items.count].link!)
        UIApplication.shared.openURL(url! as URL)
    }
    
    func parseArticle() {
        let item = self.items[index % self.items.count]
        let date = item.pubDate
        let link = item.link
        let articleUrl = URL(string: link!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.titleTextView.text = data?.title
            self.dateTextView.text = date?.description
            self.contentTextView.text = data?.description
            let imageUrl = data?.topImage
            let url = URL(string: imageUrl!)
            self.imageView.kf.setImage(with: url)
            self.hideProgressBar()
        })
    }
    
    func showProgressBar() {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    func hideProgressBar() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
}
