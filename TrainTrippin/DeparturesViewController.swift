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
    }
    
    func configure(_ viewModel: DeparturesViewModel) {
        dataSource.configureCell = { [unowned self] _, tableView, indexPath, viewModel in
            let strongSelf = self
            let cell = strongSelf.departuresTableView.dequeueReusableCell(withIdentifier: Reusable.cellReuseIdentifier, for: indexPath) as! DepartureCell
            cell.configure(viewModel)
            
            return cell
        }
        
        viewModel.sections
            .drive(departuresTableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func changeDirectionButtonDidTap() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.changeDirectionButton.transform = self.changeDirectionButton.transform.rotated(by: CGFloat(M_PI))
        }
    }
}

extension DeparturesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        departuresTableView.deselectRow(at: indexPath, animated: true)
    }
}
