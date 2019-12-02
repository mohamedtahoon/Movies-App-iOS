//
//  Reviews.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/5/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation

class Reviews : NSObject, NSCoding{
    
    var author : String = ""
    var content : String = ""
    
    
    public func encode(with aCoder: NSCoder){
        
        aCoder.encode(author, forKey: "author")
        aCoder.encode(content, forKey: "content")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        author = aDecoder.decodeObject(forKey: "author") as? String ?? ""
        content = aDecoder.decodeObject(forKey: "content") as? String ?? ""
    }
    
    override init() {
        super.init()
    }
}
