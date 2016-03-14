//
//  GitSourcePublic.swift
//  Buildasaur
//
//  Created by Honza Dvorsky on 12/12/2014.
//  Copyright (c) 2014 Honza Dvorsky. All rights reserved.
//

import Foundation
import BuildaUtils
import Keys
import ReactiveCocoa
import Result

typealias BuildasaurKeys = BuildasaurxcodeprojKeys

public enum GitServiceType: String {
    case GitHub = "github"
    case BitBucket = "bitbucket"
    case BitBucketEnterprise = "bitbucketenterprise"
    //    case GitLab = "gitlab"
}

public protocol GitService {
    func serviceType() -> GitServiceType
    func prettyName() -> String
    func logoName() -> String
    func hostname() -> String
    func baseURL() -> NSURL
    func authorizeUrl() -> String
    func accessTokenUrl() -> String
    func serviceKey() -> String
    func serviceSecret() -> String
}

public extension GitService {
}


public struct GitHubService: GitService {
    
    public init() {
    }
    
    public func serviceType() -> GitServiceType {
        return .GitHub
    }
    
    public func prettyName() -> String {
        return "GitHub"
    }
    
    public func logoName() -> String {
        return "github"
    }
    
    public func hostname() -> String {
        return baseURL().host!
    }
    
    public func baseURL() -> NSURL {
        return NSURL(string:"http://github.com")!
    }
    
    public func authorizeUrl() -> String {
        return "https://github.com/login/oauth/authorize"
    }
    
    public func accessTokenUrl() -> String {
        return "https://github.com/login/oauth/access_token"
    }
    
    public func serviceKey() -> String {
        return BuildasaurKeys().gitHubAPIClientId()
    }
    
    public func serviceSecret() -> String {
        return BuildasaurKeys().gitHubAPIClientSecret()
    }
}

public struct BitBucketService: GitService {
    
    public init() {
    }
    
    public func serviceType() -> GitServiceType {
        return .BitBucket
    }
    
    public func prettyName() -> String {
        return "BitBucket"
    }
    
    public func logoName() -> String {
        return "bitbucket"
    }
    
    public func hostname() -> String {
        return baseURL().host!
    }
    
    public func baseURL() -> NSURL {
        return NSURL(string:"http://bitbucket.org")!
    }
    
    public func authorizeUrl() -> String {
        return "https://bitbucket.org/site/oauth2/authorize"
    }
    
    public func accessTokenUrl() -> String {
        return "https://bitbucket.org/site/oauth2/access_token"
    }
    
    public func serviceKey() -> String {
        return BuildasaurKeys().bitBucketAPIClientId()
    }
    
    public func serviceSecret() -> String {
        return BuildasaurKeys().bitBucketAPIClientSecret()
    }
}

public struct BitBucketEnterpriseService: GitService {
    public let _baseURL: NSURL
    public init() {
        self.init(baseURL:"")
    }
    
    public init(baseURL: String) {
        self._baseURL = NSURL(string:baseURL)!
    }
    
    public func serviceType() -> GitServiceType {
        return .BitBucketEnterprise
    }
    
    public func prettyName() -> String {
        return "BitBucket Enterprise"
    }
    
    public func logoName() -> String {
        return "bitbucket"
    }
    
    public func hostname() -> String {
        return _baseURL.host!
    }
    
    public func baseURL() -> NSURL {
        return _baseURL
    }
    
    public func repoName() -> String {
        let pathComponents = _baseURL.pathComponents!
        let serviceRepoName = "\(pathComponents[1])/\(pathComponents[2].componentsSeparatedByString(".")[0])"
        return serviceRepoName
    }
    
    public func authorizeUrl() -> String {
        return ""
    }
    
    public func accessTokenUrl() -> String {
        return ""
    }
    
    public func serviceKey() -> String {
        return BuildasaurKeys().bitBucketEnterpriseUsername()
    }
    
    public func serviceSecret() -> String {
        return BuildasaurKeys().bitBucketEnterprisePassword()
    }

}

public class GitServer<T: GitService> : HTTPServer {
    
    let service: T
    
    public func authChangedSignal() -> Signal<ProjectAuthenticator?, NoError> {
        return Signal.never
    }
    
    init(service: T, http: HTTP? = nil) {
        self.service = service
        super.init(http: http)
    }
}

