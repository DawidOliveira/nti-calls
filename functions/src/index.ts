import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
admin.initializeApp();

export const sendMessageOnWrite = functions.firestore.document('notifications/{notificationID}').onWrite((snapshot, context) => {
    admin.messaging().sendToDevice(snapshot.after.get('token'),{
        notification: {
            title: snapshot.after.get('fullname'),
            body: snapshot.after.get('message'),
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        }
    });
});