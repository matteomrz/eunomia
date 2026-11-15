//
//  Logger.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import OSLog

extension Logger {
  private static var subsystem: String = Bundle.main.bundleIdentifier!

  static let visual = Logger(subsystem: subsystem, category: "visual")
  static let logical = Logger(subsystem: subsystem, category: "logical")
}
