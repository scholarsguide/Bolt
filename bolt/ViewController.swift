//
//  ViewController.swift
//  bolt
//
//  Created by Shashank Acharya on 11/12/16.
//  Copyright © 2016 Shashank Acharya. All rights reserved.
//
import Cocoa
class ViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var removeAllTextButton: NSButton!
    @IBOutlet weak var currentWord: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var intervalValue: NSSlider!
    @IBOutlet weak var sliderLabel: NSTextField!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var newButton: NSButton!
    @IBOutlet weak var nextWord: NSTextField!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var prevWord: NSTextField!
    @IBOutlet var mainView: NSView!
    @IBOutlet var textFieldForText: NSTextView!
    @IBOutlet weak var scrollViewForText: NSScrollView!
    @IBOutlet weak var readButton: NSButton!
    
    @IBAction func removeAllText(_ sender: Any) {
        textFieldForText.string! = ""
        print("All text removed from text field")
    }
    
    @IBAction func setNewText(_ sender: Any) {
        scrollViewForText.isHidden = false
        readButton.isHidden = false
        removeAllTextButton.isHidden = false
        startButton.isHidden = true
        pauseButton.isHidden = true
        resetButton.isHidden = true
        newButton.isHidden = true
        intervalValue.isHidden = true
        sliderLabel.isHidden = true
        pauseButton.isEnabled = true
        startButton.isEnabled = false
        pauseStatus = true
        print("User is attempting to change text")
    }
    
    @IBAction func changeText(_ sender: Any) {
        textToRead = textFieldForText.string!
        scrollViewForText.isHidden = true
        removeAllTextButton.isHidden = true
        readButton.isHidden = true
        startButton.isHidden = false
        pauseButton.isHidden = false
        resetButton.isHidden = false
        newButton.isHidden = false
        intervalValue.isHidden = false
        sliderLabel.isHidden = false
        counter = 0
        currentWord.stringValue = "Begin"
        nextWord.stringValue = ""
        prevWord.stringValue = ""
        pauseStatus = true
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        print("User has changed text")
    }
    
    @IBAction func boltFunction(_ sender: Any) {
        print("User has started the action")
        if textToRead == "" {
            print("No text found in NSTextField, returning default text")
            textToRead = "Gregory is my beautiful gray Persian cat. He walks with pride and grace, performing a dance of disdain as he slowly lifts and lowers each paw with the delicacy of a ballet dancer. His pride, however, does not extend to his appearance, for he spends most of his time indoors watching television and growing fat. He enjoys TV commercials, especially those for Meow Mix and Lives. His familiarity with cat food commercials has led him to reject generic brands of cat food in favour of only the most expensive brands. Gregory is as finicky about visitors as he is about what he eats, befriending some and repelling others. He may snuggle up against your ankle, begging to be petted, or he may imitate a skunk and stain your favorite trousers. Gregory does not do this to establish his territory, as many cat experts think, but to humiliate me because he is jealous of my friends. After my guests have fled, I look at the old fleabag snoozing and smiling to himself in front of the television set, and I have to forgive him for his obnoxious, but endearing, habits."
        }
        pauseStatus = false
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        arrayOfText = textToRead.components(separatedBy: characters)
        numberOfWords = arrayOfText.count
        reader()
    }
    
    @IBAction func pause(_ sender: Any) {
        print("User has paused the action")
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        pauseStatus = true
    }
    
    @IBAction func reset(_ sender: Any) {
        pauseStatus = true
        print("User has reset the action")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.prevWord.stringValue = ""
            self.currentWord.stringValue = self.arrayOfText[0]
            if self.numberOfWords > 1{
                self.nextWord.stringValue = self.arrayOfText[1]
            }
            self.startButton.isEnabled = true
            self.pauseButton.isEnabled = false
            self.counter = 0
        }
    }
    
    var numberOfWords = 0
    var counter = 0
    var characters = NSCharacterSet.whitespacesAndNewlines
    var arrayOfText = ["Default"]
    var index = 0
    var pauseStatus: Bool = true
    var quotationSet = CharacterSet.init(charactersIn: "\u{22}\u{27}\u{60}\u{B4}\u{2018}\u{2019}\u{201C}\u{201D}")
    var intervalTime = 0.2
    var textToRead: String = "Gregory is my beautiful gray Persian cat. He walks with pride and grace, performing a dance of disdain as he slowly lifts and lowers each paw with the delicacy of a ballet dancer. His pride, however, does not extend to his appearance, for he spends most of his time indoors watching television and growing fat. He enjoys TV commercials, especially those for Meow Mix and Lives. His familiarity with cat food commercials has led him to reject generic brands of cat food in favour of only the most expensive brands. Gregory is as finicky about visitors as he is about what he eats, befriending some and repelling others. He may snuggle up against your ankle, begging to be petted, or he may imitate a skunk and stain your favorite trousers. Gregory does not do this to establish his territory, as many cat experts think, but to humiliate me because he is jealous of my friends. After my guests have fled, I look at the old fleabag snoozing and smiling to himself in front of the television set, and I have to forgive him for his obnoxious, but endearing, habits."
    override func viewDidLoad() {
        print("View loaded with keypress detection inside app")
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDown)
        currentWord.textColor = .black
    }
    
    func keyDown(with event: NSEvent!)->NSEvent {
        if event.keyCode == 126 {
            if self.counter > 0{
                self.counter -= 1
                self.currentWord.stringValue = self.arrayOfText[self.counter]
                if self.counter > 0{
                    self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                }else{self.prevWord.stringValue = ""}
                if self.counter < self.numberOfWords - 1{
                    self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                }else{self.nextWord.stringValue = ""}
            }
        }
        if event.keyCode == 125 {
            print("Previous word was selected")
            if self.counter < self.numberOfWords - 1{
                self.counter += 1
                self.currentWord.stringValue = self.arrayOfText[self.counter]
                if self.counter > 0{
                    self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                }else{self.prevWord.stringValue = ""}
                if self.counter < self.numberOfWords - 1{
                    self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                }else{self.nextWord.stringValue = ""}
            }
        }
        if event.keyCode == 123 {
            if intervalValue.floatValue >= 0.1{
                intervalValue.floatValue = intervalValue.floatValue + 0.05
                print("Interval time increased to" + String(intervalValue.floatValue))
            }
        }
        if event.keyCode == 124 {
            if intervalValue.floatValue <= 0.6 {
                intervalValue.floatValue = intervalValue.floatValue - 0.05
                print("Interval time decreased to" + String(intervalValue.floatValue))
            }
        }
        if event.keyCode == 49 {
            switch pauseStatus {
            case true: self.boltFunction(Any.self);print("User has started the action"); break
            case false: self.pauseStatus = true;pauseButton.isEnabled=false;startButton.isEnabled=true;print("User has paused the action"); break
            }
        }
        return event
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground = true
        self.view.window?.title = ""
        self.view.window?.alphaValue = 0.95
    }
    
    func reader(){
        intervalTime = Double(intervalValue.floatValue)
        if pauseStatus == true{
            return
        }
        if counter < numberOfWords {
            if counter == numberOfWords - 1{
                startButton.isEnabled = false
                pauseButton.isEnabled = false
                print("Action has ended")
            }
        }
        if counter != numberOfWords{
            if String(arrayOfText[counter])!.rangeOfCharacter(from: quotationSet) != nil{
                var firstLetter = (arrayOfText[counter])[arrayOfText[counter].index(arrayOfText[counter].startIndex, offsetBy: 0)]
                if (String(firstLetter).rangeOfCharacter(from: quotationSet) != nil){
                    print("Opening quotation found")
                    currentWord.font = NSFont(name: "HelveticaNeue-LightItalic" , size: 90)
                }
                
            }
            if counter > 0{
                if String(arrayOfText[counter-1])!.rangeOfCharacter(from: quotationSet) != nil {
                    var endLetter = (arrayOfText[counter-1])[arrayOfText[counter-1].index(arrayOfText[counter-1].endIndex, offsetBy: -1)]
                    var secondLast = (arrayOfText[counter-1])[arrayOfText[counter-1].index(arrayOfText[counter-1].endIndex, offsetBy: -2)]
                    if (String(endLetter).rangeOfCharacter(from: quotationSet) != nil){
                        print("Closing quotation found")
                        self.currentWord.font = NSFont(name: "HelveticaNeue-Light", size: 90)
                    }else if String(secondLast).rangeOfCharacter(from: quotationSet) != nil{
                        if arrayOfText[counter-1].characters.count==2 {
                            print("Closing quotation found")
                            currentWord.font = NSFont(name: "HelveticaNeue-LightItalic" , size: 90)
                        }else{
                            self.currentWord.font = NSFont(name: "HelveticaNeue-Light", size: 90)
                        }
                    }
                }
            }
            if String(arrayOfText[counter])?.range(of: ".") != nil{
                self.currentWord.stringValue = self.arrayOfText[self.counter]
                if self.counter > 0{
                    self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                }
                if self.counter <= self.numberOfWords - 2{
                    self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                }else{self.nextWord.stringValue = ""}
                self.counter += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + intervalTime + 0.2) {
                    self.reader()
                }
            }else if String(arrayOfText[counter])?.range(of: ",") != nil{
                self.currentWord.stringValue = self.arrayOfText[self.counter]
                if self.counter > 0{
                    self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                }
                if self.counter < self.numberOfWords - 1{
                    self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                }else{self.nextWord.stringValue = ""}
                self.counter += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + intervalTime + 0.1){
                    self.reader()
                }
            }else{
                if self.arrayOfText[self.counter].characters.count > 8{
                    self.currentWord.stringValue = self.arrayOfText[self.counter]
                    if self.counter > 0{
                        self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                    }
                    if self.counter <= self.numberOfWords - 2{
                        self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                    }else{self.nextWord.stringValue = ""}
                    self.counter += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + intervalTime + 0.05) {
                        self.reader()
                    }
                }else if self.arrayOfText[self.counter].characters.count > 5 {
                    self.currentWord.stringValue = self.arrayOfText[self.counter]
                    if self.counter > 0{
                        self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                    }
                    if self.counter <= self.numberOfWords - 2{
                        self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                    }else{self.nextWord.stringValue = ""}
                    self.counter += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + intervalTime + 0.01) {
                        self.reader()
                    }
                }else {
                    self.currentWord.stringValue = self.arrayOfText[self.counter]
                    if self.counter > 0{
                        self.prevWord.stringValue = self.arrayOfText[self.counter-1]
                    }
                    if self.counter <= self.numberOfWords - 2{
                        self.nextWord.stringValue = self.arrayOfText[self.counter+1]
                    }else{self.nextWord.stringValue = ""}
                    self.counter += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.intervalTime) {
                        self.reader()
                    }
                }
            }
        }
    }
    
}
