//
//  PubNubManager.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import Foundation
import PubNub

final class PubNubManager: NSObject, PNObjectEventListener {
  static let sharedInstance = PubNubManager()
  
  private (set) var kartClient: PubNub?
  
  private override init() {
    super.init()
    let configuration = PNConfiguration(publishKey: "pub-c-691ce7ce-f922-4572-a90f-7287cd7c5df6", subscribeKey: "sub-c-9700ed8c-be38-11e6-8036-0619f8945a4f")
    
    self.kartClient = PubNub.clientWithConfiguration(configuration)
    self.kartClient?.addListener(self)
    self.kartClient?.subscribeToChannels(["run-channel"], withPresence: false)
  }
  
  func publishMessage(message: AnyObject, onChannel channel: String, withCompletion completion: PNPublishCompletionBlock?) {
    kartClient?.publish(message, toChannel: channel, withCompletion: completion)
  }
  
//  func subscribeToMyChannels() {
//    self.kartClient?.subscribeToChannels(["run-channel"], withPresence: false)
//  }
  
//  func unsubscribeFromChannels() {
//    self.kartClient?.unsubscribeFromAll()
//  }
  
//  func subscribeToPushWithDeviceId(deviceToken: NSData) {
//    self.client?.addPushNotificationsOnChannels([
//      getChannelName(.UserChannel),
//      getChannelName(.TeamChannel),
//      getChannelName(.RankingsChannel),
//      getChannelName(.GameChannel)
//      ], withDevicePushToken: deviceToken,
//         andCompletion: { (status) -> Void in
//          
//          if !status.error {
//            print("successful push to test channel activated")
//            // Handle successful push notification enabling on passed channels.
//          }
//          else {
//            let alert = UIAlertController(title: "No Push Note Register", message: "Failed to register for push notifications. Category = \(status.category). Error = \(status.error)", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            #if Local
//              UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
//            #endif
//            #if Staging
//              UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
//            #endif
//            
//            print("Failed for some reason. \(status.error)")
//            // Handle modification error. Check 'category' property
//            // to find out possible reason because of which request did fail.
//            // Review 'errorData' property (which has PNErrorData data type) of status
//            // object to get additional information about issue.
//            //
//            // Request can be resent using: status.retry()
//          }
//    })
//  }
  
  func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
    if let channel = message.data.subscribedChannel {
      guard let myMessage = message.data.message as? [String: AnyObject] else {
        assertionFailure("Channel message not formatted correctly. Fix it. Msg: \(message.data.message)")
        return
      }
      
      print("Received message: \(message.data.message) on channel " +
        "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
        "\(message.data.timetoken)")
      
      NSNotificationCenter.defaultCenter().postNotificationName(KartNotificationNewUserLocationReceived, object: message.data.message)
    }
  }
  
  //TODO: check and handle PubNub client events?
  func client(client: PubNub, didReceiveStatus status: PNStatus) {
    if status.category == .PNUnexpectedDisconnectCategory {
      // This event happens when radio / connectivity is lost
      print("This event happens when radio / connectivity is lost")
    }
    else if status.category == .PNConnectedCategory {
      // Connect event. You can do stuff like publish, and know you'll get it.
      // Or just use the connected event to confirm you are subscribed for
      // UI / internal notifications, etc
    }
    else if status.category == .PNReconnectedCategory {
      
      // Happens as part of our regular operation. This event happens when
      // radio / connectivity is lost, then regained.
    }
    else if status.category == .PNDisconnectedCategory {
      
      // Disconnection event. After this moment any messages from unsubscribed channel
      // won't reach this callback.
    }
    else if status.category == .PNDecryptionErrorCategory {
      
      // Handle messsage decryption error. Probably client configured to
      // encrypt messages and on live data feed it received plain text.
    }
  }
  
}