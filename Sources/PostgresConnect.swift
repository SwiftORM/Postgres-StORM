//
//  PostgresConnect.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

import Foundation
import StORM
import PostgreSQL

class PostgresConnect: Connect {
	// server connection
	
	private let server = PGConnection()
	public var rows = StORMResultSet()


	/// Init with no credentials
	override init() {
		super.init()
		self.datasource = .Postgres
	}

	/// Init with credentials
	public init(
	            host: String,
	            username: String = "",
	            password: String = "",
	            database: String = "",
	            port: Int = 0) {
		super.init()
		self.database = database
		self.datasource = .Postgres
		self.credentials = DataSourceCredentials(host: host, port: port, user: username, pass: password)
	}

	// Connection String
	private func connectionString() -> String {
		return "postgresql://\(credentials.username):\(credentials.password)@\(credentials.host):\(credentials.port)/\(database)"
	}

	// Initiates the connection
	private func connect() {
		let status = server.connectdb(self.connectionString())
		if status != .ok {
			print(status)
			resultCode = .database
		} else {
			resultCode = .noError
		}
	}

	// Internal function which executes statements, with parameter binding
	// Returns raw result
	func exec(_ statement: String, params: [String]) -> PGResult {
		self.connect()
		defer { server.close() }
		self.statement = statement
		return server.exec(statement: statement, params: params)
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	func execRows(_ statement: String, params: [String]) -> [StORMRow] {
		self.connect()
		defer { server.close() }
		self.statement = statement
		let result = server.exec(statement: statement, params: params )
		let resultRows = parseRows(result)
		result.clear()
		return resultRows
	}


}


extension PostgresConnect {
	fileprivate func parseRows(_ result: PGResult) -> [StORMRow] {
		var resultRows = [StORMRow]()

		let num = result.numTuples()

		for x in 0..<num { // rows
			var vals = [String: Any]()

			for f in 0..<result.numFields() {

				switch PostgresMap(Int(result.fieldType(index: f)!)) {
				case "Int":
					vals[result.fieldName(index: f)!] = result.getFieldInt(tupleIndex: x, fieldIndex: f)
				case "Bool":
					vals[result.fieldName(index: f)!] = result.getFieldBool(tupleIndex: x, fieldIndex: f)
				case "String":
					vals[result.fieldName(index: f)!] = result.getFieldString(tupleIndex: x, fieldIndex: f)
					// json
					// xml
					// float
					// date
					// time
					// timestamp
					// timestampz
				// jsonb
				default:
					vals[result.fieldName(index: f)!] = result.getFieldString(tupleIndex: x, fieldIndex: f)
				}

			}
			let thisRow = StORMRow()
			thisRow.data = vals
			resultRows.append(thisRow)
		}
		return resultRows
	}
}
