//
//  _Types.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

protocol OpeningType {func pushOpenController(dataController: DataController, location: CLLocation)}
protocol SearchByMapType {func pushSearchByMap(dataController: DataController, location: CLLocation)}
protocol SearchByAddressType {func pushSearchByAddress(dataController: DataController, location: CLLocation)}
protocol SettingsType {func handleSettings(dataController: DataController, delegate: UnBlurViewProtocol, max: Int?)}
protocol BarButtonToOpeningType {func handleNext(dataController: DataController, location: CLLocation)}
protocol BusinessDetailsType{func handleBusinessDetails(currentBusiness: Business)}
protocol OpenAppleMapType{func handleMapItButton(currentLocation: CLLocationCoordinate2D)}
protocol OpenInSafariType {func handleOpenBrowser(urlString: String)}
protocol FilterType{func handleFilter(unblurProtocol: UnBlurViewProtocol)}
protocol OpenPhoneType {func handlePhoneNumber(numberString: String)}
protocol TabControllerType {func handleTabController(businesses: [Business], categoryName: String)}
protocol DismissControllerType {func handleDismiss()}

