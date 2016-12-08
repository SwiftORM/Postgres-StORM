//
//  Upsert.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import StORM
import PerfectLogger

/// An extention ot the main class that provides PostgreSQL-specific "upsert" functionality.
extension PostgresStORM {

	/// Inserts the row with the specified data, on conflict (conflickkeys columns) it will perform an update.
	/// Specify matching arrays of columns and parameters, and an array of conflict key columns.
	public func upsert(cols: [String], params: [Any], conflictkeys: [String]) throws {

		var paramsString = [String]()
		var substString = [String]()
		var upsertString = [String]()
		for i in 0..<params.count {
			paramsString.append(String(describing: params[i]))
			substString.append("$\(i+1)")

			if i >= conflictkeys.count {
				upsertString.append("\"\(String(describing: cols[i]))\" = $\(i+1)")
			}
		}
		let colsjoined = "\"" + cols.joined(separator: "\",\"") + "\""
		let conflictcolsjoined = "\"" + conflictkeys.joined(separator: "\",\"") + "\""
		let str = "INSERT INTO \(self.table()) (\(colsjoined)) VALUES(\(substString.joined(separator: ","))) ON CONFLICT (\(conflictcolsjoined)) DO UPDATE SET \(upsertString.joined(separator: ","))"
		do {
			try exec(str, params: paramsString)
		} catch {
			LogFile.error("Error msg: \(error)", logFile: "./StORMlog.txt")
			self.error = StORMError.error("\(error)")
			throw error
		}
	}
}
