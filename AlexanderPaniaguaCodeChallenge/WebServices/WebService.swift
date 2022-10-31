//
//  WebService.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Alamofire

final class WebService {
    
    private var sessionManager: Session = Session()
    
    private static let ws: WebService = {
        return WebService()
    }()
    
    static func shared() -> WebService {
        return self.ws
    }
    
    // Using dependency injection for unit/integration tests
    init(sessionManager: Session? = nil) {
        if let sessionManager = sessionManager {
            self.sessionManager = sessionManager
        }
        else {
            self.sessionManager = self.afManager
        }
    }
    
    lazy var afManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 90
        configuration.timeoutIntervalForResource = 90

        let devServerTrustPolicyManager = DevServerTrustPolicyManager(evaluators: [:])
        return Alamofire.Session(configuration: configuration, serverTrustManager: devServerTrustPolicyManager)
    }()
    
    private var headers: HTTPHeaders {
        var headers: [HTTPHeader] = []

        headers.append(HTTPHeader(name: "Content-Type", value: "application/json"))
        headers.append(HTTPHeader(name: "Accept", value: "application/json"))

        return HTTPHeaders(headers)
    }
    
    /// Performs a network request with given parameters, returning the desired model and indicating wheter the request has failed or succeeded
    /// - Parameter endpointUrl: The endpoint url to requests aka the API
    /// - Parameter queryString: The query parameters for the request
    /// - Parameter parameters: The body parameters for the request
    /// - Parameter httpMethod: The verb of the request
    /// - Parameter type: The desired object type
    /// - Parameter completionHandler: The completion handler that returns the desired object type and a flag indicating wheter the request has failed or succeeded
    func performRequest<T: Codable>(endpointUrl: String, queryString: String = "", parameters: [String: Any]? = nil, httpMethod: HTTPMethod = HTTPMethod.get, type: T.Type, completionHandler: @escaping (T?, Bool) -> ()) {
        var requestUrl = "\(endpointUrl)"
        var customEncoding: ParameterEncoding = URLEncoding.queryString
        
        if httpMethod == HTTPMethod.post || httpMethod == HTTPMethod.put {
            customEncoding = JSONEncoding.default
        }
        else {
            requestUrl = "\(endpointUrl)\(queryString)"
        }
        
        self.sessionManager.request(requestUrl, method: httpMethod, parameters: parameters, encoding: customEncoding, headers: self.headers).response() { response in
            switch response.result {
            case .success:
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        if let data = response.data {
                            let decodedData = data.decode(toType: type)
                            completionHandler(decodedData, true)
                        }
                        else {
                            completionHandler(nil, false)
                        }
                        break
                    default:
                        var errorMessage = ""
                        errorMessage = "\(String(statusCode)),"
                        if let data = response.data {
                            errorMessage.append(String(bytes: data, encoding: .utf8) ?? "")
                        }
                        Utils.printIfInDebugMode("Network request error: \(String(errorMessage.prefix(125)))")
                        completionHandler(nil, false)
                        break
                    }
                }
                break
            case .failure(let error as NSError):
                
                if error.code == NSURLErrorTimedOut {
                    Utils.printIfInDebugMode("Request timeout: " + error.localizedDescription)
                }
                else {
                    Utils.printIfInDebugMode("General error: " + error.localizedDescription)
                }
                
                completionHandler(nil, false)
                break
            }
        }
    }
    
}

// MARK: Extensions

// MARK: AF extensions
extension WebService {
    
    private class DevServerTrustPolicyManager: ServerTrustManager {
        override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
            return DisabledTrustEvaluator()
        }
    }
    
}
