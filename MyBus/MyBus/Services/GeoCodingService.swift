//
//  GeoCodingService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GeoCodingServiceDelegate {
    func getCoordinateFromAddress(streetName: String, completionHandler: (RoutePoint?, NSError?) -> ())
}

public class GeoCodingService: NSObject, GeoCodingServiceDelegate {
    func getCoordinateFromAddress(streetName: String, completionHandler: (RoutePoint?, NSError?) -> ()) {
        print("Address to resolve geocoding: \(streetName)")

        let address = "\(streetName), mar del plata"
        let components = "administrative_area:General Pueyrredón"

        let request: NSURLRequest = GeoCodingRouter.CoordinateFromAddressComponents(address: address, components: components, key: GeoCodingRouter.GEO_CODING_API_KEY).URLRequest

        BaseNetworkService.performRequest(request) { response, error in
            if let json = response {
                completionHandler(RoutePoint.parseFromGeoGoogle(json), error)
            } else {
                completionHandler(nil, error)
            }
        }

    }
}
