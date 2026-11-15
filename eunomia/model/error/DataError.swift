//
//  DataError.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation

enum DataError: Error {
    case notFound(Any.Type, UUID)
}
