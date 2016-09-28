//
//  NavRouter.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/29/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class NavRouter {
    
    //story board ids
    private let main: String = "Main"
    private let search: String = "Search"
    
    //Storyboard view controller identifiers
    private let searchViewIdentifier: String = "SearchViewController"
    private let mapViewIdentifier: String = "MapViewController"
    private let ratesViewIdentifier: String = "BusesRatesViewController"
    private let informationViewIdentifier: String = "BusesInformationViewController"
    
    //Method that receives a storyboard string identifier and returns a view controller object
    private func buildComponentVC(identifier:String,storyBoard:String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func searchController()->UIViewController {
        return self.buildComponentVC(self.searchViewIdentifier,storyBoard: self.main)
    }
    
    func mapViewController()->UIViewController {
       return self.buildComponentVC(self.mapViewIdentifier,storyBoard: self.main)
    }
    
    func busesRatesController()->UIViewController {
        return self.buildComponentVC(self.ratesViewIdentifier,storyBoard: self.main)
    }
    
    func busesInformationController()->UIViewController {
        return self.buildComponentVC(self.informationViewIdentifier,storyBoard: self.main)
    }
    
}