//
//  ImageUtil.swift
//  Redirector
//
//  Created by 박상원 on 7/8/24.
//

import Cocoa

class ImageUtil {
  /// Convert NSImage to Data type
  static func convertNSImageToData(_ image: NSImage) -> Data? {
    guard let tiffRepresentation = image.tiffRepresentation else { return nil }
    guard let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation) else {
      return nil
    }
    
    return bitmapImageRep.representation(using: .png, properties: [:])
  }
  
  static func getIcon(application: String) -> NSImage? {
    guard let path = NSWorkspace.shared.fullPath(forApplication: application)
    else { return nil }
    
    return getIcon(file: path)
  }
  
  static func getIcon(file path: String) -> NSImage? {
    guard FileManager.default.fileExists(atPath: path)
    else { return nil }
    
    return NSWorkspace.shared.icon(forFile: path)
  }
  
  static func getIcon(bundleID: String) -> NSImage? {
    guard let path = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: bundleID)
    else { return nil }
    
    return getIcon(file: path)
  }
}
