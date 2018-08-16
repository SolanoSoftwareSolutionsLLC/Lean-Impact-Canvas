import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { DocumentReference } from '@google-cloud/firestore';

admin.initializeApp(functions.config().firebase);


//Create a new user
export const newUser = functions.https.onCall(async (data, context) => {
    try{
        const uid = context.auth.uid
        const user = await admin.auth().getUser(uid)

        console.log("USER FOUND WITH NAME:"+user.displayName)

        const userRef = admin.firestore().doc("/USERS/" + uid); 
        const projectsArray:DocumentReference[] = []
    
        const userData = {
            "uid": uid,
            "name":user.displayName,
            "PROJECTS":projectsArray
        }
    
        await userRef.set(userData)
    
        return {"status":"success", "path":userRef.path}
    }catch(err){
        return {"status":"failed"}
    }
})

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

//Create a new Empty Deck
export const newDeck = functions.https.onCall((data, context) => {
    const projID = data.projID; 

    const newDeckRef = admin.firestore().collection("/DECKS/").doc(); 
    const projRef = admin.firestore().doc("/PROJECTS/"+projID);

    const deckData = {
        "id" : newDeckRef.id,
        "title" : data.deckName,
        "public" : false,
        "cardOrder" : []
    }

    return newDeckRef.set(deckData).then(value =>{//Create a new project
        return projRef.get()
    })
    .then(snap => {//Link new project to the USERS account
        let projDecks = snap.get("DECKS");
        projDecks = projDecks.concat(newDeckRef);

        return projRef.update({"DECKS":projDecks})
    }) 
    .catch(err => {
        console.log('Error getting document', err);
    });
})

// //Create a new Empty Card
export const newCard = functions.https.onCall(async (data, context) => {
    try{
        const imagesArray:String[] = []
        const newCardRef = admin.firestore().collection("/CARDS/").doc()
        const deckRef = admin.firestore().doc("/DECKS/" + data.deckID)
        const ownerRef = admin.firestore().doc("/USERS/" + context.auth.uid)
        const cardData = {
            "id": newCardRef.id,
            "title": data.deckName,
            "owner": ownerRef,
            "text":"",
            "images":imagesArray
        }

        await newCardRef.set(cardData)

        const deckDoc = await deckRef.get()

        let deckCards = deckDoc.get("cardOrder");
        deckCards = deckCards.concat(newCardRef);

        await deckRef.update({"cardOrder":deckCards})

    }catch(err){
        console.log('Error creating a new card' +  err)
    }

})

//Delete Project
// export const deleteProject = functions.https.onCall((data, context) => {

// })

//Delete Deck
// export const deleteDeck = functions.https.onCall((data, context) => {

// })

//Delete Card
// export const deleteCard = functions.https.onCall((data, context) => {

// })

//Share Project
// export const shareProject = functions.https.onCall((data, context) => {

// })

//Share Deck
// export const shareDeck = functions.https.onCall((data, context) => {

// })

//Share Card
// export const shareCard = functions.https.onCall((data, context) => {

// })