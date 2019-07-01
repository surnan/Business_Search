//
//  BusinessAnnotation.swift
//  Business_Search
//
//  Created by admin on 5/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessAnnotationView: MKMarkerAnnotationView {
    var title = "Bridge Title"
    var subtitle = "Bridge SubTitle"
    var business: Business!
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "BusinessAnnotationView"
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.blue
        if let cluster = annotation as? MKClusterAnnotation {
            let total = cluster.memberAnnotations.count
            image = drawCustomBusinessAnnotationCircle(count: total)
        }
    }
    
    private func drawCustomBusinessAnnotationCircle(count: Int) -> UIImage {
        return drawCircle(color: UIColor.orange)
    }
    
    private func drawCircle(color: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            color?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
        }
    }
}
