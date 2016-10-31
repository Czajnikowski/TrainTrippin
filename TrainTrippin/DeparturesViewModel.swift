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
    
    private let _networking = Networking()
    private let _departures = Variable<[DepartureModel]>([])
    private let _showRefreshControl = PublishSubject<Bool>()
    private let _currentRoute = Variable(Route.fromDalkeyToBroombridge)
    
    private let disposeBag = DisposeBag()
    
    override init() {
        departuresSections = _departures.asObservable()
            .map { departures in
                let cellModels = departures.map(DepartureCellModel.init)
                let section = DeparturesListSection(model: Void(), items: cellModels)
                return [section]
            }
            .asDriver(onErrorJustReturn: [])
        
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .withLatestFrom(_departures.asObservable())
            .asDriver(onErrorJustReturn: [])
            .drive(_departures)
            .addDisposableTo(disposeBag)
        
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
                let request: Observable<XMLIndexer>
                if route == Route.fromDalkeyToBroombridge {
                    request = self._networking.requestTrainsFromDalkey()
                }
                else {
                    request = self._networking.requestTrainsFromBroombridge()
                }
                
                request
                    .do(onNext: { response in
                        self._showRefreshControl.onNext(false)
                    }, onError: { _ in
                        self._showRefreshControl.onNext(false)
                    })
                    .map(self.transformResponseIntoDepartureModelsTowardsDestination)
                    .bindTo(self._departures)
                    .addDisposableTo(self.disposeBag)
                }
            )
            .addDisposableTo(disposeBag)
        
        currentRoute
            .skip(1)
            .distinctUntilChanged(==)
            .map { _ in
                return Void()
            }
            .bindTo(refreshDepartures)
            .addDisposableTo(disposeBag)
    }
    
    func viewModel(forIndexPath indexPath: IndexPath) -> RouteViewModel {
        let model = _departures.value[indexPath.row]
        return RouteViewModel(withDepartureModel: model)
    }
    
    struct XMLElementName {
        static let root = "ArrayOfObjStationData"
        static let stationData = "objStationData"
        static let trainCode = "Traincode"
        static let trainType = "Traintype"
        static let station = "Stationfullname"
        static let expectedDeparture = "Expdepart"
        static let trainDirection = "Direction"
        static let northboundDirection = "Northbound"
        static let southboundDirection = "Southbound"
    }
    
    func transformResponseIntoDepartureModelsTowardsDestination(_ xml: XMLIndexer) -> [DepartureModel] {
        let station = xml[XMLElementName.root][XMLElementName.stationData]
        
        return station
            .map { xml in
                let trainCode = xml[XMLElementName.trainCode].element!.text!
                let trainType = xml[XMLElementName.trainType].element!.text!
                let station = xml[XMLElementName.station].element!.text!
                let expectedDeparture = xml[XMLElementName.expectedDeparture].element!.text!
                let trainDirection = xml[XMLElementName.trainDirection].element!.text! == XMLElementName.northboundDirection ? TrainDirection.northbound : TrainDirection.southbound
                
                return (trainCode, trainType, expectedDeparture, trainDirection, station)
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
