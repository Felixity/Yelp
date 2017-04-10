//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business] = []
    var filteredBusinesses: [Business] = []
    var isSearchActive = false
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var activeCategoryFilters: [String]?
    var activeDistanceFilters: NSNumber?
    var activeDealsFilters: Bool?
    var activeSortFilters: YelpSortMode?
    
    private let search = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
                
        setupSearchBar()
        setupLoadingIndicator()

        loadData()
        
        customizeNavigationBar()
    }

    private func setupSearchBar() {
        navigationItem.titleView = search
        search.placeholder = "Search"
        search.sizeToFit()
        
        search.delegate = self
    }
    
    private func setupLoadingIndicator() {
        let frame = getIndicatorFrame()
        
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView?.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }

    private func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .white
    }
    
    func loadData() {
        Business.searchWithTerm(term: "Restaurants", limit: 20, offset: self.businesses.count as NSNumber?, sort: activeSortFilters, categories: activeCategoryFilters, distance: activeDistanceFilters , deals: activeDealsFilters) { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses = self.businesses + businesses
            
                // Update loading flag
                self.isMoreDataLoading = false
            
                // Stop the Loading indicator
                self.loadingMoreView?.stopAnimating()
                
                // Use new data to update the datasource
                self.filteredBusinesses = self.businesses
            }
            
            // The table view must me updated even if there are no results coming from the server
            self.tableView.reloadData()
        }
    }
    
    func getIndicatorFrame() -> CGRect {
        let indicatorOrigin = CGPoint(x: 0, y: tableView.contentSize.height)
        let indicatorSize = CGSize(width: tableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
        return CGRect(origin: indicatorOrigin, size: indicatorSize)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        if let destinationVC = navigationController?.topViewController as? FiltersViewController {
            destinationVC.delegate = self
        }
    }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.businessCellIReuseIdentifier, for: indexPath) as! BusinessCell
        cell.businesses = filteredBusinesses[indexPath.row]
        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        isSearchActive = false
        filteredBusinesses = businesses
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = searchText != ""
        filteredBusinesses = isSearchActive ? businesses.filter{($0.name?.localizedCaseInsensitiveContains(searchText))!} : businesses
        tableView.reloadData()
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            
            // Calculate the position of one screen lenght before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user scrolled and excided the threshold, request new data
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                isMoreDataLoading = true

                // Update position of LoadingMoreView, and start loading indicator
                loadingMoreView?.frame = getIndicatorFrame()
                loadingMoreView?.startAnimating()
                
                // Load more data ...
                loadData()
            }
        }
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : [String]]) {
        
        activeDealsFilters = filters["deals"]?[0].contains("true")
        
        let distance = filters["distance"]?[0]
        activeDistanceFilters = (distance != nil) ? NSNumber(value: Int(distance!)!) : nil
        
        let sort = filters["sort"]?[0]
        activeSortFilters = (sort != nil) ? YelpSortMode(rawValue: Int(sort!)!) : nil
        
        activeCategoryFilters = filters["categories"]
        
        businesses.removeAll()
        filteredBusinesses = businesses
        loadData()
    }
}
