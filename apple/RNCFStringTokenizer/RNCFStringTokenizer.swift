//
//  RNCFStringTokenizer.swift
//  RNCFStringTokenizer
//
//  Created by Jamie Birch (shirakaba) on 17/05/2018.
//  Copyright © 2018 Jamie Birch. All rights reserved.
//

import Foundation
import CoreServices

@objc(RNCFStringTokenizer)
class RNCFStringTokenizer: NSObject {
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
  
    // termsLanguageId: String, term: String, dictPointX: Float, dictPointY: Float
    @objc func lookUpTermInPopover(
      _ termsLanguageId: String,
      _ term: String,
      _ dictPointX: NSNumber,
      _ dictPointY: NSNumber,
      resolver resolve: @escaping RCTPromiseResolveBlock,
      rejecter reject: @escaping RCTPromiseRejectBlock
    )
    {
      // (in Obj-C) From http://nshipster.com/dictionary-services/
      // let definition: Unmanaged<CFString>? = DCSCopyTextDefinition(nil, term as CFString, CFRangeMake(0, (term as NSString).length))
      
      let activeDictionaries: NSArray = setPreferredDicts(["com.apple.dictionary.zh_CN-en.OCD"])
      
      // (in Swift) From https://github.com/sekimura/lookup/blob/master/lookup.swift#L45
      guard let definition: Unmanaged<CFString> = DCSCopyTextDefinition(nil, term as CFString, CFRangeMake(0, (term as NSString).length)) else {
        restorePreferredDicts(activeDictionaries)
        return reject("No definition found", "DCSCopyTextDefinition returned nil", NSError(domain: "domain", code: 0))
      }
      restorePreferredDicts(activeDictionaries)
      let value: String = definition.takeUnretainedValue() as String
      NSLog("Definition for term \"%@\": %@", term, value)
      return resolve(value)
    }
    
    // callbackIndex: Int, input: String, iFrameIndex: Int, assertTermsIdentifier: String? = nil
    
    @objc func romaniseobj(
        _ localeIdentifier: String,
        _ callbackIndex: NSNumber,
        _ input: String,
        _ iFrameIndex: NSNumber,
        //    _ assertTermsIdentifier: String? = nil,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
        ) -> Void {
        let inputText: NSString = input as NSString
        let range: CFRange = CFRangeMake(0, inputText.length)
        let targetLocale: NSLocale = NSLocale(localeIdentifier: localeIdentifier)
        let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, targetLocale)
        var originals = [String]()
        var transliterations = [String]()
        var lemmas = [String]()
        
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
        
        let pinyinjectPromiseArgs = PinyinjectPromiseArgs(
            iFrameIndex: Int(truncating: iFrameIndex),
            callbackIndex: Int(truncating: callbackIndex),
            originals: originals,
            transliterations: transliterations,
            transcriptionsToBeRequired: true,
            input: input,
            lemmas: lemmas
        )
        
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
  
//  "com.apple.dictionary.zh_CN-en.OCD",
//  "com.apple.dictionary.ODE",
//  "com.apple.dictionary.OTE",
//  "com.apple.dictionary.ja.Daijirin",
//  "com.apple.dictionary.ja-en.WISDOM",
//  "com.apple.dictionary.zh_CN.SDCC",
//  "com.apple.dictionary.ko.NewAce",
//  "com.apple.dictionary.ko-en.NewAce",
//  "com.apple.dictionary.AppleDictionary",
//  "/System/Library/Frameworks/CoreServices.framework/Frameworks/DictionaryServices.framework/Resources/Wikipedia.wikipediadictionary"
  // "/Library/Dictionaries/Oxford American Writer's Thesaurus.dictionary"
  
  func setPreferredDicts(_ dictKeys: NSArray) -> NSArray {
    let userDefaults: UserDefaults = UserDefaults.standard
    let dictionaryPreferences: NSMutableDictionary = (userDefaults.persistentDomain(forName: RNCFStringTokenizer.APPLE_DICT_SERVICES_KEY)! as NSDictionary).mutableCopy() as! NSMutableDictionary
    let activeDictionaries: NSArray = dictionaryPreferences.object(forKey: "DCSActiveDictionaries") as! NSArray
    dictionaryPreferences[RNCFStringTokenizer.ACTIVE_DICTIONARIES_KEY] = dictKeys
    userDefaults.setPersistentDomain(dictionaryPreferences as! [String : Any], forName: RNCFStringTokenizer.APPLE_DICT_SERVICES_KEY)
    
//    dictionaryPreferences["DCSActiveDictionaries"] = activeDictionaries
//    userDefaults.setPersistentDomain(dictionaryPreferences as! [String : Any], forName: "com.apple.DictionaryServices")
    
    return activeDictionaries
  }
  
  func restorePreferredDicts(_ activeDictionaries: NSArray) -> Void {
    let userDefaults: UserDefaults = UserDefaults.standard
    let dictionaryPreferences: NSMutableDictionary = (userDefaults.persistentDomain(forName: RNCFStringTokenizer.APPLE_DICT_SERVICES_KEY)! as NSDictionary).mutableCopy() as! NSMutableDictionary
    dictionaryPreferences[RNCFStringTokenizer.ACTIVE_DICTIONARIES_KEY] = activeDictionaries
    userDefaults.setPersistentDomain(dictionaryPreferences as! [String : Any], forName: RNCFStringTokenizer.APPLE_DICT_SERVICES_KEY)
  }
  
  static let APPLE_DICT_SERVICES_KEY: String = "com.apple.DictionaryServices"
  static let ACTIVE_DICTIONARIES_KEY: String = "DCSActiveDictionaries"
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
