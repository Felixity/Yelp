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
    var filteredBusinesses: [Business]?
    var isSearchActive = false
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
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
    
    func loadData() {
        Business.searchWithTerm(term: "Restaurants", limit: 20, offset: self.businesses.count as NSNumber?, sort: nil, categories: nil, deals: nil) { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = self.businesses + businesses!
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            // Update loading flag
            self.isMoreDataLoading = false
            
            // Stop the Loading indicator
            self.loadingMoreView?.stopAnimating()
            
            // Use new data to update the datasource
            self.filteredBusinesses = self.businesses
            
            self.tableView.reloadData()
        }
    }
    
    func getIndicatorFrame() -> CGRect {
        let indicatorOrigin = CGPoint(x: 0, y: tableView.contentSize.height)
        let indicatorSize = CGSize(width: tableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
        return CGRect(origin: indicatorOrigin, size: indicatorSize)
    }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = filteredBusinesses?.count
        return numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.businesses = filteredBusinesses?[indexPath.row]
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
