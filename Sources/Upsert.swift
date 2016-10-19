//
//  Upsert.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import StORM


extension PostgresStORM {
	
	public func upsert(cols: [String], params: [Any], conflictkeys: [String]) throws {

		// PostgreSQL specific insert staement exec
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
			self.error = StORMError.error(error.localizedDescription)
			throw error
		}

	}

}
