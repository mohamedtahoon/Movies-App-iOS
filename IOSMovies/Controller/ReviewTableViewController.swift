//
//  ReviewTableViewController.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/9/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
private let reuseIdentifier = "ReviewCell"

class ReviewTableViewController: UITableViewController {

  
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        
        let reviewUrl =  Constants.movieUrl + "movie/" + String(describing: movie.id!) + "/reviews?api_key=" + Constants.apiKey
        Alamofire.request(reviewUrl).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.movie.reviews = Utilities.getReviews(fromJson: json["results"]);
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movie.reviews?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! ReviewTableViewCell
        cell.personName.text = movie.reviews?[indexPath.row].author
        cell.reviewContent.text = movie.reviews?[indexPath.row].content
       
        
        print("fgdfg  "+(movie.reviews?[indexPath.row].content)! )
        
        print("///////////////////////")
        
        return cell
    
    
    }
    
}
