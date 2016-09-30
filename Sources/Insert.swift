//
//  Insert.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation
import StORM
import PostgreSQL

extension PostgresConnect {

	public func insert(table: String, cols: [String], vals: [Any]) {
		self.table = table
		// PostgreSQL specific insert staement exec
		var valsString = [String]()
		var substString = [String]()
		for i in 0..<vals.count {
			valsString.append(String(describing: vals[i]))
			substString.append("$\(i+1)")
		}
		let str = "INSERT INTO \(table) (\(cols.joined(separator: ","))) VALUES(\(substString.joined(separator: ",")))"
		let _ = exec(str, params: valsString)
	}


}
