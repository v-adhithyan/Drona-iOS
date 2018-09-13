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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    let categories = ["Marketing", "Finance", "Economics", "Others"]
    let categoryImages = [UIImage(named: "marketing_menu"), UIImage(named: "finance_menu"), UIImage(named: "economics_menu"), UIImage(named: "others_menu")]
    let categoryColors = [UIColor.hexcodeToUIColor(hex: "#885f7f"), UIColor.hexcodeToUIColor(hex: "#d0c490"), UIColor.hexcodeToUIColor(hex: "#13b0a5"), UIColor.hexcodeToUIColor(hex: "#FFA500")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //UIApplication.shared.statusBarView?.backgroundColor = .red
        addNavBar()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainMenuTableViewCell
        cell.backgroundView?.backgroundColor = categoryColors[indexPath.row]
        cell.categoryImage.backgroundColor = categoryColors[indexPath.row]
        cell.categoryImage.image = self.categoryImages[indexPath.row]
        cell.categoryTitle.text = self.categories[indexPath.row]
        return cell
    }
    
    func addNavBar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        navBar.barTintColor = UIColor.hexcodeToUIColor(hex: "#E53935")
        let navItem = UINavigationItem(title: "Drona");
        navBar.setItems([navItem], animated: false);
        self.view.addSubview(navBar);
    }

}

