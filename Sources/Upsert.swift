//
//  Upsert.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation
import StORM
import PostgreSQL


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
				upsertString.append("\(String(describing: cols[i])) = $\(i+1)")

			}

		}
		let str = "INSERT INTO \(self.table) (\(cols.joined(separator: ","))) VALUES(\(substString.joined(separator: ","))) ON CONFLICT (\(conflictkeys.joined(separator: ","))) DO UPDATE SET \(upsertString.joined(separator: ","))"
		do {
			try exec(str, params: paramsString)
		} catch {
			throw StORMError.error(error.localizedDescription)
		}

	}

}
