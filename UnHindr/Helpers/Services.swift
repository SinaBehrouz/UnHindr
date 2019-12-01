/*
 File: [Services.swift]
 Creators: [Allan]
 Date created: [29/10/2019]
 Date updated: [10/11/2019]
 Updater name: [Allan]
 File description: [Services file for database references]
 */

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth


class Services {
    
    // Store reference to current user's stored data
    static var userRef: String?
    
    // Handle for authentication changes
    static var handle: AuthStateDidChangeListenerHandle?
    
    // Static reference to Firestore root
    static let db = Firestore.firestore()
    
    // Reference to all users
    static let fullUserRef = db.collection("users")
    
//    // User profile reference
//    static var userProfileRef: DocumentReference?//db.collection("users").document(userRef!)
//
//    // Medication plan reference
    static let medPlanName = "MedicationPlan"
//    static var medicationPlanRef = db.collection("users").document(userRef!).collection("MedicationPlan")

//    // Medication history reference
    static let medHistoryName = "Medication"
//    static var medicationHistoryRef = db.collection("users").document(userRef!).collection("Medication")

//    // Connections reference
    static let connectionName = "Connections"
//    static var connectionRef = db.collection("users").document(userRef!).collection("Connections")

//    // Motor Game reference
    static let motorGameName = "MotorGameData"
//    static var motorGameRef = db.collection("users").document(userRef!).collection("MotorGameData")
    
    static let locationName = "Location"
    
    // Cognitive Game reference
    static let cogGameName = "CogGameData"
    
    static let moodName = "Mood"

    
    // MARK: - Retrieve reference to a patient's data
    // Input:
    //      1. unique UID of a user
    // Output:
    //      1. Reference to user data
    static func getDBUserRef(_ user: User?, completionHandler: @escaping(_ result: String?) -> Void) {
        var result: String!
        // fetch reference to specified user
        let uid = (user?.uid ?? "User instance is nil")
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting user info")
                } else {
                    result = (querySnapshot!.documents[0].documentID)
                    completionHandler(result)
                }
        }
    }
    //Configures how the alert will be displayed to screen
    //input:
    //      1.Takes in a title and message parameter and displays alert to screen
    //output:
    //      1. output the alert to the screen
    static func showAlert(_ title:String, _ message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func transitionHome(_ UIVC: UIViewController){
        Services.fetchModeStatus(Services.userRef!) { (result) in
            if (result!) {
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "CaregiverHomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CaregiverHomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    static func transitionHomeErrMsg(_ UIVC: UIViewController, errTitle: String, errMsg: String){
        Services.fetchModeStatus(Services.userRef!) { (result) in
            if (result!) {
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "CaregiverHomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CaregiverHomeScreenViewController") as UIViewController
                UIVC.present(vc, animated: true, completion: nil)
            }
        }
        Services.showAlert(errTitle, errMsg, vc: UIVC)
    }
    
    
    // Fetch caregiver mode status using a completion handler
    // Input:
    //      1. User reference
    // Output:
    //      1. returns true if user is a patient else false
    static func fetchModeStatus(_ userdoc: String, completionHandler: @escaping (_ result: Bool? ) -> Void){
        fullUserRef.document(userRef!).getDocument { (documentSnapshot, err) in
            if err != nil {
                //error
            }
            else{
                guard let document = documentSnapshot else {
                    print("Error fetching user document")
                    return
                }
                
                let status = document.get("isPatient") as! Bool

                completionHandler(status)
            }
            
        }
    }
    
//    static func checkUserIDMed() -> CollectionReference
//    {
//        var medRef: CollectionReference
//        if (user_ID == "")
//        {
//            medRef = Services.fullUserRef.document(Services.userRef!).collection(Services.medicationHistoryRef)
//        }
//        else
//        {
//            medRef = Services.fullUserRef.document(Services.userRef!).collection(Services.medicationHistoryRef)
//        }
//        return medRef
//    }
    
    // Checks whether the current logged in user is a patient or not
    // Input:
    //      1. None
    // Output:
    //      1. returns true if user is a patient
    //      2. returns false if user is a caregiver
    static func getisPatient(completionHandler: @escaping (_ result: Bool) -> Void)
    {
        Services.db.collection("users").whereField("email", isEqualTo: userEmail).whereField("isPatient", isEqualTo: true).getDocuments() {
            (querySnapshot,err) in
            if querySnapshot!.isEmpty {
                completionHandler(false)
            }
            else
            {
                completionHandler(true)
            }
        }
    }
    
    static func checkUserIDMotorGame() -> CollectionReference
    {
        var motorRef: CollectionReference
        if (user_ID == "")
        {
            motorRef = Services.db.collection("users").document(Services.userRef!).collection(Services.motorGameName)
        }
        else
        {
            motorRef = Services.fullUserRef.document(user_ID).collection(Services.motorGameName)
        }
        return motorRef
    }
    
    static func checkUserIDCogGame() -> CollectionReference
    {
        var cogRef: CollectionReference
        if (user_ID == "")
        {
            cogRef = Services.fullUserRef.document(Services.userRef!).collection(Services.cogGameName)
        }
        else{
            cogRef = Services.fullUserRef.document(user_ID).collection(Services.cogGameName)
        }
        return cogRef
    }
    
    static func checkUserIDMood() -> CollectionReference
    {
        var moodRef: CollectionReference
        if(user_ID == "")
        {
            moodRef = Services.fullUserRef.document(Services.userRef!).collection(Services.moodName)
        }
        else
        {
            moodRef = Services.fullUserRef.document(user_ID).collection(Services.moodName)
        }
        return moodRef
    }
    
}

extension Date {
    enum Weekday: String, CaseIterable {
        case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
        
        static var asArray: [Weekday] {
            return self.allCases
        }
        
        func asInt() -> Int {
            return Weekday.asArray.firstIndex(of: self)!
        }
    }
    
    static func isToday(_ timestamp: Timestamp) -> Bool {
        return Calendar.current.isDateInToday(timestamp.dateValue())
    }
    
    static func getDayOfWeek(_ timestamp: Timestamp) -> Date.Weekday {
        // Get date of week from NSDate value
        print("Timestamp: \(timestamp.dateValue())")
        let index = Calendar.current.component(.weekday, from: timestamp.dateValue())
        print("Date of week \(index)")
        return Weekday.asArray[index-1]
    }
    
}
