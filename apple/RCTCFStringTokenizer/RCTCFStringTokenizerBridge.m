//
//  JBCFStringTokenizerBridge.m
//  JBCFStringTokenizer
//
//  Created by jamie on 17/05/2018.
//  Copyright © 2018 Bottled Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RCTCFStringTokenizer, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(NSNumber *)date)

// https://stackoverflow.com/a/42874301/5951226 : "Got “is not a recognized Objective-C method” when bridging Swift to React-Native"
// https://stackoverflow.com/a/24046893/5951226 : unnamed params
// static methods are represented with + rather than -.
// https://stackoverflow.com/questions/36309596/swift-ambiguos-methods-with-variadic-paramameter
RCT_EXTERN_METHOD(copyBestStringLanguage:(NSString *)string :(NSString *)length)

@end
