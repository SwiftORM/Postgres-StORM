//
//  PostgresConnect.swift
//  PerfectPostgresCRUD
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

import Foundation
import PerfectCRUD
import PostgreSQL

class PostgresConnect: Connect {
	// server connection
	private let server = PGConnection()

	/// Init with no credentials
	override init() {
		super.init()
		self.datasource = .Postgres
	}

	/// Init with credentials
	override init(_	ds: DataSource,
	            host: String,
	            username: String = "",
	            password: String = "",
	            port: Int = 0) {
		super.init()
		self.datasource = .Postgres
	}

	// Connection String
	private func connectionString() -> String {
		return "postgresql://\(credentials.username):\(credentials.password)@\(credentials.host):\(credentials.port)/\(database)"
	}

	// Initiates the connection
	private func connect() {
		let _ = server.connectdb(self.connectionString())
	}

	// Internal function which executes statements, with parameter binding
	// Returns raw result
	func exec(_ statement: String, params: [String]) -> PGResult {
		self.connect()
		return server.exec(statement: statement, params: params)
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	func execRows(_ statement: String, params: [String]) -> [Any] {
		self.connect()
		defer { server.close() }
		let result = server.exec(statement: statement, params: params )

		var rows = [(Any)]()

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
			rows.append(vals)
		}
		result.clear()
		return rows
	}





}
