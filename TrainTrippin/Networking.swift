//
//  Networking.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SWXMLHash

class Networking {
    typealias Response = (HTTPURLResponse, Data)
    
    struct APIurl {
        static let departuresFromDalkeyURL = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML_withNumMins?StationDesc=Dalkey&NumMins=90")!
        static let departuresFromBroombridgeURL = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML_withNumMins?StationDesc=Broombridge&NumMins=90")!
    }
    
    init() {
        let urlCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        URLCache.shared = urlCache
    }
    
    func requestTrainsFromDalkey() -> Observable<XMLIndexer> {
        return request(withURL: APIurl.departuresFromDalkeyURL)
    }
    
    func requestTrainsFromBroombridge() -> Observable<XMLIndexer> {
        return request(withURL: APIurl.departuresFromBroombridgeURL)
    }
    
    private func request(withURL url: URL) -> Observable<XMLIndexer> {
        return URLSession.shared.rx.XML(url)
    }
}

extension Reactive where Base: URLSession {
    func XML(_ url: URL) -> Observable<XMLIndexer> {
        return Observable.create { observer -> Disposable in
            let cacheRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataDontLoad)
            _ = self.XML(cacheRequest).bindTo(observer)
            
            let serverRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData)
            _ = self.XML(serverRequest).bindTo(observer)
            
            return Disposables.create()
        }
    }
    
    func XML(_ request: URLRequest) -> Observable<XMLIndexer> {
        return data(request).map { data in
            return SWXMLHash.parse(data)
        }
    }
}
