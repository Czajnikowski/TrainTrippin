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
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureStation: UILabel!
    
    func configure(_ viewModel: RouteViewModel) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(viewModel)
    }
}

