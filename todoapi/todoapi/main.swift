
import MySQL
import HTTP
import Epoch
import Kunugi

// Provide DB options as following in Constants.swift
/*

struct DBOptions: ConnectionOption {
    let host: String = "db.host.example"
    let port: Int = 3306
    let user: String = ""
    let password: String = ""
    let database: String = "test"
}

*/


let app = App()

app.use(BodyParser())

// List: http --verbose "localhost:3000/todo?count=100"
// Create: http --verbose localhost:3000/todo title=Hello
app.use( Route("/todo", TodoListController()) )


// Get: http --verbose localhost:3000/todo/1
// Put: http --verbose PUT localhost:3000/todo/1 title=World done:=false
// Delete: http --verbose DELETE localhost:3000/todo/1
app.use( Route("/todo/:id", TodoController()) )


app.prepare()

let server = Server(port: 3000, responder: app.responder)
print("listening...")
server.start()

