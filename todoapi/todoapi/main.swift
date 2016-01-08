
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

app.use(Logger())

app.use(BodyParser())

// http --verbose POST localhost:3000/user/sum x-auth:uuuu a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/user/sum x-auth:uuuu a:=1 -> Bad Request
// http --verbose PUT localhost:3000/user/sum x-auth:uuuu a:=1 b:=2 (using MySQL)
app.use(Mount("/user", Route("/sum", SumController())))

// http --verbose POST localhost:3000/user x-auth:user a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/user x-auth:uuuu a:=1 b:=2 -> Forbidden
app.use(Mount("/user", AuthUser(authAs: "user") >>> UserController()))

// Nested Mount
// http --verbose POST localhost:3000/dev/user x-auth:user a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/dev/user x-auth:uuuu a:=1 b:=2 -> Forbidden
app.use( Mount("/dev", Mount("/user", AuthUser(authAs: "user") >>> UserController()) ))

// http --verbose POST localhost:3000/private/something x-auth:private a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/private/something x-auth:pppp a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/private/1234 x-auth:private a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/private/1234 x-auth:pppp a:=1 b:=2 -> Forbidden
app.use(Mount("/private", compose(
    Route("/something", PrivateController(name: "something") ),
    Route("/:id", AuthUser(authAs: "private") >>> PrivateController(name: "by id"))
    ) ))


let server = Server(port: 3000, responder: app.responder)
print("listening...")
server.start()

