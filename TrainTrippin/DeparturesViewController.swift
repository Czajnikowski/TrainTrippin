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
    @IBOutlet weak var departuresTableView: UITableView!
    @IBOutlet weak var changeDirectionButton: UIButton!
    @IBOutlet var viewModel: DeparturesViewModel!
    private let refreshControl = UIRefreshControl()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<DeparturesListSection>()
    
    private let disposeBag = DisposeBag()
    
    struct Reusable {
        static let cellReuseIdentifier = "DepartureCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl(inTableView: departuresTableView)
        configure(viewModel)
        
        loadDepartures()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let routeViewController = (segue.destination as! UINavigationController).viewControllers.first! as! RouteViewController
        routeViewController.viewModel = viewModel.viewModel(forIndexPath: departuresTableView.indexPathForSelectedRow!)
    }
    
    func addRefreshControl(inTableView tableView: UITableView) {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        departuresTableView.addSubview(refreshControl)
    }
    
    func configure(_ viewModel: DeparturesViewModel) {
        dataSource.configureCell = { _, tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: Reusable.cellReuseIdentifier, for: indexPath) as! DepartureCell
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
        
        viewModel.showRefreshControl
            .filter { return $0 == false }
            .subscribe(onNext: { showRefreshControl in
                self.refreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)
    }
    
    func loadDepartures() {
        viewModel.refreshDepartures.onNext(())
    }
    
    @IBAction func changeDirectionButtonDidTap() {
        viewModel.toggleRoute.onNext(())
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        loadDepartures()
    }
}

extension DeparturesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        departuresTableView.deselectRow(at: indexPath, animated: true)
    }
}
