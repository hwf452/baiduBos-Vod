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

#import <Foundation/Foundation.h>

/**
 Media Attributes Object.
 */
@interface VODMediaAttributes : NSObject

/**
 Media title.
 */
@property(nonatomic, copy) NSString* mediaTitle;

/**
 Media description.
 */
@property(nonatomic, copy) NSString* mediaDescription;
@end

/**
 Media metadata. Include original size, total size and duration.
 */
@interface VODMediaMetadata : NSObject

/**
 Media original size in bytes.
 */
@property(nonatomic, assign) uint64_t sourceSizeInBytes;

/**
 Media total size on BOS, include original file, files after transcoding, thumbnails.
 */
@property(nonatomic, assign) uint64_t sizeInBytes;

/**
 Media duration in seconds.
 */
@property(nonatomic, assign) uint64_t durationInSeconds;
@end

/**
 Media playable url.
 */
@interface VODPlayableURL : NSObject

/**
 The transcoding preset name of the media file which the url point to.
 */
@property(nonatomic, copy) NSString* transcodingPresetName;

/**
 The media file's url.
 */
@property(nonatomic, copy) NSString* url;
@end

/**
 The media status means internal processing. It's an intermediate state.
 */
extern NSString* const kVODMediaStatusProcessing;

/**
 The media status means process is running.
 */
extern NSString* const kVODMediaStatusRunning;

/**
 The media status means process failed.
 */
extern NSString* const kVODMediaStatusFailed;

/**
 The media status means the media has been published.
 */
extern NSString* const kVODMediaStatusPublished;

/**
 The media status means the media is disabled.
 */
extern NSString* const kVODMediaStatusDisabled;

/**
 The media status means the media is banned.
 */
extern NSString* const kVODMediaStatusBanned;
