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

	public func create() {
		// postgres equivalent of last insert id? ->>>> RETURNING.
		
	}

	/// Deletes one row, with an id
	/// Presumes first property in class is the id.
	public func delete() throws {
		let (idname, idval) = firstAsKey()
		do {
			try exec(deleteSQL(self.table, idName: idname), params: [String(describing: idval)])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func get(_ id: Any) throws {
		let (idname, _) = firstAsKey() // ignore idval...
		do {
			try select(whereclause: "\(idname) = ", params: [id as! String], orderby: [])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func get() throws {
		let (idname, idval) = firstAsKey()
		do {
			try select(whereclause: "\(idname) = ", params: [idval as! String], orderby: [])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func save() {

	}

	public func find() {
		
	}
}
