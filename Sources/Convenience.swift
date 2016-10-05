//
//  Convenience.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-04.
//
//


import PerfectLib
import StORM
import PostgreSQL

extension PostgresStORM {

	/// Deletes one row, with an id
	/// Presumes first property in class is the id.
	public func delete() {
		let (idname, idval) = firstAsKey()
		let _ = exec(deleteSQL(self.table, idName: idname, limit: 1), params: [idval as! String])
	}

	public func save() {

	}

	public func create() {
		// postgres equivalent of last insert id?
	}

	public func find() {
		
	}
}
