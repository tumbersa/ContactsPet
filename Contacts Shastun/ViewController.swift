//
//  ViewController.swift
//  Contacts Shastun
//
//  Created by Глеб Капустин on 15.11.2023.
//

import UIKit

fileprivate let reuseIdentifierCell = "contactCellIdentifier"

class ViewController: UIViewController {
    private var contacts = [ContactProtocol]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadContacts()
    }

    private func loadContacts() { 
        contacts.append(
    Contact(title: "Саня Техосмотр", phone: "+799912312323")) 
        contacts.append(
    Contact(title: "Владимир Анатольевич", phone: "+781213342321")) 
        contacts.append(
    Contact(title: "Сильвестр", phone: "+7000911112")) 
        contacts.sort{ $0.title < $1.title }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell) {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifierCell)
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = contacts[indexPath.row].title
            configuration.secondaryText = contacts[indexPath.row].phone
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = contacts[indexPath.row].title + "/n" + contacts[indexPath.row].phone
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Определяем доступные действия для строки \(indexPath.row)") 
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions

    }
}
