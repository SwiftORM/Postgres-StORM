//
//  parseRows.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-10-06.
//
//

import StORM
import PerfectPostgreSQL
import PerfectLib
//import PerfectXML
import Foundation

/// Supplies the parseRows method extending the main class.
extension PostgresStORM {
	
	/// parseRows takes the [String:Any] result and returns an array of StormRows
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
                        let decode = try output?.jsonDecode()
                        // Here we are first trying to cast into the traditional json return.  However, when using the json_agg function, it will return an array.  The following considers both cases.
                        params[result.fieldName(index: f)!] = decode as? [String:Any] ?? decode as? [[String:Any]]
					} catch {
						params[result.fieldName(index: f)!] = [String:Any]()
					}
				case "jsonb":
					let output = result.getFieldString(tupleIndex: x, fieldIndex: f)
					do {
                        let decode = try output?.jsonDecode()
                        // Here we are first trying to cast into the traditional json return.  However, when using the jsonb_agg function, it will return an array.  The following considers both cases.
						params[result.fieldName(index: f)!] = decode as? [String:Any] ?? decode as? [[String:Any]]
					} catch {
						params[result.fieldName(index: f)!] = [String:Any]()
					}
//				case "xml":
//					// will create an XML object
//					params[result.fieldName(index: f)!] = XDocument(fromSource: result.getFieldString(tupleIndex: x, fieldIndex: f)!)
				case "float":
					params[result.fieldName(index: f)!] = result.getFieldFloat(tupleIndex: x, fieldIndex: f)

				case "date":
					let output = result.getFieldString(tupleIndex: x, fieldIndex: f)
					let formatter = DateFormatter()
					formatter.dateFormat = "yyyy/MM/dd hh:mm Z"
                    if let output = output {
                        params[result.fieldName(index: f)!] = formatter.date(from: output)
                    }

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
