//
//  ViewController.swift
//  Drona
//
//  Created by Adhithyan Vijayakumar on 22/07/18.
//  Copyright © 2018 Adhithyan Vijayakumar. All rights reserved.
//

import UIKit
import FeedKit
import MBProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
                let item = feed.items?.first
                print(item?.title)
                print(item?.link)
                print(item?.description)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
        }
    }
    

}

