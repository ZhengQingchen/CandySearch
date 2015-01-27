//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController,UISearchBarDelegate,UISearchDisplayDelegate {
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.candies = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == searchDisplayController!.searchResultsTableView {
                let indexPath = searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()
                let destinationTitle = filteredCandies[indexPath!.row].name
                candyDetailViewController.title = destinationTitle
            }else {
                let indexPath = tableView.indexPathForSelectedRow()
                let destinationTitle = candies[indexPath!.row].name
                candyDetailViewController.title = destinationTitle
            }
        }
    }
    
    func filterContentForSearchText(searchText:String,scope: String = "All") {
        filteredCandies = candies.filter({ (candy: Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView{
            return filteredCandies.count
        }else{
            return candies.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var candy:Candy
        
        if tableView == searchDisplayController!.searchResultsTableView {
            candy = filteredCandies[indexPath.row]
        }else {
            candy = candies[indexPath.row]
        }
        
        cell.textLabel!.text = candy.name
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("candyDetail", sender: tableView)
    }
    
    
    // MARK: - UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = searchDisplayController!.searchBar.scopeButtonTitles as [String]
        filterContentForSearchText(searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
}
