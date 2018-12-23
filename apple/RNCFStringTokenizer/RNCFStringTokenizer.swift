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
  // Here we don't use the override keyword, because we're inheriting just from NSObject.
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  /** API very much still under construction! TODO: should probably handle these as NSString instead */
  @objc func copyBestStringLanguage(
    _ string: String,
    _ length: NSNumber,
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
    let str: String = CFStringTokenizerCopyBestStringLanguage(string as CFString, CFRange(location: 0, length: CFIndex(truncating: length)))! as String
    NSLog("Best string language determined to be: %@", str)
    return resolve(str)
  } 

  /** API very much still under construction! */
  @objc func transliterate(
    _ input: String,
    _ localeIdentifier: String,
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
    let inputText: NSString = input as NSString
    let range: CFRange = CFRangeMake(0, inputText.length)
    let targetLocale: NSLocale = NSLocale(localeIdentifier: localeIdentifier)
    let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, targetLocale)
    var originals = [String]()
    var transliterations = [String]()
    
    var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
    
    while (tokenType != .none) {
        if let attribute: CFTypeRef = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) {
            let original: String = CFStringCreateWithSubstring(kCFAllocatorDefault, inputText as CFString, CFStringTokenizerGetCurrentTokenRange(tokenizer)) as String
            originals.append(original)
            let transliteration: String = attribute as! String
            transliterations.append(transliteration)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        } else {
            break;
        }
    }
    
    NSLog("Generated transliterations: %@", transliterations)
    
    return resolve(transliterations)
  }
}
