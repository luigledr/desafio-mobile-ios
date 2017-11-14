//
//  JVHHttpError.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

public enum JVHHTTPError: Error, ExpressibleByIntegerLiteral {
    case badRequest(description: String?)
    case unauthorized(description: String?)
    case forbidden(description: String?)
    case notFound(description: String?)
    case serverError(description: String?)
    case unprocessableRequest(description: String?)
    case unknown(description: String?)
}

// MARK: - ExpressibleByIntegerLiteral
public extension JVHHTTPError {
    public init(integerLiteral value: Int) {
        self = .init(code: value, description: nil)
    }
}

// MARK: - Init
extension JVHHTTPError {
    init(code: Int, description: String?) {
        switch code {
        case 400:
            self = .badRequest(description: description)
        case 401:
            self = .unauthorized(description: description)
        case 403:
            self = .forbidden(description: description)
        case 404:
            self = .notFound(description: description)
        case 422:
            self = .unprocessableRequest(description: description)
        case 500:
            self = .serverError(description: description)
        default:
            self = .unknown(description: description)
        }
    }
}
