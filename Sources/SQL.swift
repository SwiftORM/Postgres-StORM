//
//  SQL.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import StORM
import PostgreSQL

extension PostgresStORM {

	/// Execute Raw SQL (with parameter binding)
	/// Returns PGResult (discardable)
	@discardableResult
	public func sql(_ statement: String, params: [String]) throws -> PGResult {
		do {
			return try exec(statement, params: params)
		} catch {
			self.error = StORMError.error(error.localizedDescription)
			throw error
		}
	}


}
