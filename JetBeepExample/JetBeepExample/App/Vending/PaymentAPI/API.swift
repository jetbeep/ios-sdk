//
//  API.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 10.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//
import Foundation
import JetBeepFramework

class API {

    let baseURL: URL

    init(basePath: String = jetbeepProdPaymentPath) throws {
        guard let url = URL(string: basePath) else {
            throw ApiError.wrongUrl
        }

        self.baseURL = url
    }

    static let apiVersion = "v1.0"
    static let jetbeepDevPaymentPath = "https://dev.jetbeep.com/api/\(API.apiVersion)/payments"
    static let jetbeepProdPaymentPath = "https://prod.jetbeep.com/api/\(API.apiVersion)/payments"

    // You need to add your Psp-api-key
    static var headers: [String: String] =
    ["Application-Auth": JetbeepSDK.config.appTokenKey,
     "Psp-api-key": "",
     "Content-Type": "application/json"]

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    func call(_ method: HTTPMethod, at url: String, headers: [String: String], body: Data) async throws -> (Data, URLResponse) {
        let request = instantiateRequest(url: baseURL.appendingPathComponent(url), method: method, headers: headers, body: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Response: \(response)")
        return (data, response)
    }

    private func instantiateRequest(url: URL, method: HTTPMethod, headers: [String: String], body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        print("Headers: \(headers)")
        print("Body: \(String(describing: String(data: body ?? Data(), encoding: .utf8)))")

        for (headerField, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        print("Request: \(request)")
        return request
    }

}
