//
//  TransportApiClientSettings.swift
//  Pods
//
//  Created by Bilo on 1/24/17.
//
//

import Foundation

public class TransportApiClientSettings
{
    public private(set) var clientId: String
    public private(set) var clientSecret: String
    public private(set) var timeoutInSeconds = 30
    
    public init(clientId: String, clientSecret: String){
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    public convenience init(clientId: String, clientSecret: String, timeoutInSeconds: Int)
    {
        self.init(clientId: clientId, clientSecret: clientSecret)
        self.timeoutInSeconds = timeoutInSeconds
    }
}
