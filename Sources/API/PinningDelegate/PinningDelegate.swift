//
//  PinningDelegate.swift
//  Pods-TinkoffIDExample
//
//  Created by Aleksandr Moskalyuk on 18.05.2023.
//

import Foundation
import TCSSSLPinning

protocol IPinningDelegate {
    func configure()
}

final class PinningDelegate: NSObject, IPinningDelegate {
    
    // MARK: - Dependencies
    
    private var httpPublicKeyPinningService: IHTTPPublicKeyPinningService {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let bundleID = Bundle.main.bundleIdentifier?.description ?? "ru.tinkoff.id"
        let configuration = HPKPServiceConfiguration(
            hostAndPinsURL: HPKPServiceConstants.Configuration.productionHostAndPinsURL,
            untrustedConnectionPolicy: .continue,
            cachedHostsAndPinsDefaultsKey: "\(bundleID).hostsandpins",
            appParameters: AppParameters(
                version: version ?? "1.0",
                origin: "origin"
            )
        )
        let hpkpService = HPKPServiceAssembly.createHPKPPinningService(with: configuration)
        return hpkpService
    }
    
    // MARK: - IPinningDelegate
    
    func configure() {
        httpPublicKeyPinningService.configure()
        // TODO: Check how to call from AppDelegate?
        httpPublicKeyPinningService.updateHostsAndPins()
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
