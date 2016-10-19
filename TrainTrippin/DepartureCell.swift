//
//  DepartureCell.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import UIKit
import Foundation


class DepartureCell: UITableViewCell {
    
    @IBOutlet weak var trainTypeLabel: UILabel!
    @IBOutlet weak var trainCodeLabel: UILabel!
    @IBOutlet weak var departureCountdownLabel: UILabel!
    
    func configure(_ viewModel: DepartureCellModelType) {
        trainTypeLabel.text = viewModel.trainType
        trainCodeLabel.text = viewModel.trainCode
        departureCountdownLabel.text = viewModel.departsIn
    }
}
