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
import Toast_Swift

class FeedViewController: UIViewController {
    
    var category: String = ""
    
    
    var items = Array<RSSFeedItem>()
    var index = -1
    var categoryLinksMap = [String: [String]]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dateTextView: UITextView!
    
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    
    let network = NetworkManager.sharedInstance
    var deadline = DispatchTime.now() + .seconds(10)
    var feedPopulated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextView.font = UIFont.proximaNovaBold(size: 28)
        dateTextView.font = UIFont.proximaNovaRegular(size: 14)
        contentTextView.font = UIFont.proximaNovaRegular(size: 20)
        addItemsToCategoriesMap()
        
        checkIfFeedIsPopulated()
        self.parseFeed(urls: (self.categoryLinksMap[self.category.lowercased()])!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func parseFeed(urls: [String]) {
        showProgressBar()
        for url in urls {
            let feedURL = URL(string: url)
            let parser = FeedParser(URL: feedURL!)
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                DispatchQueue.main.async {
                    guard let feed = result.rssFeed, result.isSuccess else {
                        print(result.error ?? "")
                        return
                    }
                    self.items.append(contentsOf: feed.items!)
                    if(self.index == -1) {
                        self.index = 0
                        self.parseArticle()
                    }
                }
                
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
    
    
    @IBAction func shareLink(_ sender: Any) {
        let text = "Shared via Drona app. Get it on App store."
        let url = NSURL(string: self.items[index % self.items.count].link!)! as URL
        let activity = UIActivityViewController(activityItems: [url, text], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
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
            if imageUrl != nil {
                let url = URL(string: imageUrl!)
                self.imageView.kf.setImage(with: url)
            }
            self.hideProgressBar()
        })
    }
    
    func showProgressBar() {
        self.feedPopulated = false
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    func hideProgressBar() {
        self.feedPopulated = true
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func addItemsToCategoriesMap() {
        categoryLinksMap["marketing"] = ["http://www.adweek.com/feed", "http://feeds2.feedburner.com/ducttapemarketing/nRUD", "http://rss.marketingprofs.com/marketingprofs"]
        categoryLinksMap["finance"] = ["http://www.thehindubusinessline.com/markets/stock-markets/?service=rss", "https://faculty.iima.ac.in/~jrvarma/blog/index.cgi/index.rss", "http://rss.nytimes.com/services/xml/rss/nyt/Business.xml"]
        categoryLinksMap["economics"] = ["http://feeds2.feedburner.com/EconomistsView", "http://feeds2.feedburner.com/Themoneyillusion"]
        categoryLinksMap["others"] = ["https://www.engadget.com/rss.xml"]
    }
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfFeedIsPopulated() {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if(!self.feedPopulated) {
                self.hideProgressBar()
                self.view.makeToast("Internet is unavailable. Please try again later.")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.deadline = DispatchTime.now() + .seconds(10)
                self.checkIfFeedIsPopulated()
            }
        }
    }
}
