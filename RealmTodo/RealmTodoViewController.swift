//
//  ViewController.swift
//  RealmTodo
//
//  Created by 高野隆正 on 2019/09/15.
//  Copyright © 2019 高野隆正. All rights reserved.
//

import UIKit
import RealmSwift

class RealmTodoViewController: UIViewController {

    private var realm: Realm!
    private var todoList: Results<TodoItem>!
    private var token: NotificationToken!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        realm = try! Realm()
        todoList = realm.objects(TodoItem.self)
        token = todoList.observe { [weak self] _ in
            self?.reload()
        }
    }
    
    deinit {
        token.invalidate()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let dialog = UIAlertController(title: "新規Todo", message: "", preferredStyle: .alert)
        dialog.addTextField(configurationHandler: nil)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            guard let text = dialog.textFields![0].text else {return}
            self.addTodoItem(title: text)
            }))
        present(dialog, animated: true, completion: nil)
    }
    
    func addTodoItem(title: String) {
        try! realm.write {
            realm.add(TodoItem(value: ["title": title]))
        }
    }
    
    func deleteTodoItem(at index: Int) {
        try! realm.write {
            realm.delete(todoList[index])
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        realm = try! Realm()
        todoList = realm.objects(TodoItem.self)
        token = todoList.observe { [weak self] _ in
            self?.reload()
        }
    }
}

extension RealmTodoViewController: UITableViewDelegate {
}

extension RealmTodoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteTodoItem(at: indexPath.row)
    }
    
}

