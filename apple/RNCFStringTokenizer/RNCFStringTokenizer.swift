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
    
    // callbackIndex: Int, input: String, iFrameIndex: Int, assertTermsIdentifier: String? = nil
  
    @objc func romaniseobjBatch(
        _ localeIdentifier: String,
        _ callbackIndexes: [NSNumber],
        _ inputs: [String],
        _ iFrameIndex: NSNumber,
        _ pdf: Bool,
        //    _ assertTermsIdentifier: String? = nil,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) -> Void
    {
        let pinyinjectPromiseArgsArr: [PinyinjectPromiseArgs] = callbackIndexes.enumerated().map { (index, callbackIndex) in
            return Tokenising.tokenise(localeIdentifier, callbackIndex, inputs[index], iFrameIndex, pdf)
        }
        
        let encoder: JSONEncoder = JSONEncoder()
        if let jsonData = try? encoder.encode(pinyinjectPromiseArgsArr) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // print(jsonString)
                return resolve(jsonString)
            } else {
                return reject("JSON error", "Unable to stringify JSON", NSError(domain: "domain", code: 0))
            }
            //      return resolve(jsonData)
        } else {
            return reject("JSON error", "Unable to encode JSON", NSError(domain: "domain", code: 0))
        }
    }
    
    @objc func romaniseobj(
        _ localeIdentifier: String,
        _ callbackIndex: NSNumber,
        _ input: String,
        _ iFrameIndex: NSNumber,
        _ pdf: Bool,
        //    _ assertTermsIdentifier: String? = nil,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) -> Void
    {
        let pinyinjectPromiseArgs: PinyinjectPromiseArgs = Tokenising.tokenise(localeIdentifier, callbackIndex, input, iFrameIndex, pdf)
        // print("promise args going in: iFrameIndex: \(Int(truncating: iFrameIndex)); callbackIndex: \(Int(truncating: callbackIndex))")
        
        let encoder: JSONEncoder = JSONEncoder()
        if let jsonData = try? encoder.encode(pinyinjectPromiseArgs) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // print(jsonString)
                return resolve(jsonString)
            } else {
                return reject("JSON error", "Unable to stringify JSON", NSError(domain: "domain", code: 0))
            }
            //      return resolve(jsonData)
        } else {
            return reject("JSON error", "Unable to encode JSON", NSError(domain: "domain", code: 0))
        }
        
        //    webView!.evaluateJavaScript("window.pinyinjector.promises[\(callbackIndex)]( \(origExp), \(transExp), \(transcriptionsToBeRequiredExp), \(inputExp), \(lemmasExp) );", completionHandler: { (result: Any?, error: Error?) in
        //      if error == nil { /*print("Js execution successful");*/ }
        //      else { print("!! Tokenising.swift JS error in window for invocation:\n!! window.pinyinjector.promises[\(callbackIndex)]( \(origExp), \(transExp), \(transcriptionsToBeRequiredExp), \(inputExp), \(lemmasExp) )\n!! \(error.debugDescription))\n"); }
        //    })
    }
}

struct PinyinjectPromiseArgs: Codable {
    var iFrameIndex: Int
    var callbackIndex: Int
    var originals: [String]
    var transliterations: [String]
    var transcriptionsToBeRequired: Bool
    var input: String
    var lemmas: [String]
}
