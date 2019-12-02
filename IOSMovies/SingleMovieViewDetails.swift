//
//  SingleMovieViewDetails.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import Alamofire
import SwiftyJSON



class SingleMovieViewDetails: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var isFavourit=false
    let movieDao = MovieDao()
    @IBOutlet weak var addOrRemoveFromFav: UIButton!
    @IBAction func addToFavourits(_ sender: Any) {
        if !isFavourit{
        movieDao.insertMovie(movie: self.movie)
            addOrRemoveFromFav.setTitle("unFavorite", for: .normal)
        }
        else{
            movieDao.deleteMovie(id: movie.id!)
            addOrRemoveFromFav.setTitle("Add to Favorite", for: .normal)
        }
         isFavourit = !isFavourit
    }
    var movie:Movie!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieOverView: UILabel!
    
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var movieTrailerTable: UITableView!
    @IBAction func showReviewsbtn(_ sender: Any) {
        
        let displayReviews:ReviewTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "movieRevs") as! ReviewTableViewController
        displayReviews.movie = self.movie
        self.navigationController?.pushViewController(displayReviews, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     isFavourit = movieDao.isMovieExists(id: movie.id!)
        if isFavourit{
            addOrRemoveFromFav.setTitle("unFavorite", for: .normal)

        }
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor(red:30/255, green:30/255, blue:30/255, alpha: 5).cgColor
        
        movieName.text = movie.title
        movieImg.sd_setImage(with: URL(string: Constants.imgUrl+self.movie.image!), placeholderImage: UIImage(named: "logo.png"))
        movieYear.text = movie.releaseYear
        movieRating.settings.fillMode = .precise
        
        movieRating.rating=Double(movie.rating!/2)
        movieOverView.text = movie.overview
        let trailerUrl =  Constants.movieUrl + "movie/" + String(describing: movie.id!) + "/videos?api_key=" + Constants.apiKey
        let reviewUrl =  Constants.movieUrl + "movie/" + String(describing: movie.id!) + "/reviews?api_key=" + Constants.apiKey
        fetchTrailersAndReviews(trailerUrl: trailerUrl,reviewUrl:reviewUrl)

        // Do any additional setup after loading the view.
        movieTrailerTable.delegate=self
        movieTrailerTable.dataSource=self
    }
    
    func fetchTrailersAndReviews(trailerUrl tUrl: String,reviewUrl rUrl: String)  {
        
        DispatchQueue.main.async {
            Alamofire.request(tUrl).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.movie.trailers = Utilities.getTrailers(json: json["results"]);
                    self.movieTrailerTable.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
    }

    // trailers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movie.trailers?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath as IndexPath)
        cell.textLabel?.text = movie.trailers?[indexPath.row].name
        cell.imageView?.image = UIImage(named:"play.png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let youtubeURL = URL(string:"https://www.youtube.com/watch?v="+(movie.trailers?[indexPath.row].key!)!)
        if(UIApplication.shared.canOpenURL(youtubeURL!)){
            UIApplication.shared.openURL(youtubeURL!)
        }
    }
}
