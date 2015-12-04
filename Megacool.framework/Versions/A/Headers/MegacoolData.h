//
//  MegacoolDataQueue.h
//
//  Created by Nicolaj Broby Petersen on 10/20/15.
//

#import <Foundation/Foundation.h>
#import "Megacool.h"

@protocol MegacoolEventQueueDelegate;

@protocol MegacoolEventQueueDelegate <NSObject>

- (void)setReferralLink:(NSString*)referralLink;
- (void)setSharingURLPath:(NSString *)urlPath;

@end

@interface MegacoolData : NSObject

@property (nonatomic, weak) id <MegacoolEventQueueDelegate> delegate;

-(void) addEventToQueue:(NSDictionary*)data;
-(void)setSecret: (NSString* ) appSecret;
- (void)createEvent:(NSString *)event;
- (void)createEvent:(NSString *)event withData:(NSDictionary *)data;
- (void)sendRegisterDeviceEvent: (NSString *) event withData: (NSDictionary *) eventData;
- (void)flushInMemoryEventsToDisk;
- (void)synchronouslyFlushInMemoryEventsToDisk;

- (void)requestGIFUploadURL:(NSURL *)gifURL withSharingId:(NSString *)sharingId;

@end
