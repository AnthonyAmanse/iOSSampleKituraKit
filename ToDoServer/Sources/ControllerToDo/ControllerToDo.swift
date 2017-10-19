/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Kitura
import KituraCORS
import Foundation
import Models
import SafetyContracts

public var port: Int = 8080

public class ControllerToDo {
    
    let router = Router()
    var todoStore = [ToDo]()
    
    func setup() {
        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
        
        // ToDoListBackend Routes
        router.post("/", handler: createHandler)
        router.get("/", handler: getAllHandler)
        router.get("/", handler: getOneHandler)
        router.delete("/", handler: deleteAllHandler)
        router.delete("/", handler: deleteOneHandler)
        router.patch("/", handler: updateHandler)
        //No need for a put, as we have all the bases covered with these.

    }
    
    
    public init() {

    }
    
    public func run() {
        setup()
        Kitura.addHTTPServer(onPort: port, with: router)
        Kitura.run()
    }
    
    func createHandler(todo: ToDo, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        var todo = todo
        if todo.completed == nil {
            todo.completed = false
        }
        let id = todoStore.count
        todo.url = "http://localhost:8080/\(id)"
        todoStore.append(todo)
        completion(todo, nil)
    }
    
    func getAllHandler(completion: ([ToDo]?, ProcessHandlerError?) -> Void ) -> Void {
        completion(todoStore, nil)
    }
    
    func getOneHandler(id: Item, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        completion(todoStore[id.id], nil)
    }
    
    func deleteAllHandler(completion: (ProcessHandlerError?) -> Void ) -> Void {
        todoStore = [ToDo]()
        completion(nil)
    }
    
    func deleteOneHandler(id: Item, completion: (ProcessHandlerError?) -> Void ) -> Void {
        todoStore.remove(at: id.id)
        completion(nil)
    }
    
    func updateHandler(id: Item, new: ToDo, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        var current = todoStore[id.id]
        current.user = new.user ?? current.user
        current.order = new.order ?? new.order
        current.title = new.title ?? current.title
        current.completed = new.completed ?? current.completed
        todoStore[id.id] = current
        completion(todoStore[id.id], nil)
    }
    
}