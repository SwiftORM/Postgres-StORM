//
//  Upsert.swift
//  PerfectPostgresCRUD
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation
import StORM
import PostgreSQL


extension PostgresConnect {
	
	public func upsert(table: String, cols: [String], vals: [Any], conflictkeys: [String]) {
		self.table = table
		
		// PostgreSQL specific insert staement exec
		var valsString = [String]()
		var substString = [String]()
		var upsertString = [String]()
		for i in 0..<vals.count {
			valsString.append(String(describing: vals[i]))
			substString.append("$\(i+1)")

			if i >= conflictkeys.count {
				upsertString.append("\(String(describing: cols[i])) = $\(i+1)")

			}

		}
		let str = "INSERT INTO \(table) (\(cols.joined(separator: ","))) VALUES(\(substString.joined(separator: ","))) ON CONFLICT (\(conflictkeys.joined(separator: ","))) DO UPDATE SET \(upsertString.joined(separator: ","))"
		let _ = exec(str, params: valsString)
	}

}
