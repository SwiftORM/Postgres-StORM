//
//  Convenience.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-10-04.
//
//


import StORM
import PerfectLogger

/// Convenience methods extending the main class.
extension PostgresStORM {

	/// Deletes one row, with an id.
	/// Presumes first property in class is the id.
	public func delete() throws {
		let (idname, idval) = firstAsKey()
		do {
			try exec(deleteSQL(self.table(), idName: idname.lowercased()), params: [String(describing: idval)])
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			self.error = StORMError.error("\(error)")
			throw error
		}
	}

	/// Deletes one row, with the id as set.
	public func delete(_ id: Any) throws {
		let (idname, _) = firstAsKey()
		do {
			try exec(deleteSQL(self.table(), idName: idname.lowercased()), params: [String(describing: id)])
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			self.error = StORMError.error("\(error)")
			throw error
		}
	}

	/// Retrieves a single row with the supplied ID.
	public func get(_ id: Any) throws {
		let (idname, _) = firstAsKey()
		do {
			try select(whereclause: "\"\(idname.lowercased())\" = $1", params: [id], orderby: [])
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw error
		}
	}

	/// Retrieves a single row with the ID as set.
	public func get() throws {
		let (idname, idval) = firstAsKey()
		do {
			try select(whereclause: "\"\(idname.lowercased())\" = $1", params: ["\(idval)"], orderby: [])
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw error
		}
	}

	/// Performs a find on mathing column name/value pairs.
	/// An optional `cursor:StORMCursor` object can be supplied to determine pagination through a larger result set.
	/// For example, `try find([("username","joe")])` will find all rows that have a username equal to "joe"
	public func find(_ data: [(String, Any)], cursor: StORMCursor = StORMCursor()) throws {
		let (idname, _) = firstAsKey()

		var paramsString = [String]()
		var set = [String]()
		for i in 0..<data.count {
			paramsString.append("\(data[i].1)")
			set.append("\(data[i].0.lowercased()) = $\(i+1)")
		}

		do {
			try select(whereclause: set.joined(separator: " AND "), params: paramsString, orderby: [idname], cursor: cursor)
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw error
		}

	}


	/// Performs a find on mathing column name/value pairs.
	/// An optional `cursor:StORMCursor` object can be supplied to determine pagination through a larger result set.
	/// For example, `try find(["username": "joe"])` will find all rows that have a username equal to "joe"
	public func find(_ data: [String: Any], cursor: StORMCursor = StORMCursor()) throws {
		let (idname, _) = firstAsKey()

		var paramsString = [String]()
		var set = [String]()
		var counter = 0
		for i in data.keys {
			paramsString.append(data[i] as! String)
			set.append("\(i.lowercased()) = $\(counter+1)")
			counter += 1
		}

		do {
			try select(whereclause: set.joined(separator: " AND "), params: paramsString, orderby: [idname], cursor: cursor)
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw error
		}

	}

}
