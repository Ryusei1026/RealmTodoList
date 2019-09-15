//
//  TodoItem.swift
//  RealmTodo
//
//  Created by 高野隆正 on 2019/09/15.
//  Copyright © 2019 高野隆正. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title = ""
}
