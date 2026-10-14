//
//  MHTypes.h
//  MHAdSDK
//
//  Created by Abenx on 2021/11/29.
//

#ifndef MHTypes_h
#define MHTypes_h


typedef NS_ENUM(NSInteger, MHBiddingLossReason) {
    MHBiddingLossReasonLowPrice    = 1,     // 有广告回包，竞败(竞争力不足)
    MHBiddingLossReasonNoAd        = 2,     // 无广告回包
    MHBiddingLossReasonAdSuccNoBid = 101,   // 有回包但未竞价
    MHBiddingLossReasonOther       = 10001  // 其他
};


#endif /* MHTypes_h */
