//
//  RNCFStringTokenizerBridge.m
//  RNCFStringTokenizer
//
//  Created by Jamie Birch (shirakaba) on 17/05/2018.
//  Copyright © 2018 Jamie Birch. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNCFStringTokenizer, NSObject)

// https://facebook.github.io/react-native/docs/native-modules-ios.html#threading
// We'll run all methods (provisionally) in their own queue to prevent blocking.
- (dispatch_queue_t)methodQueue
{
  return dispatch_queue_create("uk.co.birchlabs.RNCFStringTokenizerQueue", DISPATCH_QUEUE_SERIAL);
}

RCT_EXTERN_METHOD(
                  copyBestStringLanguage:(NSString *)string
                  :(nonnull NSNumber *)length
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
RCT_EXTERN_METHOD(
                  transliterate:(NSString *)input
                  :(NSString *)localeIdentifier
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

// Optional assertTermsIdentifier arg
RCT_EXTERN_METHOD(
                  romaniseobjBatch
                  :(NSString *)localeIdentifier
                  :(NSArray<NSNumber *>)callbackIndexes
                  :(NSArray<NSString *>)inputs
                  :(nonnull NSNumber *)iFrameIndex
                  :(BOOL)pdf
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  romaniseobj
                  :(NSString *)localeIdentifier
                  :(nonnull NSNumber *)callbackIndex
                  :(NSString *)input
                  :(nonnull NSNumber *)iFrameIndex
                  :(BOOL)pdf
                  // :(NSString *)assertTermsIdentifier
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

@end
