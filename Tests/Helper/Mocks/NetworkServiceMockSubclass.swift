//
//  MockNetworkService2.swift
//  Hyperspace-iOS
//
//  Created by Adam Brzozowski on 1/31/18.
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
@testable import Hyperspace

class NetworkServiceMockSubclass: NetworkService {
    
    private(set) var initWithSessionNetworkActivityControllerWasCalled = false
    
    override init(session: NetworkSession, networkActivityController: NetworkActivityController?) {
        initWithSessionNetworkActivityControllerWasCalled = true
        super.init(session: session, networkActivityController: networkActivityController)
    }
}
