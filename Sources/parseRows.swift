//
//  parseRows.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-06.
//
//

import StORM
import PostgreSQL
import PerfectLib
import PerfectXML
import Foundation

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
				case "json":
					let output = result.getFieldString(tupleIndex: x, fieldIndex: f)
					do {
						params[result.fieldName(index: f)!] = try output?.jsonDecode() as? [String:Any]
					} catch {
						params[result.fieldName(index: f)!] = [String:Any]()
					}
				case "jsonb":
					let output = result.getFieldString(tupleIndex: x, fieldIndex: f)
					do {
						params[result.fieldName(index: f)!] = try output?.jsonDecode() as? [String:Any]
					} catch {
						params[result.fieldName(index: f)!] = [String:Any]()
					}
				case "xml":
					// will create an XML object
					params[result.fieldName(index: f)!] = XDocument(fromSource: result.getFieldString(tupleIndex: x, fieldIndex: f)!)
				case "float":
					params[result.fieldName(index: f)!] = result.getFieldFloat(tupleIndex: x, fieldIndex: f)

				case "date":
					let output = result.getFieldString(tupleIndex: x, fieldIndex: f)
					let formatter = DateFormatter()
					formatter.dateFormat = "yyyy/MM/dd hh:mm Z"
					params[result.fieldName(index: f)!] = formatter.date(from: output!)

					// time
					// timestamp
					// timestampz
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
