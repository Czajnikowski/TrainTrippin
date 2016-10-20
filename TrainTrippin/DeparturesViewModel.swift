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
    let toggleRoute = PublishSubject<Void>()
    
    //  Output:
    let departuresSections: Driver<[DeparturesListSection]>
    let currentRoute = Variable(Route.fromDalkeyToBroombridge)
    
    enum Route {
        case fromDalkeyToBroombridge
        case fromBroombridgeToDalkey
    }
    
    private let networking = Networking()
    private let departures = Variable<[DepartureModel]>([])
    
    struct XMLElementName {
        static let root = "ArrayOfObjStationData"
        static let stationData = "objStationData"
        static let trainCode = "Traincode"
        static let trainType = "Traintype"
        static let expectedDeparture = "Expdepart"
        static let trainDirection = "Direction"
        static let northboundDirection = "Northbound"
        static let southboundDirection = "Southbound"
    }
    
    let transformResponseIntoDepartureModels: (Networking.Response) -> [DepartureModel] = { response in
        let xml = SWXMLHash.parse(response.1)
        let station = xml[XMLElementName.root][XMLElementName.stationData]
        
        return station
            .map { xml in
                let trainCode = xml[XMLElementName.trainCode].element!.text!
                let trainType = xml[XMLElementName.trainType].element!.text!
                let expectedDeparture = xml[XMLElementName.expectedDeparture].element!.text!
                let trainDirection = xml[XMLElementName.trainDirection].element!.text! == XMLElementName.northboundDirection ? TrainDirection.northbound : TrainDirection.southbound
                
                return (trainCode, trainType, expectedDeparture, trainDirection)
            }
            .map(DepartureModel.init)
    }
    
    override init() {
        departuresSections = departures.asObservable()
            .map { departures in
                let cellModels = departures.map(DepartureCellModel.init)
                let section = DeparturesListSection(model: Void(), items: cellModels)
                return [section]
            }
            .asDriver(onErrorJustReturn: [])
        
        super.init()
        
        toggleRoute
            .subscribe(onNext: { [unowned self] _ in
                if self.currentRoute.value == Route.fromBroombridgeToDalkey {
                    self.currentRoute.value = Route.fromDalkeyToBroombridge
                }
                else {
                    self.currentRoute.value = Route.fromBroombridgeToDalkey
                }
            })
            .addDisposableTo(disposeBag)
        
        refreshDepartures
            .withLatestFrom(currentRoute.asObservable())
            .subscribe(onNext: { [unowned self] route in
                self.networking.request()
                    .map(self.transformResponseIntoDepartureModels)
                    .bindTo(self.departures)
                    .addDisposableTo(self.disposeBag)
                }
            )
            .addDisposableTo(disposeBag)
        
        currentRoute.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.refreshDepartures.onNext(())
            })
            .addDisposableTo(disposeBag)
    }
}
