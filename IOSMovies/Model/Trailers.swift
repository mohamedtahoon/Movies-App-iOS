//
//  Trailer.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/5/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation

class Trailers :  NSObject, NSCoding{
    var name: String?
    var key: String?

    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(key, forKey: "key")
        aCoder.encode(name, forKey: "name")
       
    }
    
    required public init?(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        
    }
    
    override init() {
        super.init()
    }
}

