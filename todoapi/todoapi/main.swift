
import MySQL
import swiftra
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

app.use(MethodOverride())

//app.use(AdditionalResponseHeader())

//app.use(Logger())

app.use(BodyParser())


// Controller Style Handler
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


// Closure Style Handler
let router = Router()
router.get("/test") { ctx in
    return .Respond(Response("here is test"))
}

// http --verbose PUT localhost:3000/hello
router.all("/hello") { ctx in
    return .Respond(Response("world as \(ctx.method)"))
}
app.use(router)

// http --verbose POST localhost:3000/private/something x-auth:private a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/private/something x-auth:pppp a:=1 b:=2 -> 200 OK
// http --verbose POST localhost:3000/private/1234 x-auth:private a:=1 b:=2 -> 200 OK ["id": "1234"]
// http --verbose POST localhost:3000/private/1234 x-auth:pppp a:=1 b:=2 -> Forbidden
app.use(Mount("/private", compose(
    Route("/something", PrivateController(name: "something") ),
    Route("/:id", AuthUser(authAs: "private") >>> PrivateController(name: "by id"))
    ) ))

// List: http --verbose "localhost:3000/todo?count=100"
// Create: http --verbose localhost:3000/todo title=Hello
app.use( Route("/todo", TodoListController()) )


// Get: http --verbose localhost:3000/todo/1
// Put: http --verbose PUT localhost:3000/todo/1 title=World done:=false
// Delete: http --verbose DELETE localhost:3000/todo/1
// Delete: http --verbose POST localhost:3000/todo/1 X-HTTP-Method-Override:DELETE
app.use( Route("/todo/:id", TodoController()) )


//let server = Server(port: 3000, responder: app.responder)
print("listening...")
//server.start()
swiftra.serve(3000, app.dispatcher)

