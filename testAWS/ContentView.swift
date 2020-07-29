//
//  ContentView.swift
//  testAWS
//
//  Created by 何星緯 on 2020/7/28.
//  Copyright © 2020 davis. All rights reserved.
//

import SwiftUI
import Amplify
import AmplifyPlugins

struct ContentView: View {
    @State var date = Date()
    @State var name : String = ""
    @State var msg : String = ""
    
    var body: some View {
        ZStack(alignment: .top){
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                Text("ASW Test Hello, World!")
                TextField("date", text: $name)
                TextField("msg", text: $msg)
                HStack{
                    Button(action: insert, label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                    Button(action: list, label: {
                        Image(systemName: "list.dash")
                            .padding()
                            .background(Color.purple)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                    Button(action: update, label: {
                        Image(systemName: "pencil.and.outline")
                            .padding()
                            .background(Color.orange)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                    Button(action: delete, label: {
                        Image(systemName: "minus")
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                }
                
            }
        }
        .onAppear {
            self.list()
        }
    }
    
    func list() {
        Amplify.DataStore.query(Todo.self, completion: { result in
            switch(result) {
            case .success(let todos):
                var count = 0
                for todo in todos {
                    count+=1
                    print("==== TODO LIST \(count) ====")
                    print("Name: \(todo.name)")
                    print("Messenger: \(todo.msg)")
                    if let priority = todo.priority {
                        print("Priority: \(priority)")
                    }
                    if let description = todo.description {
                        print("Description: \(description)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        })
    }
    
    func insert() {
        let item = Todo(name: self.name, msg: self.msg)
        Amplify.DataStore.save(item) { (result) in
            switch(result) {
            case .success(let savedItem):
                print("==== INSERT ====")
                print("Saved item: \(savedItem.name)")
                print("Messenger: \(savedItem.msg)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")
            }
        }
    }
    
    func update() {
        Amplify.DataStore.query(Todo.self,
            where: Todo.keys.name.eq(self.name),
            completion: { result in
                switch(result) {
                case .success(let todos):
                    guard todos.count == 1, var updatedTodo = todos.first else {
                        print("Did not find exactly one todo, bailing")
                        return
                    }
                    updatedTodo.msg = self.msg
                    Amplify.DataStore.save(updatedTodo,
                                           completion: { result in
                                            switch(result) {
                                            case .success(let savedTodo):
                                                print("==== UPDATE ====")
                                                print("Updated item: \(savedTodo.name )")
                                                print("Messenger: \(savedTodo.msg )")
                                            case .failure(let error):
                                                print("Could not update data in Datastore: \(error)")
                                            }
                    })
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
                }
        })
    }
    func delete() {
         Amplify.DataStore.query(Todo.self,
                                 where: Todo.keys.name.eq(self.name),
                                 completion: { result in
             switch(result) {
             case .success(let todos):
                 guard todos.count == 1, let toDeleteTodo = todos.first else {
                     print("Did not find exactly one todo, bailing")
                     return
                 }
                 Amplify.DataStore.delete(toDeleteTodo,
                                          completion: { result in
                                             switch(result) {
                                             case .success:
                                                 print("Deleted item: \(toDeleteTodo.name)")
                                             case .failure(let error):
                                                 print("Could not update data in Datastore: \(error)")
                                             }
                 })
             case .failure(let error):
                 print("Could not query DataStore: \(error)")
             }
        })
    }
}
extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
