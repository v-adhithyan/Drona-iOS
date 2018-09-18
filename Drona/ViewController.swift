//
//  ViewController.swift
//  Drona
//
//  Created by Adhithyan Vijayakumar on 22/07/18.
//  Copyright © 2018 Adhithyan Vijayakumar. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    let categories = ["Marketing", "Finance", "Economics", "Others"]
    let categoryImages = [UIImage(named: "marketing_menu"), UIImage(named: "finance_menu"), UIImage(named: "economics_menu"), UIImage(named: "others_menu")]
    let categoryColors = [UIColor.hexcodeToUIColor(hex: "#885f7f"), UIColor.hexcodeToUIColor(hex: "#d0c490"), UIColor.hexcodeToUIColor(hex: "#13b0a5"), UIColor.hexcodeToUIColor(hex: "#FFA500")]
    
    let network: NetworkManager = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "Drona"
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexcodeToUIColor(hex: "#E53935")
        //addNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row].uppercased()
        NetworkManager.isUnreachable { _ in
            self.view.makeToast("Internet is unavailable")
            return;
        }
        
        NetworkManager.isReachable { _ in
            let feedController = FeedViewController(nibName: "FeedViewController", bundle: nil)
            feedController.category = category
            self.navigationController?.pushViewController(feedController, animated: true)
        }
    }
    
    func addNavBar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        navBar.barTintColor = UIColor.hexcodeToUIColor(hex: "#E53935")
        let navItem = UINavigationItem(title: "Drona");
        navBar.setItems([navItem], animated: false);
        self.view.addSubview(navBar);
    }

}

