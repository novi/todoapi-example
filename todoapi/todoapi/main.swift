
import MySQL
import HTTP
import Epoch
import CHTTPParser
import CLibvenice

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


let pool = ConnectionPool(options: DBOptions())

struct Row {
    struct MathResult: QueryRowResultType {
        let val: Int
        static func decodeRow(r: MySQL.QueryRowResult) throws -> MathResult {
            return try build(MathResult.init)(
                r <| 0
            )
        }
    }
}

struct ServerResponder: ResponderType {
    func respond(request: Request) -> Response {
        do {
            let rows:[Row.MathResult] = try pool.execute{ conn in
                try conn.query("SELECT 1 + 3 as val;")
            }
            if rows.count != 1 {
                NSLog("%@", "row count invalid \(rows.count)")
            }
            return Response(status: .OK, body: "\(rows.count) - \(rows[0].val)")
        } catch (let e) {
             NSLog("%@", "\(e)")
            return Response(status: .InternalServerError)
        }
    }
}

let responder = ServerResponder()
let server = Server(port: 3000, responder: responder)
server.start()
