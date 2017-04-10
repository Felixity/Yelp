//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Laura on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: [String]])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filters: [[Filter]] = []
    var originalFilters: [[Filter]] = []
    var filtersState = [false, false, false, false]
    
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the model
        originalFilters = Filter.filters(items: Constants.yelpFilters)
        originalFilters[1][0].itemState = true
        originalFilters[2][0].itemState = true
        filters = getReducedFilters()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.separatorInset = UIEdgeInsets.zero
        
        // In order to allow the checkmark of one row per section, is important to set the allowsMultipleSelection property
        tableView.allowsMultipleSelection = true
        
        customizeNavigationBar()        
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        let filters = getActiveFilters()
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = .red
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .white
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.lightGray
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 4
            let attributeColor = UIColor.white
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: attributeColor,NSShadowAttributeName: shadow]
        }
    }
    
    private func getActiveFilters() -> [String: [String]] {
        var activeFilters: [String: [String]] = [:]
        var itemCodeOfActiveFilters: [String] = []
        
        for (sectionNumber, sectionItems) in filters.enumerated() {
            itemCodeOfActiveFilters = sectionItems.filter{$0.itemState!}.map{$0.itemCode!}

            if itemCodeOfActiveFilters.count > 0 {
                activeFilters[Constants.filterKeys[sectionNumber]] = itemCodeOfActiveFilters
            }
        }

        print("activeFilters: \(activeFilters)")
        return activeFilters
    }
    
    func getReducedFilters() -> [[Filter]] {
        var newFilters:[[Filter]] = []
        
        // deals
        newFilters.append(originalFilters[0])

        // distance
        newFilters.append(filtersState[1] ? originalFilters[1] : originalFilters[1].filter{$0.itemState!})
        
        // sort by
        newFilters.append(filtersState[2] ? originalFilters[2] : originalFilters[2].filter{$0.itemState!})
        
        // categories
        newFilters.append(filtersState[3] ? originalFilters[3] : Array<Filter>(originalFilters[3].prefix(5)))
        
        return newFilters
    }
    
    
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: Private functions
    
    private func createSwitchCell(_ indexPath: IndexPath) -> FilterCell {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: Constants.switchCellReuseIdentifier, for: indexPath) as! FilterCell
        switchCell.filter = filters[indexPath.section][indexPath.row]
        switchCell.delegate = self
        return switchCell
    }
    
    private func createCheckMarkCell(_ indexPath: IndexPath) -> UITableViewCell {
        let checkMarkCell = tableView.dequeueReusableCell(withIdentifier: Constants.checkMarkCellReuseIdentifier, for: indexPath)
        checkMarkCell.textLabel?.text = filters[indexPath.section][indexPath.row].itemName
        
        let filterItem = filters[indexPath.section][indexPath.row]
        checkMarkCell.accessoryType = filterItem.itemState! ? .disclosureIndicator : .none
        return checkMarkCell
    }
    
    private func createSeeAllCell(_ indexPath: IndexPath) -> UITableViewCell {
        let seeAllCell = tableView.dequeueReusableCell(withIdentifier: Constants.seeAllCellReuseIdentifier, for: indexPath)
        return seeAllCell
    }
    
    private func expandTable(_ indexPath: IndexPath) {
        filtersState[indexPath.section] = true
        filters = getReducedFilters()
        
        tableView.reloadData()
    }

    private func collapseTable(_ indexPath: IndexPath) {
        filtersState[indexPath.section] = false
        filters = getReducedFilters()
        tableView.reloadData()
    }
    
    // MARK: Protocol's functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
            
            cell = createSwitchCell(indexPath)
        }
        else if indexPath.section == 3 {
            
            cell = createSwitchCell(indexPath)
            
            if indexPath.row == filters[indexPath.section].count-1 {
                if filtersState[indexPath.section] == false {
                    // add See All button
                    cell = createSeeAllCell(indexPath)
                }
            }
        }
        else {
            // in case section == 1 && section == 2
            cell = createCheckMarkCell(indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let markedRows = tableView.indexPathsForSelectedRows
        let selectedRowsInCurrentSection = markedRows?.filter{ $0[0] == indexPath.section }.map{$0[1]}
        
        print("selectedSectionItems: \(selectedRowsInCurrentSection)")
        
        if filters[indexPath.section].count > 1 {
            if (selectedRowsInCurrentSection?.count)! >= 1 {
                if indexPath.section == 1 || indexPath.section == 2 {
                    
                    for row in 0..<filters[indexPath.section].count {
                        
                        if row != indexPath.row {
                            
                            // The previous marked row must be unchecked and deselected, in order to allow the current one to be maked as checked
                            filters[indexPath.section][row].itemState = false
                            let oldIndexPath = IndexPath(row: row, section: indexPath.section)
                            tableView.cellForRow(at: oldIndexPath)?.accessoryType = .none
                            tableView.deselectRow(at: oldIndexPath, animated: false)
                        }
                        else{
                            
                            // No row was previous marked, the current one is the first one
                            filters[indexPath.section][row].itemState = true
                            tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
                        }
                    }
                    
                    collapseTable(indexPath)
                }
                else {
                    
                    // for rows that are in sections with switch components restict multiple row selection
                    for row in selectedRowsInCurrentSection! {
                        if row != indexPath.row {
                            let newIndexPath = IndexPath(row: row, section: indexPath.section)
                            tableView.deselectRow(at: newIndexPath, animated: false)
                        }
                    }
                    
                    if indexPath.section == 3 && indexPath.row == filters[indexPath.section].count-1 {
                        expandTable(indexPath)
                    }
                }
            }
        }
        else {
            expandTable(indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
}

extension FiltersViewController: FilterCellDelegate {
    
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let index = tableView.indexPath(for: filterCell)
        if let index = index {
            filters[index.section][index.row].itemState = value
        }
    }
}
