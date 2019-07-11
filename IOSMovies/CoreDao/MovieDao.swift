//
//  MovieDao.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/13/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import CoreData

class MovieDao{
    
    
    func insertMovie(movie : Movie) -> Bool {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
      let  managedContext = appDelegate.managedObjectContext
       

        let   movieEntity = NSEntityDescription.entity(forEntityName: Constants.tableName, in: managedContext)
        let movieObj = NSManagedObject(entity: movieEntity!, insertInto: managedContext)
        
        movieObj.setValue(movie.id, forKey: Constants.id)
       // movieObj.setValue(movie.voteAverage, forKey: MovieEntity.voteAverage.rawValue)
       // movieObj.setValue(movie.posterPath, forKey: MovieEntity.posterPath.rawValue)
        movieObj.setValue(movie.title, forKey: Constants.title)
        movieObj.setValue(movie.overview, forKey: Constants.overview)
        movieObj.setValue(movie.rating, forKey: Constants.rating)
       movieObj.setValue(movie.releaseYear, forKey: Constants.releaseDate)
       // movieObj.setValue(movie.originalLanguage, forKey: MovieEntity.originalLanguage.rawValue)
        movieObj.setValue(movie.image, forKey: Constants.image)
        movieObj.setValue(movie.trailers, forKey: Constants.trailers)
        movieObj.setValue(movie.reviews, forKey: Constants.reviews)
        
        do {
            try managedContext.save()
            print("added")

        } catch let error as NSError {
            print(error)
            return false
        }
        return true
    }
    
    
    func getAllMovies() -> Array<Movie> {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let  managedContext = appDelegate.managedObjectContext
        var moviesList : Array<Movie> = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.tableName)
        
        do {
            let fetchedMovies = try managedContext.fetch(fetchRequest)
            for item in fetchedMovies{
                let movie : Movie = Movie()
                
                movie.id = (item.value(forKey: Constants.id) as! Int?)!
                movie.title = (item.value(forKey: Constants.title) as! String?)!
                movie.image = (item.value(forKey: Constants.image) as! String?)!
                movie.rating = (item.value(forKey: Constants.rating) as! Double?)!
                movie.overview = (item.value(forKey: Constants.overview) as! String?)!
                movie.releaseYear = (item.value(forKey: Constants.releaseDate) as! String?)!
                movie.trailers = (item.value(forKey: Constants.trailers) as! [Trailers]?)!
                
                moviesList.append(movie)
            }
            
        } catch let error as NSError {
            print (error)
        }
        return moviesList
    }
    
    
    func getMovieDataById(id : Int) -> Movie {
        let movie : Movie = Movie()
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let  managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.tableName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.id) == %i", id)
        
        do {
            let fetchedMovies = try managedContext.fetch(fetchRequest)
            for item in fetchedMovies{
                movie.id = (item.value(forKey: Constants.id) as! Int?)!
                movie.title = (item.value(forKey: Constants.title) as! String?)!
                movie.image = (item.value(forKey: Constants.image) as! String?)!
                movie.overview = (item.value(forKey: Constants.overview) as! String?)!
                movie.releaseYear = (item.value(forKey: Constants.releaseDate) as! String?)!
                movie.trailers = (item.value(forKey: Constants.trailers) as! [Trailers]?)!
                movie.reviews = (item.value(forKey: Constants.reviews) as! [Reviews]?)!
                print(movie.title)
            }
            
        } catch let error as NSError {
            print (error)
        }
        return movie
    }
    
    func isMovieExists(id: Int) -> Bool {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let  managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.tableName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.id) == %i", id)
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    
    func deleteMovie(id: Int) -> Bool {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let  managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.tableName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.id) == %i", id)
        
        do {
            let fetchedMovies = try managedContext.fetch(fetchRequest)
            for item in fetchedMovies{
                managedContext.delete(item)
            }
            try managedContext.save()
            
        } catch let error as NSError {
            print (error)
            return false
        }
        
        return true
    }
    
}
