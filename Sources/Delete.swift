//
//  Delete.swift
//  PerfectPostgresCRUD
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import PerfectLib
import StORM
import PostgreSQL

// TODO:  detect response and return t/f as appropriate

extension PostgresConnect {

	private func deleteSQL(_ table: String, idName: String = "id", limit: Int = 1) -> String {
		self.table = table
		return "DELETE FROM \(table) WHERE \(idName) = $1 LIMIT \(limit)"
	}

	/// Deletes one row, with an id as an integer
	public func delete(_ table: String, id: Int, idName: String = "id", limit: Int = 1) -> Bool {
		self.table = table
		let _ = exec(deleteSQL(table, idName: idName, limit: limit), params: [String(id)])
		return true
	}

	/// Deletes one row, with an id as a String
	public func delete(_ table: String, id: String, idName: String = "id", limit: Int = 1) -> Bool {
		self.table = table
		let _ = exec(deleteSQL(table, idName: idName, limit: limit), params: [id])
		return true
	}

	/// Deletes one row, with an id as a UUID
	public func delete(_ table: String, id: UUID, idName: String = "id", limit: Int = 1) -> Bool {
		self.table = table
		let _ = exec(deleteSQL(table, idName: idName, limit: limit), params: [id.string])
		return true
	}

}
