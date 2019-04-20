//
//  document.swift
//  Codable Document
//
//  Created by Liam Flaherty on 4/18/19.
//  Copyright © 2019 Liam Flaherty. All rights reserved.
//

import Foundation

struct Document: Decodable{
     var uuid : String
     var dates : dateJSON
     var title : String
     var summary : String
     var metadata : metaDataStruct
     var authors : [authorStruct]
     var copyright : copyrightStruct
     var entities : [entitiesStruct]
 
     enum CodingKeys: String, CodingKey {
        case uuid
        case dates
        case title
        case summary
        case metadata
        case authors
        case copyright
        case entities
     }
 }

struct authorStruct : Decodable {
    var name : String
    var contribution : String
    var contacts : [contactStruct]
    
    enum CodingKeys: String, CodingKey {
        case name
        case contribution
        case contacts
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        contribution = try values.decode(String.self, forKey: .contribution)
        contacts = try values.decode([contactStruct].self, forKey: .contacts)
    }
    
}

struct contactStruct : Decodable {
    var method : String
    var label : String
    var contactInfo : String
  //  var number : String?
    
    enum CodingKeys : String, CodingKey {
        case method
        case label
        case address
        case number
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        method = try values.decode(String.self, forKey: .method)
        label = try values.decode(String.self, forKey: .label)
        
        if(values.contains(CodingKeys.address)){
            contactInfo = try values.decode(String.self, forKey: .address)
        }
        else{
            contactInfo = try values.decode(String.self, forKey: .number)
        }
    }
}

struct entitiesStruct : Decodable{
    var type : String
    var label : String?
    var content : contentStruct?
    var properties : propertieStruct?
    var source : sourceStruct?
    
    enum CodingKeys : String, CodingKey {
        case type
        case label
        case content
        case properties
        case source
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        if(type == "header"){
            label = try values.decode(String.self, forKey: .label)
            content = try values.decode(contentStruct.self, forKey: .content)
            properties = try values.decode(propertieStruct.self, forKey: .properties)
        }
        else if(type == "paragraph"){
            content = try values.decode(contentStruct.self, forKey: .content)
        }
        else{
            label = try values.decode(String.self, forKey: .label)
            source = try values.decode(sourceStruct.self, forKey: .source)
            properties = try values.decode(propertieStruct.self, forKey: .properties)
        }
    
    }
}

struct sourceStruct : Decodable {
    var url : String
    
    enum CodingKeys : String, CodingKey {
        case url
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
    }
}

struct contentStruct : Decodable{
    var contentType : String
    var contentEncoding : String
    var data : String
    
    enum CodingKeys : String, CodingKey {
        case contentType = "content-type"
        case contentEncoding = "content-encoding"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try values.decode(String.self, forKey: .contentType)
        contentEncoding = try values.decode(String.self, forKey: .contentEncoding)
        data = try values.decode(String.self, forKey: .data)
    }
}


struct propertieStruct : Decodable {
    var property : (Key : String, Value: String)?
    
    enum CodingKeys : String, CodingKey {
        case size
        case width
        case height
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let keys = values.allKeys
        for key in keys {
            if let test = try? values.decode(Int.self, forKey: key) {
                let turntoString = String(test)
                property = (Key : key.stringValue, Value : turntoString)
            } else {
                let test = try values.decode(String.self, forKey: key)
                property = (Key : key.stringValue, Value : test)
            }
            
        }
    }
}

struct copyrightStruct : Decodable{
    var owner : String
    var startYear : Int
    var endYear : Int
    var license : String
    
    enum CodingKeys: String, CodingKey {
        case owner
        case startYear = "start-year"
        case endYear = "end-year"
        case license
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        owner = try values.decode(String.self, forKey: .owner)
        startYear = try values.decode(Int.self, forKey: .startYear)
        endYear = try values.decode(Int.self, forKey: .endYear)
        license = try values.decode(String.self, forKey: .license)
    }
    
}


struct metaDataStruct : Decodable{
    var topic = [(key: String, value: String)]()
    
    enum CodingKeys: String, CodingKey {
        case topic
        case field
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let test = values.allKeys
        for key in test {
            let test = try values.decodeIfPresent(String.self, forKey: key)
            let tuple = (key.stringValue, test!)
            topic.append(tuple)
        }
    }
    
}

struct dateJSON : Decodable {
    var created : Date?
    var updated : Date?
    
    enum CodingKeys: String, CodingKey {
        case created
        case updated
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        created = try dateFormatter.date(from: values.decode(String.self, forKey: .created))
        updated = try dateFormatter.date(from: values.decode(String.self, forKey: .updated))
    }
    
}

class documentLoader{
    
    class func load() -> Document? {
        let jsonFileName = "document1"
        var documentJSON : Document?
        let jsonDecoder = JSONDecoder()
        
        if let jsonFileUrl = Bundle.main.url(forResource: jsonFileName, withExtension: ".json"),
            let jsonData = try? Data(contentsOf: jsonFileUrl) {
                documentJSON = try? jsonDecoder.decode(Document.self, from: jsonData)
            }
        
        return documentJSON
    }
}


