//
//  JSONViewViewController.swift
//  Codable Document
//
//  Created by Liam Flaherty on 4/19/19.
//  Copyright © 2019 Liam Flaherty. All rights reserved.
//

import UIKit

class JSONViewViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = ""
        textView.text = loadJSON()
    }

    func loadJSON()->String{
        var returnString = ""
        if let documentData = documentLoader.load(){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            
            returnString += "UUID: " + documentData.uuid + "\n"
            returnString += "Dates:\n"
            returnString += "Created " + formatter.string(from: documentData.dates.created!) + "\n"
            returnString += "Updated " + formatter.string(from: documentData.dates.updated!) + "\n"
            returnString += documentData.title + "\n"
            returnString += documentData.summary + "\n"
            returnString += "Metadata\n"
            for topic in documentData.metadata.topic{
                returnString += "   " + topic.0 + topic.1 + "\n"
            }
             returnString += "Authors \n"
            for author in documentData.authors{
                returnString += "   Name: " + author.name + "\n"
                returnString += "   Contribution: " + author.contribution + "\n"
                
                for contact in author.contacts{
                    returnString += "      " + contact.label + "\n"
                    returnString += "      " + contact.method + "\n"
                    returnString += "      " + contact.contactInfo + "\n"
                }
            }
            returnString += "Copyright \n"
            returnString += "   Owner: " + documentData.copyright.owner + "\n"
            returnString += "   License: " + documentData.copyright.license + "\n"
            returnString += "   Start Year: " + String(documentData.copyright.startYear) + "\n"
            returnString += "   End Year: " + String(documentData.copyright.endYear) + "\n"
            
            for entity in documentData.entities{
                returnString += "   " + entity.type + "\n"
                if(entity.label != nil){
                    returnString += "   " + entity.label! + "\n"
                }
                if(entity.source != nil){
                    returnString += "       URL: " + entity.source!.url + "\n"
                }
                if(entity.content != nil){
                    returnString += "       Encoding: " + entity.content!.contentEncoding + "\n"
                    returnString += "       Content Type: " + entity.content!.contentType + "\n"
                    returnString += "       Data: " + entity.content!.data + "\n"
                }
                if(entity.properties != nil){
                    returnString += "       Property: " + entity.properties!.property!.Key + " " + entity.properties!.property!.Value + "\n"
                }
               
            }
            
        }
        else{
            returnString = "Document did not load"
        }
        
        return returnString
    }
    


}
