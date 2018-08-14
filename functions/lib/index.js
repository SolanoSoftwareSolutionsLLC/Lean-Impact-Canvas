"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
//Create a new empty project for user
exports.newProject = functions.https.onCall((data, context) => {
    const uid = context.auth.uid;
    const userRef = admin.firestore().doc("/USERS/" + uid);
    const newProjRef = admin.firestore().collection("/PROJECTS/").doc();
    let userProjects = [];
    const projData = {
        "id": newProjRef.id,
        "name": data.projName,
        "DECKS": [],
        "USERS": [userRef]
    };
    return newProjRef.set(projData).then(value => {
        return userRef.get();
    })
        .then(snap => {
        userProjects = snap.get("PROJECTS");
        userProjects = userProjects.concat(newProjRef);
        return userRef.update({ "PROJECTS": userProjects });
    })
        .catch(err => {
        console.log('Error getting document', err);
    });
});
//# sourceMappingURL=index.js.map