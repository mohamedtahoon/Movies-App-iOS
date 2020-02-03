//
//  MainCollectionViewController.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/5/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//


import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import SDWebImage
import Dropdowns



private let reuseIdentifier = "movieCell"

class MainCollectionViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectView: UICollectionView!
    
    var moviesList:Array<Movie> = []
    var movieDao = MovieDao()
     var check : String = "top_rated"
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.restorationIdentifier == "favorite" {
            DispatchQueue.main.async {
                self.moviesList = self.movieDao.getAllMovies()
                self.collectionView?.reloadData()
            }
        }
        else{
            if self.isConnectedToInternet() == true{
                print("YES Connected To INTERNET ")
                drawDropDownList()
                alamofireRequest(ChecckVal: check)
                
            }else{
                print("NO THERE ISN'T")
                alert(message: "No Internet Connection")
            }

        }
    }
    
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //style collection view cell
        
        let itemSize = UIScreen.main.bounds.width/2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:itemSize , height:itemSize+40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectView?.collectionViewLayout = layout


       
        self.clearsSelectionOnViewWillAppear = false

    }

    func drawDropDownList(){
        let items = ["Now Playing", "Top Rated", "Most popular"]
        let titleView = TitleView(navigationController: navigationController!, title: "Now playing", items: items)
        titleView?.action = { [weak self] index in
            print("select \(index)")
            switch (index) {
            case 0:
                self?.alamofireRequest(ChecckVal:"now_playing")
            case 1:
                self?.alamofireRequest(ChecckVal: "top_rated")
            case 2:
                self?.alamofireRequest(ChecckVal: "popular")
            default:
                print("default index ")
            }
        }
        
        navigationItem.titleView = titleView
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return moviesList.count
        
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        cell.imgMovie.sd_setImage(with: URL(string: Constants.imgUrl+self.moviesList[indexPath.row].image!), placeholderImage: UIImage(named: "logo.png"))
        
        
        
        
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfMoviesHigh = collectionView.bounds.size.height/3
        return CGSize(width: (collectionView.bounds.size.width/2 ), height: CGFloat(noOfMoviesHigh))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsController : SingleMovieViewDetails = storyboard?.instantiateViewController(withIdentifier: "movieDetailsController") as! SingleMovieViewDetails
        movieDetailsController.modalTransitionStyle = .flipHorizontal
        movieDetailsController.movie = moviesList[indexPath.item];
        movieDetailsController.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(movieDetailsController, animated: true);
    }
    
    
    func alamofireRequest(ChecckVal: String )
    {
        Alamofire.request(Constants.movieUrl+"movie/\(ChecckVal)?api_key="+Constants.apiKey).responseJSON
            {
                (response) in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    self.moviesList=Utilities.getMovies(json: json["results"]);
                    self.collectionView?.reloadData()
                case .failure(let err):
                    print(err)
                }
        }
    }
    
    
    func isConnectedToInternet() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //        alertController.addAction(OKAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
