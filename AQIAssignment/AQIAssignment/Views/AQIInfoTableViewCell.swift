//
//  AQIInfoTableViewCell.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import UIKit

class AQIInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var AQIValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 5.0
        
    }

    func configurView(with model: AQICityModel) {
        cityNameLabel.text = model.cityName
        AQIValueLabel.text = model.aqiValue
        timeLabel.text = model.timeText
        containerView.backgroundColor = model.bgColor
        categoryLabel.text = model.category
    }

}
