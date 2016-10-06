//
//  Convenience.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-04.
//
//


import StORM

extension PostgresStORM {

	// create is in main PostgresStORM now.

	/// Deletes one row, with an id
	/// Presumes first property in class is the id.
	public func delete() throws {
		let (idname, idval) = firstAsKey()
		do {
			try exec(deleteSQL(self.table(), idName: idname), params: [String(describing: idval)])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func get(_ id: Any) throws {
		let (idname, _) = firstAsKey()
		do {
			try select(whereclause: "\(idname) = $1", params: [String(describing: id)], orderby: [])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func get() throws {
		let (idname, idval) = firstAsKey()
		do {
			try select(whereclause: "\(idname) = $1", params: [String(describing: idval)], orderby: [])
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}


	public func find() {
		// TODO: find function...
		// shortcut to select
	}
}
