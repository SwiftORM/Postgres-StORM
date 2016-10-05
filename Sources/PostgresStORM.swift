//
//  PostgreStORM.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-03.
//
//

import StORM
import PostgreSQL

open class PostgresStORM: StORM {
	open var connection = PostgresConnect()

	// table
	open var table = ""
	// table structure
	//open var cols = [String: String]()

	// Internal function which executes statements, with parameter binding
	// Returns raw result
	func exec(_ statement: String, params: [String]) -> PGResult {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		return connection.server.exec(statement: statement, params: params)
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	func execRows(_ statement: String, params: [String]) -> [StORMRow] {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		let result = connection.server.exec(statement: statement, params: params )
		let resultRows = parseRows(result)
		result.clear()
		return resultRows
	}


}


extension PostgresStORM {
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
