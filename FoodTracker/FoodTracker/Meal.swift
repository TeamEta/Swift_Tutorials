//
//  Meal.swift
//  FoodTracker
//
//  Created by Engineering on 2/20/17.
//  Copyright © 2017 Engineering. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int

    
    //MARK: Initializers
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        

        
        // initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
