//
//  DeparturesViewModel.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import SWXMLHash
import RxSwift

typealias DeparturesListSection = SectionModel<Void, DepartureCellModelType>

class DeparturesViewModel: NSObject {
    private let disposeBag = DisposeBag()
    
    //  Input:
    let refreshDepartures = PublishSubject<Void>()
    
    //  Output:
    let sections: Driver<[DeparturesListSection]>
    
    private let networking = Networking()
    private let departures = Variable<[DepartureModel]>([])
    
    struct XMLElementName {
        static let root = "ArrayOfObjStationData"
        static let stationData = "objStationData"
        static let trainCode = "Traincode"
        static let trainType = "Traintype"
        static let expectedDeparture = "Expdepart"
    }
    
    let transformResponseIntoDepartureModels: (Networking.Response) -> [DepartureModel] = { response in
        let xml = SWXMLHash.parse(response.1)
        let station = xml[XMLElementName.root][XMLElementName.stationData]
        let cellModels = station
            .map { xml in
                let trainCode = xml[XMLElementName.trainCode].element!.text!
                let trainType = xml[XMLElementName.trainType].element!.text!
                let expectedDeparture = xml[XMLElementName.expectedDeparture].element!.text!
                
                return (trainCode, trainType, expectedDeparture)
            }
            .map(DepartureModel.init)
            .map(DepartureCellModel.init)
        
        let section = DeparturesListSection(model: Void(), items: cellModels)

        return [section]
    }
    
    override init() {
        sections = departures.asObservable()
            .map { departures in
                let cellModels = departures.map(DepartureCellModel.init)
                let section = DeparturesListSection(model: Void(), items: cellModels)
                return [section]
            }
            .asDriver(onErrorJustReturn: [])
        
        super.init()
        
        refreshDepartures
            .subscribe(onNext: { [unowned self] _ in
                self.networking.request()
                    .map(self.transformResponseIntoDepartureModels)
                    .bindTo(self.departures)
                    .addDisposableTo(self.disposeBag)
                })
            .addDisposableTo(disposeBag)
    }
}
