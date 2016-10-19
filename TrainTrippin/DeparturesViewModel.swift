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
    
    let networking = Networking()
    
    //  Output:
    let sections: Driver<[DeparturesListSection]>
    
    struct XMLElementName {
        static let root = "ArrayOfObjStationData"
        static let stationData = "objStationData"
        static let trainCode = "Traincode"
        static let trainType = "Traintype"
        static let expectedDeparture = "Expdepart"
    }
    
    let transformDataIntoSection: (HTTPURLResponse, Data) -> [DeparturesListSection] = { response in
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
        sections = self.networking.request()
            .map(transformDataIntoSection)
            .asDriver(onErrorJustReturn: [])
        
        super.init()
    }
}
