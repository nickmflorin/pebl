////
////  DummyData.swift
////  Pebl2
////
////  Created by Nick Florin on 1/4/17.
////  Copyright © 2017 Nick Florin. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//////////////////////////////////////////////////////////////
//// Functions for Development and Testing Data
//
///////////////////////////////
//// Parameters for Dummy Data
//
//let fakeNames = ["Cheryl","Sam","Jen","Dani","Jackie","Caitlin","Marykate","Tori","Kait","Emily",
//                 "Liz","Christina","Chrissy"]
//let fakeAges = ["23","25","21","22","34","28","26","26","24","22","23","24","21","27","27","25","25","25"]
//let fakeEventName = "Generic Event Name"
//let fakeEventTime = "this weekend"
//let fakeEducation = "University of Connecticut"
//let fakeCareer = "Manufacturing Engineer at Sikorskvy Aircraft"
//let fakeEventMessage = "Really trying to find a new happy hour spot this weekend."
//let fakeMessagePeblMessage = "How hey are you?"
//
/////////////////////////////// Generate Fake User ID for Index
//func generateFakeUserID(index:Int)->String{
//    let testUserID = "test"+String(index)
//    return testUserID
//}
//
/////////////////////////////// Generate Fake User Images for Index
//func generateFakeUserImage(index:Int)->UserImages{
//    
//    let userID = generateFakeUserID(index: index)
//    
//    // Generate Image
//    let imageName = "DummyGirl"+String(index)+".jpg"
//    let testUserImages = UserImages(userID: userID)
//    testUserImages.profileImage = UIImage(named:imageName)
//    
//    testUserImages.image1 = UIImage(named:"DummyGirl2")
//    testUserImages.image2 = UIImage(named:"DummyGirl4")
//    testUserImages.image3 = UIImage(named:"DummyGirl5")
//    
//    return testUserImages
//}
/////////////////////////////// Generate Fake User Info for Index
//func generateFakeUserInfo(index:Int)->UserInfo{
//    
//    let userID = generateFakeUserID(index: index)
//    
//    // Generate User Info
//    let fakeUserInfo = UserInfo(userID: userID)
//    fakeUserInfo.first_name = fakeNames[index]
//    fakeUserInfo.age = Int(fakeAges[index])
//    fakeUserInfo.career = fakeCareer
//    fakeUserInfo.education = fakeEducation
//    
//    return fakeUserInfo
//}
/////////////////////////////// Generate Fake User Info for Index
//func generateFakeUserEvent(index:Int)->UserEvent{
//    
//    let userID = generateFakeUserID(index: index)
//    
//    // Generate User Event
//    let testUserEvent = UserEvent(userID: userID)
//    testUserEvent.event_name = fakeEventName
//    testUserEvent.event_time = fakeEventTime
//    testUserEvent.eventMessage = fakeEventMessage
//    
//    let dummyEventImageName = "DummyEvent"+String(index)+".jpg"
//    testUserEvent.eventImage = UIImage(named:dummyEventImageName)
//    
//    return testUserEvent
//}
/////////////////////////////// Generate Fake User Info for Index
//func generateFakeUserSuggestedEvent(index:Int)->SuggestedEvent{
//    
//    let userID = generateFakeUserID(index: index)
//    
//    // Generate User Event
//    let testUserEvent = SuggestedEvent(userID: userID)
//    testUserEvent.event_name = fakeEventName
//    testUserEvent.event_time = fakeEventTime
//    testUserEvent.eventMessage = fakeEventMessage
//
//    let dummyEventImageName = "DummyEvent"+String(index)+".jpg"
//    testUserEvent.eventImage = UIImage(named:dummyEventImageName)
//    
//    return testUserEvent
//}
/////////////////////////////// Generate Fake User for Index
//func generateFakeUser(index:Int)->User{
//    
//    let userID = generateFakeUserID(index: index)
//    let testUser = User(userID: userID)
//    
//    return testUser
//}
//
///////////////////////////////
//// Fake User for Testing and Deveopment - Authenticated User
//func getTestUser()->User{
//    
//    let testUserID = "test"
//    let testUser = User(userID: testUserID)
//    
//    let testUserImages = UserImages(userID: testUserID)
//    testUserImages.profileImage = UIImage(named:"SampleProfilePic2")
//    
//    let testUserInfo = UserInfo(userID: testUserID)
//    testUserInfo.first_name = "Will"
//    testUserInfo.age = Int(fakeAges[0])
//    testUserInfo.career = fakeCareer
//    testUserInfo.education = fakeEducation
//    
//    let testUserEvent = UserEvent(userID: testUserID)
//    testUserEvent.event_name = fakeEventName
//    testUserEvent.event_time = fakeEventTime
//    testUserEvent.eventMessage = fakeEventMessage
//    
//    testUser.userInfo = testUserInfo
//    return testUser
//}
//
///////////////////////////////
//// Function to Generate Single Fake MessagePebl
//func generateFakeSuggestionPebl(index:Int,user:User?)->SuggestionPebl{
//    
//    if user == nil{
//        let user = generateFakeUser(index: index)
//    }
//    
//    let event = generateFakeUserSuggestedEvent(index: index)
//    
//    let fakePebl = SuggestionPebl(userID: (user?.userID)!)
//    fakePebl.peblDate = NSDate() as Date
//    fakePebl.suggestedEvent = event
//    fakePebl.active = true
//    fakePebl.viewed = true
//    fakePebl.user = user
//
//    
//    return fakePebl
//}
//
///////////////////////////////
//// Function to Generate Fake Suggestion Pebls
//func generateFakeSuggestionPebls()->[SuggestionPebl]{
//    
//    var fakePebls : [SuggestionPebl] = []
//    
//    // Generate Fake Pebls for Specific User
//    for i in 1...3{
//        let user = generateFakeUser(index: i)
//        for j in 1...3 {
//            let fakePebl = generateFakeSuggestionPebl(index:i+j,user:user)
//            fakePebls.append(fakePebl)
//        }
//    }
//    return fakePebls
//}
//
///////////////////////////////
//// Function to Generate Single Fake Matche
//func generateFakeMatch(index:Int)->Match{
//    
//    let testUser = generateFakeUser(index: index)
//    
//    let fakeMatch = Match(userID: testUser.userID,matchedUserID:testUser.userID)
//    fakeMatch.matchDate = NSDate() as Date
//    
//    fakeMatch.active = false
//    fakeMatch.viewed = false
//    fakeMatch.user = testUser
//    
//    return fakeMatch
//}
///////////////////////////////
//// Function to Generate Fake Matches
//func generateFakeMatches()->[Match]{
//    
//    var fakeMatches : [Match] = []
//    // Generate Fake Matches
//    for i in 1...6{
//        fakeMatches.append(generateFakeMatch(index:i))
//    }
//    return fakeMatches
//}
///////////////////////////////
//func generateFakeUserEvent()->UserEvent{
//    
//    let userEvent = UserEvent(userID: "testID")
//    
//    userEvent.eventDate = NSDate() as Date
//    
//    userEvent.event_name = "Fortina"
//    userEvent.event_time = "This weekend"
//    
//    userEvent.eventMessage = "Lover of pizza and I heard this place has the best pizza in the city.  Want to check it out?"
//    userEvent.tags = ["Nightlife","Pizza","Beer","American"]
//    userEvent.eventImage = UIImage(named:"PizzaEvent")
//    userEvent.eventRating = 3
//    userEvent.eventAddress = "1 Caroline Street, Saratoga Springs"
//    
//    return userEvent
//}
///////////////////////////////
//// Function to Generate Single Fake MessagePebl
//func generateFakeMessagePebl(index:Int,viewed:Bool)->MessagePebl{
//    
//    let testUser = generateFakeUser(index: index)
//    
//    let fakePebl = MessagePebl(userID: testUser.userID)
//    fakePebl.message = fakeMessagePeblMessage
//    fakePebl.peblDate = NSDate() as Date
//    
//    fakePebl.active = false
//    fakePebl.viewed = viewed
//    
//    fakePebl.user = testUser
//    return fakePebl
//}
//
///////////////////////////////
//// Function to Generate Fake Message Pebls
//func generateFakeMessagePebls()->[MessagePebl]{
//    
//    var fakePebls : [MessagePebl] = []
//    
//    // Generate Fake Pebls That Haven't Been Seen Yet
//    for i in 1...4{
//        fakePebls.append(generateFakeMessagePebl(index:i,viewed:false))
//    }
//    // Generate Fake Pebls That Have Been Seen and Are Active Convos
//    for i in 4...9{
//        fakePebls.append(generateFakeMessagePebl(index:i,viewed:true))
//    }
//    return fakePebls
//}
//
