#import "SRWebSocket.h"

@class SIDUser;
@interface SIDWebSocket : NSObject <SRWebSocketDelegate>
{
    
@private
    SRWebSocket *ws;
    NSString *session_id;
    NSString *toAcceptPinHash;
    NSString *pinHash;
    SIDUser *currentUser;
}

@property (nonatomic, strong)  SRWebSocket *ws;
@property (nonatomic, strong)  NSString *session_id;
@property (nonatomic, strong)  NSString *pinHash;
@property (nonatomic, strong)  NSString *toAcceptPinHash;

//@property (nonatomic, weak)  SIDUser *currentUser;


-(void) start:(NSString *)session_id;
-(void)send:(NSString *)message;
-(void)sendMessage:(NSDictionary *)message;
-(void)proxyMessage:(NSDictionary *)message;



@end