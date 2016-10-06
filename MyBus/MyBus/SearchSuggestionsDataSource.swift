//
//  SearchSuggestionsDataSource.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/22/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SearchSuggestionsDataSource: NSObject, UITableViewDataSource {
    
    var bestMatches: [(String, SearchFilterType)] = []
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: SuggestionSearchTableViewCell = tableView.dequeueReusableCellWithIdentifier("SuggestionSearchTableViewCell", forIndexPath: indexPath) as! SuggestionSearchTableViewCell
        cell.loadItem(bestMatches[indexPath.row].0,type: bestMatches[indexPath.row].1)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestMatches.count
    }
    
}