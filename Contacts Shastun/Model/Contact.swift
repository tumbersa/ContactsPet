//
//  Contact.swift
//  Contacts Shastun
//
//  Created by Глеб Капустин on 27.12.2023.
//

import Foundation

protocol ContactProtocol {
    /// Имя
    var title: String { get set }
    /// Номер телефона
    var phone: String { get set }
}

struct Contact: ContactProtocol { 
    var title: String
    var phone: String
}
