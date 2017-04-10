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
    
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the model
        filters = Filter.filters(items: Constants.yelpFilters)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.separatorInset = UIEdgeInsets.zero
        
        // In order to allow the checkmark of one row per section, is important to set the allowsMultipleSelection property
        tableView.allowsMultipleSelection = true
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        let filters = getActiveFilters()
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)
        self.dismiss(animated: true, completion: nil)
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
        return checkMarkCell
    }

    // MARK: Protocol's functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if indexPath.section == 0 || indexPath.section == 3 {
            cell = createSwitchCell(indexPath)
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
        
        if (selectedRowsInCurrentSection?.count)! >= 1 {
            if indexPath.section == 1 || indexPath.section == 2 {

                for row in selectedRowsInCurrentSection! {
                    
                    if row != indexPath.row {
    
                        // The previous marked row must be unchecked and deselected, in order to allow the current one to be maked as checked
                        filters[indexPath.section][row].itemState = false
                        let oldIndexPath = IndexPath(row: row, section: indexPath.section)
                        tableView.cellForRow(at: oldIndexPath)?.accessoryType = UITableViewCellAccessoryType.none
                        tableView.deselectRow(at: oldIndexPath, animated: false)
                    }
                    else{
                 
                        // No row was previous marked, the current one is the first one
                        filters[indexPath.section][row].itemState = true
                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
            }
            else {
                
                // for rows that are in sections with switch components restict multiple row selection
                for row in selectedRowsInCurrentSection! {
                    if row != indexPath.row {
                        let newIndexPath = IndexPath(row: row, section: indexPath.section)
                        tableView.deselectRow(at: newIndexPath, animated: false)
                    }
                }
            }
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
