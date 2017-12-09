////
////  FakeData.swift
////  Pebl
////
////  Created by Nick Florin on 7/22/16.
////  Copyright © 2016 Nick Florin. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseAuth
//import FirebaseStorage
//
/////////////////////////////////////////////////////////////////
//class FakeAccounts{
//    
//    ///////////////////////////////////////////////////////////////
//    // Fake Data
//    var attribute_names : [String] = ["first_name", "gender", "gender_interest","education", "career", "about_me", "hobbies","sig_other","ideal_first_date","age"]
//    var female_names = ["Jill","Dani","Ashley","Marykate","Tori","Sam","Alex","Caitlin","Mary","Maura","Emily","Jackie","Cheryl","Debbie","Sarah"]
//    var male_names = ["Nick","Will","Alex","John","Jack","Victor","Luke","Jake","Scott","Owen","Chad","Tom","Ryan","Isaac","Jordan"]
//    var education_list = ["Psychology at Brown University","Engineering at UConn","Mathematics at Harvard","English at Stanford","Nursing at Villanova","J.D. at American University","Biology at B.U.","Business Management at SUNY Albany","MBA at Brown","M.S. in Computer Science at Johns Hopkins","Business Management at Clarkson","Electrical Engineering at RIT"]
//    var gender_list : [String] = ["Male","Female"]
//    var gender_interest_list : [String] = ["Male","Female"]
//    let dummy_female_image_list=["DummyGirl1.jpg","DummyGirl2.jpg","DummyGirl3.jpg","DummyGirl4.jpg","DummyGirl5.jpg","DummyGirl6.jpg","DummyGirl7.jpg","DummyGirl8.jpg","DummyGirl9.jpg","DummyGirl10.jpg","DummyGirl11.jpg","DummyGirl12.jpg","DummyGirl13.jpg","DummyGirl14.jpg","DummyGirl15.jpg"]
//    let dummy_male_image_list=["DummyGuy1.jpg","DummyGuy2.jpg","DummyGuy3.jpg","DummyGuy4.jpg","DummyGuy5.jpg"]
//    var age_list : [String] = ["21","23","25","26","31","20","24","21","22","25"]
//    var default_about_me = "This is the About Me section.  This is where the user would put a short bio of information about themselves and would be one of the first things that people see when they view a profile."
//    var default_hobbies = "This is the Hobbies section.  This is where the user would put a short list of hobbies.  Either through adding to a list, item by item, or typing out a paragraph."
//    var sig_other = "This is where the user would put information about their ideal significant other."
//    ///////////////////////////////////////////////////////////////
//    
//    let num_users = 8
//    var careers_json_list : [String]?
//    var education_json_list : [String]?
//    
//    let ref = FIRDatabase.database().reference()
//    let storageRef = FIRStorage.storage().reference()
//    ///////////////////////////////////////////////////////////////
//    func create(){
//        
//        let read_group = DispatchGroup()
//        
//        ////////////////////////////////////////////////////////////
//        // Read JSON Data for Fake Careers
//        read_group.enter()
//        self.read_career_json({(success) -> Void in
//            if success{
//                print("Finished Reading Career JSON")
//                read_group.leave()
//            }
//        })
//        ////////////////////////////////////////////////////////////
//        // Read JSON Data for Fake Education
//        read_group.enter()
//        self.read_education_json({(success) -> Void in
//            if success{
//                print("Finished Reading Education JSON")
//                read_group.leave()
//            }
//        })
//        // Wait for JSON Data to be Read Before Proceeding
//        read_group.wait(timeout: DispatchTime.distantFuture)
//        
//        
//        let save_group = DispatchGroup()
//        
//        ////////////////////////////////////////////////////////////
//        // Counters to Keep Track of Current Items in List - Ensures Index not Out of Bounds
//        var age_count = 0
//        var male_image_count = 0
//        var female_image_count = 0
//        var male_name_count = 0
//        var female_name_count = 0
//        var career_count = 0
//        var gender_count = 0
//        var education_count = 0
//        
//        ////////////////////////////////////////////////////////////
//        for i in 0...num_users {
//            
//            let gender_interest : String?
//            let name : String?
//            let user_name : String?
//        
//            let about_me = self.default_about_me
//            let hobbies = self.default_hobbies
//            /////////////
//            if education_count >= self.education_list.count-1{
//                education_count=0
//            }
//            else{
//                education_count=education_count+1
//            }
//            let education = education_list[education_count]
//            /////////////
//
//            
//            /////////////
//            if age_count >= self.age_list.count-1{
//                age_count=0
//            }
//            else{
//                age_count=age_count+1
//            }
//            let age = age_list[age_count]
//            
//            if gender_count == 1{
//                gender_count=0
//            }
//            else{
//                gender_count=1
//            }
//            let gender = gender_list[gender_count]
//            
//            /////////////
//            if male_name_count >= self.male_names.count-1{
//                male_name_count=0
//            }
//            else{
//                male_name_count=male_name_count+1
//            }
//            /////////////
//            if female_name_count >= self.female_names.count-1{
//                female_name_count=0
//            }
//            else{
//                female_name_count=female_name_count+1
//            }
//            
//            /////////////
//            if male_image_count >= self.dummy_male_image_list.count-1{
//                male_image_count=0
//            }
//            else{
//                male_image_count=male_image_count+1
//            }
//
//            /////////////
//            if female_image_count >= self.dummy_female_image_list.count-1{
//                female_image_count=0
//            }
//            else{
//                female_image_count=female_image_count+1
//            }
//            
//            let image_paths = NSMutableArray()
//            ////////////////////////////////////////////////////
//            // Case When Gender is Male
//            if gender == "Male"{
//                gender_interest = "Female"
//
//                // Set Image Paths for 3 Images
//                for i in 0...3{
//                    if male_image_count >= self.dummy_male_image_list.count-1{
//                        male_image_count=0
//                    }
//                    else{
//                        male_image_count=male_image_count+1
//                    }
//                    let image_path = dummy_male_image_list[male_image_count]
//                    image_paths.add(image_path)
//                }
//                
//                /////////////
//                if male_name_count >= self.male_names.count-1{
//                    male_name_count=0
//                }
//                else{
//                    male_name_count=male_name_count+1
//                }
//                
//                name = male_names[male_name_count]
//                user_name = name!+"123"
//                
//            }
//            ////////////////////////////////////////////////////
//            // Case When Gender is Female
//            else{
//                gender_interest = "Male"
//                // Set Image Paths for 3 Images
//                for i in 0...3{
//                    if female_image_count >= self.dummy_female_image_list.count-1{
//                        female_image_count=0
//                    }
//                    else{
//                        female_image_count=female_image_count+1
//                    }
//                    let image_path = dummy_female_image_list[female_image_count]
//                    image_paths.add(image_path)
//                }
//                /////////////
//                if female_name_count >= self.female_names.count-1{
//                    female_name_count=0
//                }
//                else{
//                    female_name_count=female_name_count+1
//                }
//                name = female_names[female_name_count]
//                user_name = name!+"123"
//            }
//            
//            //////////////////////////////////////////////////
//            // Set Fake Users Career
//            if career_count>=self.careers_json_list!.count-1{
//                career_count = 0
//            }
//            else{
//                career_count = career_count+1
//            }
//            let career = self.careers_json_list![career_count]
//            
//
//            ///////////////////////////////////////////////////
//            // Saving Data
//            save_group.enter()
//            let key = randomStringWithLength(10)
//            
//            DispatchQueue.main.async(execute: {
//                
//                let fake_email = (key as String)+"@gmail.com"
//                let fake_pw = "fake_password"
//                
//                FIRAuth.auth()?.createUser(withEmail: fake_email, password: fake_pw) { (user, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        save_group.leave()
//                    }
//                    else{
//                        // Update System for Current User
//                        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
//                        changeRequest?.displayName = user_name
//                        
//                        let new_userID = FIRAuth.auth()?.currentUser?.uid
//                        
//                        ////////////////////////////////////
//                        // Save New User Info
//                        self.ref.child("users").child(new_userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            let post = ["user_name": user_name! as String,"hobbies": hobbies as String,"about_me": about_me as String,
//                                "first_name": name! as String,"gender": gender as String,"gender_interest": gender_interest! as String,"career": career as String,
//                                "education":education as String,"age":age as String]
//                            
//                            self.ref.child("users").child(new_userID!).updateChildValues(post)
//                        })
//                        ////////////////////////////////////
//                        // Save Photo IDS
//                        self.ref.child("user_images").child(new_userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            
//                            let add_photo_id = image_paths[0] as! String
//                            let add_photo_id2 = image_paths[1] as! String
//                            let add_photo_id3 = image_paths[2] as! String
//                            
//                            let post2 = ["profile_image": add_photo_id,"image1":add_photo_id2,"image2":add_photo_id3]
//                            self.ref.child("user_images").child(new_userID!).updateChildValues(post2)
//                        })
//                        
//                        ////////////////////////////////////
//                        // Save User Events
//                        self.ref.child("user_events").child(new_userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            
//                            let post3 = ["custom_event": "Tennis","event_message":"Who wants to play some tennis at the local courts?"]
//                            self.ref.child("user_events").child(new_userID!).updateChildValues(post3)
//                        })
//                        
//                        save_group.leave()
//                        
//                    }
//
//                }
//            
//            })
//            
//        }//End For Loop
//        
//    }
//    ///////////////////////////////////////////////////////////////
//    func read_education_json(_ completionHandler: (_ success: Bool) -> Void){
//        
//        let path = "/Users/nick.florin/Desktop/ThoughtFire Labs/Pebl/DummyAccounts/FakeEducation.json"
//        var elist : [String] = []
//        
//        do {
//            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
//            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array<[String: AnyObject]>
//            let edu_json = json![0]
//            let edu_arr = edu_json["education"] as? [String]
//            for i in 0...num_users{
//                elist.append(edu_arr![i])
//                print("Reading Education Data : \(i))")
//            }
//            self.education_json_list = elist
//            completionHandler(true)
//        }
//        catch {
//            print("Error Reading JSON for Education")
//            print(error)
//        }
//        
//    }
//    ///////////////////////////////////////////////////////////////
//    func read_career_json(_ completionHandler: (_ success: Bool) -> Void){
//        
//        let path = "/Users/nick.florin/Desktop/ThoughtFire Labs/Pebl/DummyAccounts/FakeCareers.json"
//        var clist : [String] = []
//        
//        do {
//            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
//            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array<[String: AnyObject]>
//            let careers_json = json![0]
//            let careers_arr = careers_json["careers"] as? [String]
//            for i in 0...num_users{
//                clist.append(careers_arr![i])
//                print("Reading Career Data : \(i))")
//            }
//            self.careers_json_list = clist
//            completionHandler(true)
//        }
//        catch {
//            print("Error Reading JSON for Careers")
//            print(error)
//        }
//        
//    }
//
//}
