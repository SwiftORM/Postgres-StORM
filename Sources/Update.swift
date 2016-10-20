//
//  Update.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import StORM

extension PostgresStORM {

	@discardableResult
	public func update(cols: [String], params: [Any], idName: String, idValue: Any) throws -> Bool {

		var paramsString = [String]()
		var set = [String]()
		for i in 0..<params.count {
			paramsString.append(String(describing: params[i]))
			set.append("\"\(cols[i])\" = $\(i+1)")
		}
		paramsString.append(String(describing: idValue))

		let str = "UPDATE \(self.table()) SET \(set.joined(separator: ", ")) WHERE \"\(idName)\" = $\(params.count+1)"

		do {
			try exec(str, params: paramsString)
		} catch {
			self.error = StORMError.error(error.localizedDescription)
			throw error
		}

		return true
	}

	@discardableResult
	public func update(data: [(String, Any)], idName: String = "id", idValue: Any) throws -> Bool {

		var keys = [String]()
		var vals = [String]()
		for i in 0..<data.count {
			keys.append(data[i].0)
			vals.append(String(describing: data[i].1))
		}
		do {
			return try update(cols: keys, params: vals, idName: idName, idValue: idValue)
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

}
