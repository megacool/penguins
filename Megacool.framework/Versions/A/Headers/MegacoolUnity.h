//
//  MegacoolUnity.h
//  Megacool
//
//  Created by Nicolaj Broby Petersen on 4/26/16.
//  Copyright © 2016 Nicolaj Broby Petersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Megacool.h"

@interface MegacoolUnityDelegate : NSObject<MCLDelegate>
@end

typedef struct MegacoolLinkClickedEvent {
    int isFirstSession;
    const char *userId;
    const char *shareId;
    const char *url;
} MegacoolLinkClickedEvent;

typedef struct MegacoolReceivedShareOpenedEvent {
    const char *userId;
    const char *shareId;
    int state;
    double createdAt;
    double updatedAt;
    const void *dataBytes;
    int dataLength;
    const char *url;
    int isFirstSession;
} MegacoolReceivedShareOpenedEvent;

typedef struct MegacoolSentShareOpenedEvent {
    const char *userId;
    const char *shareId;
    int state;
    double createdAt;
    double updatedAt;
    const char *receiverUserId;
    const char *url;
    int isFirstSession;
    const void *eventDataBytes;
    int eventDataLength;
} MegacoolSentShareOpenedEvent;

typedef struct MegacoolUnityShare {
    const char *userId;
    const char *shareId;
    int state;
    double createdAt;
    double updatedAt;
    const void *dataBytes;
    int dataLength;
} MegacoolUnityShare;

typedef struct Crop {
    float x;
    float y;
    float width;
    float height;
} Crop;

typedef void (*MegacoolDidCompleteShareDelegate)();
typedef void (*MegacoolDidDismissShareViewDelegate)();
typedef void (*EventHandlerDelegate)(const void *, int);
typedef void (*OnLinkClickedEvent)(MegacoolLinkClickedEvent);
typedef void (*OnReceivedShareOpenedEvent)(MegacoolReceivedShareOpenedEvent);
typedef void (*OnSentShareOpenedEvent)(MegacoolSentShareOpenedEvent);
typedef void (*OnRetrievedShares)(MegacoolUnityShare[], int);

MegacoolUnityDelegate *unityDelegate;
MegacoolDidCompleteShareDelegate megacoolDidCompleteShare;
MegacoolDidDismissShareViewDelegate megacoolDidDismissShare;
OnLinkClickedEvent onLinkClickedEvent;
OnReceivedShareOpenedEvent onReceivedShareOpenedEvent;
OnSentShareOpenedEvent onSentShareOpenedEvent;
OnRetrievedShares onRetrievedShares;

UIView *unityView() { return [UIApplication sharedApplication].keyWindow.rootViewController.view; }

MegacoolUnityDelegate *megacoolUnityDelegate() {
    if (unityDelegate == nil) {
        unityDelegate = [[MegacoolUnityDelegate alloc] init];
    }
    return unityDelegate;
}

void startWithAppConfig(const char *appConfig);

void startRecording();

void startRecordingWithConfig(const char *recordingId, Crop crop, int maxFrames, int frameRate);

void manualApplicationDidBecomeActive();

void captureFrame();

void captureFrameWithConfig(const char *recordingId, const char *overflowStrategy, Crop crop,
                            BOOL forceAdd, int maxFrames, int frameRate);

void pauseRecording();

void stopRecording();

void renderPreviewOfGif();

void renderPreviewOfGifWithConfig(const char *recordingId, Crop previewFrame);

void removePreviewOfGif();

void openShareModal();

void openShareModalWithConfig(const char *recordingId, const char *lastFrameOverlay,
                              const char *fallbackImageURL, const char *fallbackImage,
                              const char *url, const char *jsonData);

void setSharingText(const char *text);

const char *getSharingText();

void setFrameRate(float frameRate);

float getFrameRate();

void setPlaybackFrameRate(float frameRate);

float getPlaybackFrameRate();

void setMaxFrames(int maxFrames);

int getMaxFrames();

void setMaxFramesOnDisk(int maxFrames);

int getMaxFramesOnDisk();

void setLastFrameDelay(int lastFrameDelay);

int getLastFrameDelay();

void setDebugMode(BOOL debugMode);

BOOL getDebugMode();

void setKeepCompletedRecordings(BOOL keep);

void deleteRecording(const char *recordingId);

void deleteShares(bool (*filter)(MegacoolUnityShare share));

void submitDebugDataWithMessage(const char *message);
