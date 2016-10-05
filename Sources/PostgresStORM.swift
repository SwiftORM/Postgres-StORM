//
//  PostgreStORM.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-03.
//
//

import StORM
import PostgreSQL

open class PostgresStORM: StORM, StORMProtocol {
	open var connection = PostgresConnect()

	// table
	open var table = ""
	// table structure
	//open var cols = [String: String]()

	// Internal function which executes statements, with parameter binding
	// Returns raw result
	@discardableResult
	func exec(_ statement: String, params: [String]) throws -> PGResult {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		let result = connection.server.exec(statement: statement, params: params)
		// set exec message
		errorMsg = connection.server.errorMessage().trimmingCharacters(in: .whitespacesAndNewlines)
		if isError() {
			throw StORMError.error(errorMsg)
		}
		return result
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	@discardableResult
	func execRows(_ statement: String, params: [String]) throws -> [StORMRow] {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		let result = connection.server.exec(statement: statement, params: params)

		// set exec message
		errorMsg = connection.server.errorMessage().trimmingCharacters(in: .whitespacesAndNewlines)
		if isError() {
			throw StORMError.error(errorMsg)
		}

		let resultRows = parseRows(result)
		result.clear()
		return resultRows
	}


	func isError() -> Bool {
		if errorMsg.contains(string: "ERROR") {
			print(errorMsg)
			return true
		}
		return false
	}

	open func to(_ this: StORMRow) {
//		id				= this.data["id"] as! Int
//		firstname		= this.data["firstname"] as! String
//		lastname		= this.data["lastname"] as! String
//		email			= this.data["email"] as! String
	}

//	open func rows() -> [Any] {
//		return []
//	}
	open func makeRow() {
		self.to(self.results.rows[0])
	}

}


extension PostgresStORM {
	public func parseRows(_ result: PGResult) -> [StORMRow] {
		var resultRows = [StORMRow]()

		let num = result.numTuples()

		for x in 0..<num { // rows
			var params = [String: Any]()

			for f in 0..<result.numFields() {

				switch PostgresMap(Int(result.fieldType(index: f)!)) {
				case "Int":
					params[result.fieldName(index: f)!] = result.getFieldInt(tupleIndex: x, fieldIndex: f)
				case "Bool":
					params[result.fieldName(index: f)!] = result.getFieldBool(tupleIndex: x, fieldIndex: f)
				case "String":
					params[result.fieldName(index: f)!] = result.getFieldString(tupleIndex: x, fieldIndex: f)
					// json
					// xml
					// float
					// date
					// time
					// timestamp
					// timestampz
				// jsonb
				default:
					params[result.fieldName(index: f)!] = result.getFieldString(tupleIndex: x, fieldIndex: f)
				}

			}
			let thisRow = StORMRow()
			thisRow.data = params
			resultRows.append(thisRow)
		}
		return resultRows
	}
}
