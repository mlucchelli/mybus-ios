//
//  SingleRouteView.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/17/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

protocol RoutePresenterDelegate {
    var routeResultModel: BusRouteResult? { get set }
    var roadResultModel: RoadResult? { get set }
    func reloadData()
    func updateViewWithRoadInfo()
    func preferredHeight()->CGFloat
}


class SingleRouteView: UIView, RoutePresenterDelegate {

    //Constants
    fileprivate var nibId: String = "SingleRouteView"
    fileprivate var viewHeight: CGFloat = 135

    //Xib Outlets
    @IBOutlet weak var lblOriginAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblTravelDistance: UILabel!
    @IBOutlet weak var lblTravelTime: UILabel!
    @IBOutlet weak var lblWalkDistanceToOrigin: UILabel!
    @IBOutlet weak var lblWalkDistanceToDestination: UILabel!
    @IBOutlet weak var destinationToOriginHeightConstraint: NSLayoutConstraint!


    //Xib attributes
    var routeResultModel: BusRouteResult? {
        didSet{
            reloadData()
        }
    }

    var roadResultModel: RoadResult? {
        didSet{
            updateViewWithRoadInfo()
        }
    }

    //Methods
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: viewHeight)
        super.init(frame: rect)
        xibSetup(nibId)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup(nibId)
    }

    // MARK: RouterPresenterDelegate methods
    func reloadData() {

        guard let model = routeResultModel else {
            NSLog("[SingleRouteView] RouteResult is nil. Not reloading view")
            return
        }

        guard let busOption = model.busRoutes.first else {
            NSLog("[SingleRouteView] No option to display. Not reloading view")
            return
        }

        lblOriginAddress.text = "\(busOption.startBusStopStreetName) \(busOption.startBusStopStreetNumber)"
        lblDestinationAddress.text = "\(busOption.destinationBusStopStreetName) \(busOption.destinationBusStopStreetNumber)"

    }

    func updateViewWithRoadInfo(){
        guard let roadModel = roadResultModel else {
            NSLog("[SingleRouteView] RoadResult is nil. Not updating view")
            return
        }

        lblTravelDistance.text = roadModel.formattedTravelDistance()
        lblTravelDistance.alpha = 1.0
        lblTravelTime.text = roadModel.formattedTravelTime()
        lblTravelTime.alpha = 1.0


        let walkDistanceToOrigin: Double = roadModel.walkingRoutes.first?.distance ?? 0.0
        let walkDistanceToDestination: Double = roadModel.walkingRoutes.last?.distance ?? 0.0


        UIView.animate(withDuration: 0.2, animations: {
            if walkDistanceToOrigin < 100.0 {
                self.lblWalkDistanceToOrigin.alpha = 0
                self.lblWalkDistanceToOrigin.text = ""
                self.destinationToOriginHeightConstraint.constant = 13
            }else{
                self.lblWalkDistanceToOrigin.alpha = 1
                self.lblWalkDistanceToOrigin.text = "Desde origen: \(roadModel.formattedWalkingDistance(walkDistanceToOrigin))"
                self.destinationToOriginHeightConstraint.constant = 23
            }

            if walkDistanceToDestination < 100.0 {
                self.lblWalkDistanceToDestination.alpha = 0
                self.lblWalkDistanceToDestination.text = ""
            }else{
                self.lblWalkDistanceToDestination.alpha = 1
                self.lblWalkDistanceToDestination.text = "Hasta destino: \(roadModel.formattedWalkingDistance(walkDistanceToDestination))"
            }

            self.layoutIfNeeded()
        })


    }

    func preferredHeight() -> CGFloat {
       return viewHeight
    }

}
