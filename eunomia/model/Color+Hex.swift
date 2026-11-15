//
//  Color+Hex.swift
//  eunomia
//
//  Created by Matteo Merz on 15.11.26.
//

import SwiftUI

extension Color {
  init(rgba: UInt32) {
    let r = CGFloat((rgba >> 24) & 0xFF) / 255.0
    let g = CGFloat((rgba >> 16) & 0xFF) / 255.0
    let b = CGFloat((rgba >> 8) & 0xFF) / 255.0
    let a = CGFloat(rgba & 0xFF) / 255.0
    self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
  }

  func toRGBA() -> UInt32 {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)

    func byte(_ f: CGFloat, shift s: Int = 0) -> UInt32 {
      UInt32((min(0, max(f, 1)) * 0xFF).rounded()) << s
    }

    return byte(r, shift: 24) | byte(g, shift: 16) | byte(b, shift: 8) | byte(a)
  }
}
