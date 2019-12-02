//
//  Utilities.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/5/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utilities {
    static public func getMovies(json:JSON)->[Movie]{
        var movies:[Movie]=[];
        for (_,movie):(String, JSON) in json {
            let mov : Movie=Movie();
            for (key,value):(String, JSON) in movie {
                switch key{
                case "id":
                    mov.id = value.int
                    
                case "title":
                    mov.title = value.string
                    
                case "overview":
                    mov.overview = value.string
                    
                case "poster_path":
                    mov.image = value.string
                    
                case "vote_average":
                    mov.rating = value.double
                
                case "release_date":
                    mov.releaseYear = value.string
                    
                
                case "popularity":
                    mov.popularity = value.float
                    
                default: break
                    
                }
            }
            movies.append(mov);
        }
        return movies;
    }
    
    static public func getTrailers(json:JSON)->[Trailers]{
        var trailers:[Trailers]=[]
        for (_,trailer):(String, JSON) in json {
            let mov:Trailers=Trailers()
            for (key,value):(String, JSON) in trailer {
                switch key{
                case "name":
                    mov.name=value.string;
                    
                case "key":
                    mov.key=value.string;
                    
                    
                default: break
                }
            }
            trailers.append(mov)
        }
        return trailers
    }
    
    
    static public func getReviews(fromJson json:JSON)->[Reviews]{
        var reviews:[Reviews]=[]
        for (_,review):(String, JSON) in json {
            let mov:Reviews=Reviews()
            for (key,value):(String, JSON) in review {
                switch key{
                case "author":
                    mov.author=value.string ?? "";
                    
                case "content":
                    mov.content=value.string ?? "";
                    
                default: break
                    
                }
            }
            reviews.append(mov)
        }
        return reviews
    }

}
