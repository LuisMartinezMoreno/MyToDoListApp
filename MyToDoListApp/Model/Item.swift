//
//  Item.swift
//  MyToDoListApp
//
//  Created by Luis Martínez Moreno on 2/2/21.
//

import Foundation
class Item: Codable{
    var name: String
    var id: Int
    var descripcion: String
    var date: Date
    var imagen : Data
    
    
    enum CodingKeys: CodingKey {
        case name, id, descripcion, date, imagen
    }
    
    init(name: String,  descripcion: String, id: Int, date: Date, imagen: Data) {
        self.name = name
        self.descripcion = descripcion
        self.id = id
        self.date = date
        self.imagen = imagen
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(descripcion, forKey: .descripcion)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(imagen, forKey: .imagen)
    }
    
    
}
