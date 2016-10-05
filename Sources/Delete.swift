//
//  Delete.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import PerfectLib
import StORM
import PostgreSQL

// TODO:  detect response and return t/f as appropriate

extension PostgresStORM {

	func deleteSQL(_ table: String, idName: String = "id", limit: Int = 1) -> String {
		return "DELETE FROM \(table) WHERE \(idName) = $1 LIMIT \(limit)"
	}

	/// Deletes one row, with an id as an integer
	public func delete(id: Int, idName: String = "id", limit: Int = 1) -> Bool {
		let _ = exec(deleteSQL(self.table, idName: idName, limit: limit), params: [String(id)])
		return true
	}

	/// Deletes one row, with an id as a String
	public func delete(id: String, idName: String = "id", limit: Int = 1) -> Bool {
		let _ = exec(deleteSQL(self.table, idName: idName, limit: limit), params: [id])
		return true
	}

	/// Deletes one row, with an id as a UUID
	public func delete(id: UUID, idName: String = "id", limit: Int = 1) -> Bool {
		let _ = exec(deleteSQL(self.table, idName: idName, limit: limit), params: [id.string])
		return true
	}

}
