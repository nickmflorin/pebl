////
////  PeblDrag.swift
////  Pebl
////
////  Created by Nick Florin on 11/9/16.
////  Copyright © 2016 Nick Florin. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
////////////////////////////////////////////
//class PeblDragScene: SKScene {
//    
//    //////////////////////////////////////////
//    let messagePebl = SKSpriteNode(imageNamed: "PeblIcon")
//    var selectedNode = SKSpriteNode()
//    var background = SKSpriteNode()
//    
//    // Hardcoded for now, can't find positioning solution.  Needs to be done programatically at some point.
//    var originalMesLoc : CGPoint = CGPoint(x:240.0,y:70.0)
//    var originalSugLoc : CGPoint = CGPoint(x:240.0,y:30.0)
//    let messageLabelPos : CGPoint = CGPoint(x:268.0,y:70.0)
//    let suggestionLabelPos : CGPoint = CGPoint(x:268.0,y:30.0)
//    
//    var bagNode : SKSpriteNode!
//    var messageLabel : SKLabelNode!
//    var suggestionLabel : SKLabelNode!
//    var messagePeblNode : SKSpriteNode!
//    var suggestionPeblNode : SKSpriteNode!
//    
//    var activePeblNode : SKSpriteNode!
//    
//    var numMessagePebls : Int!
//    var numSuggestionPebls : Int!
//    
//    let font_name = "RobotoCondensed-Regular"
//    //////////////////////////////////////////
//    override func didMove(to view: SKView) {
//        
//        scaleMode = .resizeFill
//        backgroundColor = UIColor.white
//        
//        self.background = SKSpriteNode(color: UIColor.clear, size: size)
//        self.background.name = "background"
//        self.background.anchorPoint = CGPoint.zero
//        self.addChild(background)
//        
//        self.bagNode = SKSpriteNode(imageNamed: "PenguinBag")
//        
//        // Init Labels Done from Table Cell Parent
//        self.reinsertMessagePebl()
//        self.reinsertSuggestionPebl()
//        self.initPeblBag()
//        
//        super.didMove(to: view)
//    }
//    //////////////////////////////////////////
//    // Inserts Message Pebl Sprite in Original Location
//    func reinsertMessagePebl(){
//        if self.messagePeblNode != nil{
//            // Remove Message Pebl Node and Create New One
//            self.messagePeblNode.removeFromParent()
//        }
//        self.messagePeblNode = SKSpriteNode(imageNamed: "MessagePebbleIcon")
//        self.messagePeblNode.size = CGSize(width: 30.0, height: 30.0)
//        self.messagePeblNode.name = "MessagePebl"
//        self.messagePeblNode.position = self.originalMesLoc
//        
//        self.addChild(self.messagePeblNode)
//    }
//    //////////////////////////////////////////
//    // Inserts Message Pebl Sprite in Original Location
//    func reinsertSuggestionPebl(){
//        if self.suggestionPeblNode != nil{
//            self.suggestionPeblNode.removeFromParent()
//        }
//        self.suggestionPeblNode = SKSpriteNode(imageNamed: "SuggestionPebbleIcon")
//        self.suggestionPeblNode.size = CGSize(width: 30.0, height: 30.0)
//        self.suggestionPeblNode.name = "SuggestionPebl"
//        self.suggestionPeblNode.position = self.originalSugLoc
//        
//        self.addChild(self.suggestionPeblNode)
//
//    }
//    //////////////////////////////////////////
//    // Increments Number of Pebls in Label and Actions
//    func incrementPebl(_ type:String){
//        if type == "MessagePebl"{
//            if var numMsgPebls = self.numMessagePebls{
//                numMsgPebls = numMsgPebls + 1
//                self.numMessagePebls = numMsgPebls
//                let numMsgPeblString = String(describing: numMsgPebls)
//                self.messageLabel.text = numMsgPeblString+"x"
//            }
//        }
//        else if type == "SuggestionPebl"{
//            if var numSugPebls = self.numSuggestionPebls{
//                numSugPebls += 1
//                self.numSuggestionPebls = numSugPebls
//                let numSugPeblString = String(describing: numSugPebls)
//                self.suggestionLabel.text = numSugPeblString+"x"
//            }
//        }
//    }
//    //////////////////////////////////////////
//    // Decrements Number of Pebls in Label and Actions
//    func decrementPebl(_ type:String){
//        if type == "MessagePebl"{
//            if var numMsgPebls = self.numMessagePebls{
//                numMsgPebls = numMsgPebls - 1
//                self.numMessagePebls = numMsgPebls
//                let numMsgPeblString = String(describing: numMsgPebls)
//                self.messageLabel.text = numMsgPeblString+"x"
//                
//                // Remove Current Pebl and Put New One in Original Location
//                self.reinsertMessagePebl()
//            }
//        }
//        else if type == "SuggestionPebl"{
//            if var numSugPebls = self.numSuggestionPebls{
//                numSugPebls = numSugPebls-1
//                self.numSuggestionPebls = numSugPebls
//                let numSugPeblString = String(describing: numSugPebls)
//                self.suggestionLabel.text = numSugPeblString+"x"
//                
//                // Remove Current Pebl and Put New One in Original Location
//                self.reinsertSuggestionPebl()
//            }
//        }
//    }
//    //////////////////////////////////////////
//    func initLabels(_ numMessagePebls:Int,numSuggestionPebls:Int){
//        
//        self.messageLabel = SKLabelNode(fontNamed: self.font_name)
//        self.suggestionLabel = SKLabelNode(fontNamed: self.font_name)
//        
//        self.numMessagePebls = numMessagePebls
//        self.numSuggestionPebls = numSuggestionPebls
//
//        let numMessagePeblString = String(describing: self.numMessagePebls!)
//        let numSuggestionPeblString = String(describing: self.numSuggestionPebls!)
//        
//        // Unwrap
//        if self.messageLabel != nil{
//            self.messageLabel.text = numMessagePeblString+"x"
//            self.messageLabel.fontSize = 14
//            self.messageLabel.fontColor = light_blue
//            self.messageLabel.name = "messageLabel"
//
//            self.messageLabel.position = self.messageLabelPos
//            
//            self.addChild(self.messageLabel)
//        }
//        // Unwrap
//        if self.suggestionLabel != nil{
//            self.suggestionLabel.text = numSuggestionPeblString+"x"
//            self.suggestionLabel.fontSize = 14
//            self.suggestionLabel.fontColor = light_blue
//            self.suggestionLabel.name = "suggestionLabel"
//            
//            self.suggestionLabel.position = self.suggestionLabelPos
//            
//            self.addChild(self.suggestionLabel)
//        }
//    }
//    //////////////////////////////////////////
//    func initPeblBag(){
//        // Create Sprite for Pebl Bag
//        self.bagNode = SKSpriteNode(imageNamed: "PenguinBag")
//        self.bagNode.size = CGSize(width: 80.0, height: 70.0)
//        self.bagNode.name = "peblBag"
//        self.bagNode.position = CGPoint(x:58.0,y:40.0)
//        self.addChild(self.bagNode)
//    }
//    //////////////////////////////////////////
//    // Function to Handle Actions when Pebl Dragged to Bag
//    func addedPebl(){
//
//        // Remove Animation from Bag Node
//        self.bagNode.removeAllActions()
//        self.bagNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
//        
//        if self.activePeblNode != nil{
//            if self.activePeblNode.name == "SuggestionPebl"{
//                // Hide Currently Dragged Pebl
//                self.decrementPebl("SuggestionPebl")
//            }
//            else if self.activePeblNode.name == "MessagePebl"{
//                self.bagNode.texture = SKTexture(image:#imageLiteral(resourceName: "PenguinPagwMessagePebl"))
//                self.decrementPebl("MessagePebl")
//            }
//            // Tell Parent View to Move to Pebl Window
//            let parent = self.view?.superview?.superview as! MatchTableViewCell
//            parent.showMessagePeblWindow()
//        }
//        
//    }
//    /////////////////////////////////////////
//    // Moves Pebls Back to Original Location if Not Dragged to Bag
//    func returnPebls(){
//        if selectedNode.name != nil{
//            if selectedNode.name! == "SuggestionPebl"{
//                selectedNode.position = self.originalSugLoc
//            }
//            else if selectedNode.name! == "MessagePebl"{
//                selectedNode.position = self.originalMesLoc
//            }
//            self.bagNode.removeAllActions()
//            self.bagNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
//        }
//    }
//    /////////////////////////////////////////
//    // Animates Pebl Bag Rocking Back and Forth
//    func rockPeblBag(){
//        let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(-0.5), duration: 0.1),
//                                          SKAction.rotate(byAngle: 0.0, duration: 0.1),
//                                          SKAction.rotate(byAngle: degToRad(0.5), duration: 0.1)])
//        self.bagNode.run(SKAction.repeat(sequence, count: 3))
//    }
//    //////////////////////////////////////////
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first{
//            let positionInScene = touch.location(in: self)
//            selectNodeForTouch(positionInScene)
//        }
//        super.touchesBegan(touches, with: event)
//    }
//    /////////////////////////////////////////
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first{
//            let positionInScene = touch.location(in: self)
//            selectNodeForTouch(positionInScene)
//            
//            // Check if Pebl is Still On Bag when Touch Ends (i.e. User is Putting Pebl in Bag)
//            let peblNode: CGPoint! = selectedNode.position
//            if (self.bagNode.contains(peblNode)){
//                self.addedPebl()
//            }
//            else{
//                self.returnPebls()
//            }
//        }
//    }
//    //////////////////////////////////////////
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        if let touch = touches.first{
//            
//            let positionInScene = touch.location(in: self)
//            let previousPosition = touch.previousLocation(in: self)
//            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
//            
//            panForTranslation(translation)
//        }
//        super.touchesMoved(touches, with: event)
//    }
//    //////////////////////////////////////////
//    func degToRad(_ degree: Double) -> CGFloat {
//        return CGFloat(Double(degree) / 180.0 * M_PI)
//    }
//    //////////////////////////////////////////
//    // Determines Which Pebl Node Selected at Touch
//    func selectNodeForTouch(_ touchLocation: CGPoint) {
//
//        let touchedNode = self.atPoint(touchLocation)
//        if touchedNode is SKSpriteNode {
//            
//            if !selectedNode.isEqual(touchedNode) {
//                // Check if Node is Either Pebl Node
//                if touchedNode.name == "SuggestionPebl" || touchedNode.name == "MessagePebl" {
//                    selectedNode.removeAllActions()
//                    selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
//                    
//                    selectedNode = touchedNode as! SKSpriteNode
//                    if selectedNode.name == "SuggestionPebl" || selectedNode.name == "MessagePebl" {
//                        let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(-4.0), duration: 0.1),
//                                                          SKAction.rotate(byAngle: 0.0, duration: 0.1),
//                                                          SKAction.rotate(byAngle: degToRad(4.0), duration: 0.1)])
//                        selectedNode.run(SKAction.repeatForever(sequence))
//                    }
//                }
//            }
//        }
//    }
//    /////////////////////////////////////////
//    // Used to Make Sure Pebl isn't Dragged Passed Bounds
//    func boundLayerPos(_ aNewPosition: CGPoint) -> CGPoint {
//        let winSize = self.size
//        var retval = aNewPosition
//        retval.x = CGFloat(min(retval.x, 0))
//        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
//        retval.y = self.position.y
//        
//        return retval
//    }
//    /////////////////////////////////////////
//    func panForTranslation(_ translation: CGPoint) {
//        let position = selectedNode.position
//
//        if selectedNode.name == "SuggestionPebl" || selectedNode
//            .name == "MessagePebl" {
//            
//            self.activePeblNode = selectedNode
//            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
//            // Check if Pebl Sprite Intersects Bag Sprite
//            let peblNode: CGPoint! = selectedNode.position
//            if (self.bagNode.contains(peblNode)){
//                self.rockPeblBag()
//            }
//        } else {
//            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
//            background.position = self.boundLayerPos(aNewPosition)
//        }
//    }
//
//}
