import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { DocumentReference } from '@google-cloud/firestore';

admin.initializeApp(functions.config().firebase);

//Create a new empty project for user
export const newProject = functions.https.onCall((data, context) => {
    const uid = context.auth.uid; 
    const userRef = admin.firestore().doc("/USERS/" +uid); 
    const newProjRef = admin.firestore().collection("/PROJECTS/").doc();
    let userProjects:DocumentReference[] = [] 

    const projData = {
        "id" : newProjRef.id,
        "name" : data.projName,
        "DECKS" : [],
        "USERS" : [userRef]
    }

    return newProjRef.set(projData).then(value =>{//Create a new project
        return userRef.get()
    })
    .then(snap => {//Link new project to the USERS account
        userProjects = snap.get("PROJECTS");
        userProjects = userProjects.concat(newProjRef);

        return userRef.update({"PROJECTS":userProjects})
    }) 
    .catch(err => {
        console.log('Error getting document', err);
    });
});

