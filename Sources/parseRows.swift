//
//  parseRows.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-06.
//
//

import StORM
import PostgreSQL

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
