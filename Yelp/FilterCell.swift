//
//  FilterCell.swift
//  Yelp
//
//  Created by Laura on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool)
}

class FilterCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    var delegate: FilterCellDelegate?
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.filterCell(filterCell: self, didChangeValue: onSwitch.isOn)
    }
    
    var filter: Filter? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // reset existing content
        
        switchLabel.text = nil
        onSwitch.isOn = false
        
        if let filter = filter {
            switchLabel.text = filter.itemName
            
            if let switchState = filter.itemState {
                onSwitch.isOn = switchState
            }
        }
    }
}
