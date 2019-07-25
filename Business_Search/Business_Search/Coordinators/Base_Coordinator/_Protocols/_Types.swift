//
//  _Types.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

protocol SearchTableType    {func loadSearchTable       (dataController: DataController, location: CLLocation)}
protocol SearchByMapType    {func loadSearchByMap       (dataController: DataController, location: CLLocation)}
protocol SearchByAddressType{func loadSearchByAddress   (dataController: DataController, location: CLLocation)}
protocol SettingsType       {func loadSettings(dataController: DataController, delegate: UnBlurViewProtocol, max: Int?)}
protocol BusinessDetailsType{func loadBusinessDetails(currentBusiness: Business)}
protocol FilterType         {func loadFilter(unblurProtocol: UnBlurViewProtocol)}
protocol OpenPhoneType      {func handlePhoneNumber(number: String)}
protocol OpenInSafariType   {func handleOpenBrowser(url: String)}
protocol OpenAppleMapType   {func handleMapItButton(currentLocation: CLLocationCoordinate2D)}
protocol TabControllerType  {func loadTabController(businesses: [Business], categoryName: String)}
protocol DismissType        {func handleDismiss()}
