// File: functions/index.js
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

/**
 * Cloud Function that triggers when a new message is created in any chat.
 * It sends a push notification to the other participant(s) in the chat room.
 */
exports.sendChatNotification = functions
    .runWith({timeoutSeconds: 300}) // Set timeout to 5 minutes
    .firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
      console.log("--- Function Triggered ---");
      const message = snap.data();
      const chatId = context.params.chatId;

      if (!message || !message.senderId) {
        console.log("Message data or senderId is missing.");
        return null;
      }
      console.log(`New message from ${message.senderId} in chat ${chatId}`);

      // Get the chat room document to find the participants.
      const chatRef = db.collection("chats").doc(chatId);
      const chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        console.error("Error: Chat room not found:", chatId);
        return null;
      }

      const chatData = chatDoc.data();
      const participants = chatData.participants;
      const senderId = message.senderId;
      console.log("Participants:", participants);

      // Get the sender's name for the notification.
      const senderDoc = await db.collection("users").doc(senderId).get();
      if (!senderDoc.exists) {
        console.error("Error: Sender user document not found:", senderId);
        return null;
      }
      const senderName = senderDoc.data().displayName || "Someone";
      console.log("Sender Name:", senderName);

      // Find all other participants to send notifications to.
      const recipients = participants.filter((uid) => uid !== senderId);
      if (recipients.length === 0) {
        console.log("No recipients to chatting with themselves.");
        return null;
      }
      console.log("Recipients:", recipients);

      // Get the FCM tokens for all recipients.
      const tokens = [];
      for (const recipientId of recipients) {
        const userDoc = await db
            .collection("users").doc(recipientId).get();
        if (userDoc.exists && userDoc.data().fcmToken) {
          const token = userDoc.data().fcmToken;
          console.log(`Found token for ${recipientId}: ${token}`);
          tokens.push(token);
        } else {
          console.log(`No token found for recipient: ${recipientId}`);
        }
      }

      if (tokens.length === 0) {
        console.error("Error: No valid FCM tokens found for any recipients.");
        return null;
      }

      // **THE FIX: Use the modern ` payload structure.**
      const mCMessage = {
        tokens: tokens, // The array of tokens
        notification: {
          title: `New message from ${senderName}`,
          body: message.text,
        },
        data: {
          chatId: chatId,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        android: {
          priority: "high",
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      console.log("multicast", JSON.stringify(mCMessage, null, 2));

      // Send the notification to all tokens.
      try {
        console.log("Sending multicast message to tokens:", tokens);
        const response=await admin.messaging().sendEachForMulticast(mCMessage);
        console.log(`${response.successCount} messages were sent successfully`);
        if (response.failureCount > 0) {
          const failedTokens = [];
          response.responses.forEach((resp, idx) => {
            if (!resp.success) {
              failedTokens.push(tokens[idx]);
            }
          });
          console.error("List of tokens that caused failures:", failedTokens);
        }
      } catch (error) {
        console.error("Error sending multicast message:", error);
      }

      return null;
    });
