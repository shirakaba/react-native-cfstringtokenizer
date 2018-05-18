//
//  RCTCFStringTokenizer.swift
//  RCTCFStringTokenizer
//
//  Created by jamie on 17/05/2018.
//  Copyright © 2018 Bottled Logic. All rights reserved.
//

import Foundation

@objc(RCTCFStringTokenizer)
class RCTCFStringTokenizer: NSObject {
    
    @objc func addEvent(name: String, location: String, date: NSNumber) -> Void {
        // Date is ready to use!
    }

    // @objc static func copyBestStringLanguage(string: CFStringRef, range: CFRange) -> CFStringRef {
    @objc static func copyBestStringLanguage(_ string: String, _ length: NSNumber) -> String? {
        return CFStringTokenizerCopyBestStringLanguage(string, CFRange(location: 0, length: length));
    }
    
}
