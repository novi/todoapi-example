
import MySQL
import HTTP
import Core
import Epoch
//import CHTTPParser
//import CLibvenice
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

app.use(Logger())

app.use(BodyParser())

app.use(Mount("/user", compose(
    Route("/sum", SumController()),
    AuthUser(authAs: "user") >>> UserController()
    )
))
app.use(Mount("/private", compose(
    Route("/something", PrivateController(name: "something") ),
    Route("/:id", AuthUser(authAs: "private") >>> PrivateController(name: "by id"))
    ) ))


let server = Server(port: 3000, responder: app.responder)
print("listening...")
server.start()

