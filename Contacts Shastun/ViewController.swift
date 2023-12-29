//
//  ViewController.swift
//  Contacts Shastun
//
//  Created by Глеб Капустин on 15.11.2023.
//

import UIKit

fileprivate let reuseIdentifierCell = "contactCellIdentifier"

class ViewController: UIViewController {
    var storage: ContactStorageProtocol!
    
    private var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort { $0.title < $1.title }
            storage.save(contacts: contacts)
        }
    }

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = ContactStorage()
        
        loadContacts()
    }

    private func loadContacts() { 
        contacts = storage.load()
    }

    @IBAction func showNewContactAlert(){
        let alertController = UIAlertController(
            title: "Создайте новый контакт",
            message: "Введите имя и телефон",
            preferredStyle: .alert)
            
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        
        let createAction = UIAlertAction(title: "Создать",
                                         style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else {
                return
            }
            
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
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
