//
//  _Types.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

protocol SearchTableType    {func loadSearchTable    (location: CLLocation)}
protocol SearchByMapType    {func loadSearchByMap    (location: CLLocation)}
protocol SearchByAddressType{func loadSearchByAddress(location: CLLocation)}
protocol SettingsType       {func loadSettings(delegate: UnBlurViewProtocol, max: Int?)}



protocol BusinessDetailsType{func loadBusinessDetails(currentBusiness: Business)}
protocol FilterType         {func loadFilter(unblurProtocol: UnBlurViewProtocol)}
protocol OpenPhoneType      {func loadPhoneCallScreen(number: String)}
protocol OpenInSafariType   {func loadSafariBrowser(url: String)}
protocol OpenAppleMapType   {func loadAppleMap(currentLocation: CLLocationCoordinate2D)}
protocol TabControllerType  {func loadTabController(businesses: [Business], categoryName: String)}
protocol DismissType        {func handleDismiss()}
