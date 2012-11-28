#import "SIDWebSocket.h"
#import "SBJson.h"
#import "Constant.h"
#import "SRWebSocket.h"
#import "AppDelegate.h"
#import "SIDUser.h"

@implementation SIDWebSocket
@synthesize ws;
@synthesize session_id;
@synthesize pinHash;
@synthesize toAcceptPinHash;
static int try_count = 0;

#pragma mark Web Socket
-(NSDictionary *)decryptProxy:(NSDictionary *)encryptedMessage{
    return [encryptedMessage objectForKey:@"message"];
}
-(NSDictionary *)encryptProxy:(NSDictionary *)uncryptedMessage{
    return @{@"message":uncryptedMessage};
}


- (void) start:(NSString *)_session_id
{
    currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:EM_WS_SERVER_URL]];
    ws = [[SRWebSocket alloc] initWithURLRequest:request];
    ws.delegate = self;
    self.session_id = _session_id;
    [ws open];
}

-(void)sendMessage:(NSDictionary *)temp_dict {
    NSMutableDictionary *to_send = [[NSMutableDictionary alloc] initWithDictionary:temp_dict];
    if(pinHash != nil){
        NSMutableDictionary *args = [[NSMutableDictionary alloc] initWithDictionary:[to_send objectForKey:@"args"]];
        [args setValue:pinHash forKey:@"pin_hash"];
        [to_send setValue:args forKey:@"args"];
    }
    [ws send:[to_send JSONRepresentation]];
}

-(void)proxyMessage:(NSDictionary *)message {
    NSDictionary *encryptedMessage = [self encryptProxy:message];
    NSMutableDictionary *to_send = [[NSMutableDictionary alloc] initWithDictionary:@{@"cmd":@"proxy",@"args":encryptedMessage}];
    [self sendMessage:to_send];
}


-(void)send:(NSString *)message{
    if([ws readyState] == SR_OPEN){
        //        PPLog(@"sending message %@", message);
        [ws send:message];
    }else{
        //        PPLog(@"Cant send message %@", message);
    }
}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    PPLog(@":( Websocket Failed With Error %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSloginDidFailed" object:nil];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    PPLog(@"--");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSloginDidClose" object:nil];
    
}



#pragma mark Lifecycle

- (void)dealloc
{
	PPLog(@"--");
}



#pragma mark Web Socket
/**
 * Called when the web socket connects and is ready for reading and writing.
 **/
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    PPLog(@"Open web sockect for %@", session_id);
    NSDictionary *connect = @{@"cmd":@"connect",@"args":@{@"session_type":@"user",@"session_id":session_id}};
    [webSocket send:[connect JSONRepresentation]];
    
}

/**
 * Called when the web socket receives a message.
 **/
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)aMessage;
{
    
    //    PPLog(@"-- %@",aMessage);
    NSDictionary *json = [[aMessage dataUsingEncoding:NSUTF8StringEncoding] JSONValue];
    NSString *cmd = [json objectForKey:@"cmd"];
    NSDictionary *args = [json objectForKey:@"args"];
    PPLog(@"-- %@",aMessage);
    
    if([cmd isEqualToString:@"AuthentificationSucceed"]){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:CONNECTED];
        try_count=0;
        return;
    }
    if([cmd isEqualToString:@"ask_pin_code"]){
        currentUser.pin_code = [args objectForKey:@"pin_code"];
        toAcceptPinHash=[args objectForKey:@"pin_hash"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifAskPinCode object:nil userInfo:args];
        return;
    }

    if([cmd isEqualToString:@"proxy"]){
        NSDictionary *message = [self decryptProxy:args];
        NSString *cmd = [message objectForKey:@"cmd"];
        NSDictionary *args = [message objectForKey:@"args"];
        
        NSString *notifName = [NSString stringWithFormat:@"NOTIF_%@",cmd];
        [[NSNotificationCenter defaultCenter] postNotificationName:notifName object:nil userInfo:args];
        return;
    }

    
}

///**
// * Called when pong is sent... For keep-alive optimization.
// **/
//- (void) didSendPong:(NSData*) aMessage
//{
//	PPLog(@"--");
//}

@end