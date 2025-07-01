//
//  MHTypes.h
//  MHAdSDK
//
//  Created by Abenx on 2021/11/29.
//

#ifndef MHTypes_h
#define MHTypes_h


typedef NS_ENUM(NSInteger, MHAdDataMode) {
    MHAdDataModeAPI = 0,
    MHAdDataModeSDK = 1,
};

typedef NS_ENUM(NSInteger, MHAdDataMediaID) {
    MHAdDataMediaIDAPI = 0,
    MHAdDataMediaIDGDT = 1,
    MHAdDataMediaIDPangle = 2,
    MHAdDataMediaIDBaidu = 8,
    MHAdDataMediaIDLenovo = 10,
    MHAdDataMediaIDSougouQidian = 12,
    MHAdDataMediaIDKS = 14,
    MHAdDataMediaIDXiaoMi = 15,
    MHAdDataMediaIDOPPO = 16,
    MHAdDataMediaIDInMobi = 17,
    MHAdDataMediaIDIQiYi = 18,
    MHAdDataMediaIDJD = 19,
    MHAdDataMediaIDSougouUnit = 20,
    MHAdDataMediaIDMH = 99,
};

typedef NS_ENUM(NSInteger, MHAdDataPlatformPosType) {
    MHAdDataPlatformPosTypeBanner = 1,
    MHAdDataPlatformPosTypeSplash = 2,
    MHAdDataPlatformPosTypeInterstitial = 3,
    MHAdDataPlatformPosTypeNative = 4,
    MHAdDataPlatformPosTypeNativeVideo = 5,
    MHAdDataPlatformPosTypeStream = 6,
    MHAdDataPlatformPosTypeNative2 = 7,
    MHAdDataPlatformPosTypeNativeTemplate = 8,
    MHAdDataPlatformPosTypeFullscreenVideo = 9,
    MHAdDataPlatformPosTypeVideoUnion = 10,
    MHAdDataPlatformPosTypeRewardedVideo = 11,
    MHAdDataPlatformPosTypeVideoUnionComponent = 12,
    MHAdDataPlatformPosTypePreMovie = 13,
};

typedef NS_ENUM(NSInteger, MHAdDataPlatformPosTypeNativeSubPosType) {
    MHAdDataPlatformPosTypeNativeSubPosTypeImage = 0,
    MHAdDataPlatformPosTypeNativeSubPosTypeVideo = 1,
    MHAdDataPlatformPosTypeNativeSubPosTypeImageAndVideo = 2,
    MHAdDataPlatformPosTypeNativeSubPosTypeTemplate = 3,
};

#endif /* MHTypes_h */
