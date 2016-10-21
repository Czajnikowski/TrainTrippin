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
    //  Input:
    let refreshDepartures = PublishSubject<Void>()
    let toggleRoute = PublishSubject<Void>()
    
    //  Output:
    let departuresSections: Driver<[DeparturesListSection]>
    let showRefreshControl: Observable<Bool>
    let currentRoute: Observable<Route>
    
    enum Route {
        case fromDalkeyToBroombridge
        case fromBroombridgeToDalkey
    }
    
    private let networking = Networking()
    private let departures = Variable<[DepartureModel]>([])
    private let _showRefreshControl = PublishSubject<Bool>()
    private let _currentRoute = Variable(Route.fromDalkeyToBroombridge)
    
    private let disposeBag = DisposeBag()
    
    override init() {
        departuresSections = departures.asObservable()
            .map { departures in
                let cellModels = departures.map(DepartureCellModel.init)
                let section = DeparturesListSection(model: Void(), items: cellModels)
                return [section]
            }
            .asDriver(onErrorJustReturn: [])
        
        showRefreshControl = _showRefreshControl.asObservable()
        currentRoute = _currentRoute.asObservable()
        
        super.init()
        
        toggleRoute
            .subscribe(onNext: { [unowned self] _ in
                if self._currentRoute.value == Route.fromBroombridgeToDalkey {
                    self._currentRoute.value = Route.fromDalkeyToBroombridge
                }
                else {
                    self._currentRoute.value = Route.fromBroombridgeToDalkey
                }
            })
            .addDisposableTo(disposeBag)
        
        refreshDepartures
            .withLatestFrom(currentRoute.asObservable())
            .subscribe(onNext: { [unowned self] route in
                let request: Observable<(HTTPURLResponse, Data)>
                if route == Route.fromDalkeyToBroombridge {
                    request = self.networking.requestTrainsFromDalkey()
                }
                else {
                    request = self.networking.requestTrainsFromBroombridge()
                }
                
                request
                    .do(onNext: { response in
                        self._showRefreshControl.onNext(false)
                    }, onError: { _ in
                        self._showRefreshControl.onNext(false)
                    })
                    .map(self.transformResponseIntoDepartureModelsTowardsDestination)
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
    
    func viewModel(forIndexPath indexPath: IndexPath) -> RouteViewModel {
        let model = departures.value[indexPath.row]
        return RouteViewModel(withDepartureModel: model)
    }
    
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
    
    func transformResponseIntoDepartureModelsTowardsDestination(_ response: (HTTPURLResponse, Data)) -> [DepartureModel] {
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
            .filter { train in
                if _currentRoute.value == .fromDalkeyToBroombridge {
                    return train.3 == .northbound
                }
                else {
                    return train.3 == .southbound
                }
            }
            .map(DepartureModel.init)
    }
}
