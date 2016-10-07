//
//  PostgreStORM.swift
//  PostgresSTORM
//
//  Created by Jonathan Guthrie on 2016-10-03.
//
//

import StORM
import PostgreSQL

open class PostgresStORM: StORM, StORMProtocol {
	open var connection = PostgresConnect()


	open func table() -> String {
		return "unset"
	}

	override init() {
		super.init()
	}

	init(_ connect: PostgresConnect) {
		super.init()
		self.connection = connect
	}

	// table structure
	//open var cols = [String: String]()

	// Internal function which executes statements, with parameter binding
	// Returns raw result
	@discardableResult
	func exec(_ statement: String, params: [String]) throws -> PGResult {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		let result = connection.server.exec(statement: statement, params: params)
		// set exec message
		errorMsg = connection.server.errorMessage().trimmingCharacters(in: .whitespacesAndNewlines)
		if isError() {
			throw StORMError.error(errorMsg)
		}
		return result
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	@discardableResult
	func execRows(_ statement: String, params: [String]) throws -> [StORMRow] {
		connection.open()
		defer { connection.server.close() }
		connection.statement = statement
		let result = connection.server.exec(statement: statement, params: params)

		// set exec message
		errorMsg = connection.server.errorMessage().trimmingCharacters(in: .whitespacesAndNewlines)
		if isError() {
			throw StORMError.error(errorMsg)
		}

		let resultRows = parseRows(result)
		result.clear()
		return resultRows
	}


	func isError() -> Bool {
		if errorMsg.contains(string: "ERROR") {
			print(errorMsg)
			return true
		}
		return false
	}

	open func to(_ this: StORMRow) {
//		id				= this.data["id"] as! Int
//		firstname		= this.data["firstname"] as! String
//		lastname		= this.data["lastname"] as! String
//		email			= this.data["email"] as! String
	}

	open func makeRow() {
		self.to(self.results.rows[0])
	}

	@discardableResult
	open func save() throws {
		do {
			if keyIsEmpty() {
				try insert(asData(1))
			} else {
				let (idname, idval) = firstAsKey()
				try update(data: asData(1), idName: idname, idValue: idval)
			}
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}
	@discardableResult
	open func save(set: (_ id: Any)->Void) throws {
		do {
			if keyIsEmpty() {
				let setId = try insert(asData(1))
				set(setId)
			} else {
				let (idname, idval) = firstAsKey()
				try update(data: asData(1), idName: idname, idValue: idval)
			}
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	@discardableResult
	override open func create() throws {
		do {
			try insert(asData())
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

}


