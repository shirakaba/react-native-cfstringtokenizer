//
//  RNCFStringTokenizer.swift
//  RNCFStringTokenizer
//
//  Created by Jamie Birch (shirakaba) on 17/05/2018.
//  Copyright © 2018 Jamie Birch. All rights reserved.
//

import Foundation

@objc(RNCFStringTokenizer)
class RNCFStringTokenizer: NSObject {
    
  // If using 'static' modifier, error: `Exception 'copyBestStringLanguage:(NSString *)string :(NSString *)length is not a recognized Objective-C method.' was thrown while invoking copyBestStringLanguage on target CalendarManager with params`
  // @objc static func copyBestStringLanguage(string: CFStringRef, range: CFRange) -> CFStringRef {
  @objc func copyBestStringLanguage(_ string: String, _ length: NSNumber) -> String {
    // TODO: if(is NSNull) use defaultLength
    // let defaultLength: CFIndex = string.utf16.count
    // return CFStringTokenizerCopyBestStringLanguage(string as CFString, CFRange(location: 0, length: CFIndex(truncating: length)))! as String
    let str: String = CFStringTokenizerCopyBestStringLanguage(string as CFString, CFRange(location: 0, length: CFIndex(truncating: length)))! as String
    // let index: CFIndex = CFIndex(truncating: length)
    // let index: CFIndex = CLong(truncating: length.intValue)
    // let index: Int = length.intValue
    // let str: String = CFStringTokenizerCopyBestStringLanguage(string as CFString, CFRange(location: 0, length: length.intValue))! as String
    NSLog("Best string language determined to be: %@", str)
    return str
  } 
}
