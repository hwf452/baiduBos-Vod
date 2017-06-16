/*
 * Copyright (c) 2016 Baidu.com, Inc. All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

#import <BaiduBCEVOD/VODMediaRelatedModel.h>

/**
 The get media request.
 */
@interface VODGetMediaRequest : VODMediaIDRelatedRequest
@end

/**
 The business error when process media.
 */
@interface VODGetMediaError : NSObject

/**
 Error code.
 */
@property(nonatomic, copy) NSString* code;

/**
 Error message.
 */
@property(nonatomic, copy) NSString* message;
@end

/**
 The get media response.
 */
@interface VODGetMediaResponse : BCEResponse

/**
 The media ID.
 */
@property(nonatomic, copy) NSString* mediaId;

/**
 The status of the media.
 */
@property(nonatomic, copy) NSString* status;

/**
 The attributes of the media.
 */
@property(nonatomic, strong) VODMediaAttributes* attributes;

/**
 The metadata of the media.
 */
@property(nonatomic, strong) VODMediaMetadata* mediaMetadata;

/**
 The business error of the media. Not nil when status is equal to kVODMediaStatusFailed.
 */
@property(nonatomic, strong) VODGetMediaError* error;

/**
 The publish time of the media.
 */
@property(nonatomic, copy) NSString* publishTime;

/**
 The create time of the media.
 */
@property(nonatomic, copy) NSString* createTime;

/**
 The transcoding preset group applied to the media.
 */
@property(nonatomic, copy) NSString* transcodingPresetGroupName;

/**
 The playable urls.
 */
@property(nonatomic, strong) NSArray<VODPlayableURL*>* playableUrlList;

/**
 The thumbnail list.
 */
@property(nonatomic, strong) NSArray<NSString*>* thumbnailList;
@end

/**
 The business error code means transcoding action failed.
 */
extern NSString* const kVODGetMediaCodeTranscodingFailed;

/**
 The business error code means thumbnail action failed.
 */
extern NSString* const kVODGetMediaCodeThumbnailFailed;

/**
 The business error code means media process timeout.
 */
extern NSString* const kVODGetMediaCodeMediaOvertime;
