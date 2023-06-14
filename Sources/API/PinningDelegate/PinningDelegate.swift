//
//  PinningDelegate.swift
//  Pods-TinkoffIDExample
//
//  Created by Aleksandr Moskalyuk on 18.05.2023.
//

import Foundation
import TCSSSLPinning

protocol IPinningDelegate {}

final class PinningDelegate: NSObject, IPinningDelegate {
    
    // MARK: - Dependencies
    
    private var httpPublicKeyPinningService: IHTTPPublicKeyPinningService
    
    // MARK: - Lifestyle
    
    init(hostAndPinsURL: String?) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let bundleID = Bundle.main.bundleIdentifier?.description ?? "ru.tinkoff.id"
        let configuration = HPKPServiceConfiguration(hostAndPinsURL: URL(string: hostAndPinsURL ?? "") ?? HPKPServiceConstants.Configuration.productionHostAndPinsURL,
                                                     untrustedConnectionPolicy: .continue,
                                                     cachedHostsAndPinsDefaultsKey: "\(bundleID).hostsandpins",
                                                     appParameters: AppParameters(version: version ?? "1.0", origin: "origin"))
        self.httpPublicKeyPinningService = HPKPServiceAssembly.createHPKPPinningService(with: configuration)
        
        self.httpPublicKeyPinningService.configure()
        self.httpPublicKeyPinningService.updateHostsAndPins()
        
        super.init()
    }
}

// MARK: - URLSessionDelegate

extension PinningDelegate: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        httpPublicKeyPinningService.urlSession?(session, didBecomeInvalidWithError: error)
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        httpPublicKeyPinningService.urlSession?(session,
                                                didReceive: challenge,
                                                completionHandler: completionHandler)
        
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        httpPublicKeyPinningService.urlSessionDidFinishEvents?(forBackgroundURLSession: session)
    }
}
