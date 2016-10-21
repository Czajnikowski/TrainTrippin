//
//  DeparturesViewController.swift
//  TrainTrippin
//
//  Created by Maciek on 18.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import RxDataSources
import UIKit
import RxSwift

class DeparturesViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var departuresTableView: UITableView!
    @IBOutlet weak var changeDirectionButton: UIButton!
    @IBOutlet var viewModel: DeparturesViewModel!
    
    let dataSource = RxTableViewSectionedReloadDataSource<DeparturesListSection>()
    
    struct Reusable {
        static let cellReuseIdentifier = "DepartureCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(viewModel)
        loadDepartures(viewModel)
    }
    
    func configure(_ viewModel: DeparturesViewModel) {
        dataSource.configureCell = { [unowned self] _, tableView, indexPath, viewModel in
            let strongSelf = self
            let cell = strongSelf.departuresTableView.dequeueReusableCell(withIdentifier: Reusable.cellReuseIdentifier, for: indexPath) as! DepartureCell
            cell.configure(viewModel)
            
            return cell
        }
        
        viewModel.departuresSections
            .drive(departuresTableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        viewModel.currentRoute.asObservable()
            .subscribe(onNext: { route in
                UIView.animate(withDuration: 0.2) { [unowned self] in
                    if route == .fromDalkeyToBroombridge {
                        self.changeDirectionButton.transform = CGAffineTransform(rotationAngle: 0.0)
                    }
                    else {
                        self.changeDirectionButton.transform = CGAffineTransform(rotationAngle:  CGFloat(M_PI))
                    }
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func loadDepartures(_ viewModel: DeparturesViewModel) {
        viewModel.refreshDepartures.onNext(())
    }
    
    @IBAction func changeDirectionButtonDidTap() {
        viewModel.toggleRoute.onNext(())
    }
}

extension DeparturesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        departuresTableView.deselectRow(at: indexPath, animated: true)
    }
}
