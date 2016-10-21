//
//  RouteViewController.swift
//  TrainTrippin
//
//  Created by Maciek on 18.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import RxDataSources
import UIKit
import RxSwift

class RouteViewController: UIViewController {
    var viewModel: RouteViewModel!

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var trainInfoLabel: UILabel!
    @IBOutlet weak var trainDirectionLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureStation: UILabel!
    
    func configure(_ viewModel: RouteViewModel) {
        countdownLabel.text = viewModel.departsIn
        trainInfoLabel.text = viewModel.trainInfo
        trainDirectionLabel.text = viewModel.trainDirection
        departureTimeLabel.text = viewModel.departureTime
        departureStation.text = viewModel.departureStation
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(viewModel)
    }
}

