//
//  Insert.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import StORM
import PerfectLogger

/// Performs insert functions as an extension to the main class.
extension PostgresStORM {

	/// Insert function where the suppled data is in [(String, Any)] format.
	@discardableResult
	public func insert(_ data: [(String, Any)]) throws -> Any {

		var keys = [String]()
		var vals = [String]()
		for i in data {
			keys.append(i.0)
			vals.append(String(describing: i.1))
		}
		do {
			return try insert(cols: keys, params: vals)
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw StORMError.error("\(error)")
		}
	}

	/// Insert function where the suppled data is in [String: Any] format.
	public func insert(_ data: [String: Any]) throws -> Any {

		var keys = [String]()
		var vals = [String]()
		for i in data.keys {
			keys.append(i.lowercased())
			vals.append(data[i] as! String)
		}

		do {
			return try insert(cols: keys, params: vals)
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw StORMError.error("\(error)")
		}
	}
	

	/// Insert function where the suppled data is in matching arrays of columns and parameter values.
	public func insert(cols: [String], params: [Any]) throws -> Any {
		let (idname, _) = firstAsKey()
		do {
			return try insert(cols: cols, params: params, idcolumn: idname)
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			throw StORMError.error("\(error)")
		}
	}


	/// Insert function where the suppled data is in matching arrays of columns and parameter values, as well as specifying the name of the id column.
	public func insert(cols: [String], params: [Any], idcolumn: String) throws -> Any {

		var paramString = [String]()
		var substString = [String]()
		for i in 0..<params.count {
			paramString.append(String(describing: params[i]))
			substString.append("$\(i+1)")
		}

		//"\"" + columns.joined(separator: "\",\"") + "\""

		let colsjoined = "\"" + cols.joined(separator: "\",\"") + "\""
		let str = "INSERT INTO \(self.table()) (\(colsjoined.lowercased())) VALUES(\(substString.joined(separator: ","))) RETURNING \"\(idcolumn.lowercased())\""

		do {
			let response = try exec(str, params: paramString)
			return parseRows(response)[0].data[idcolumn.lowercased()]!
		} catch {
			LogFile.error("Error: \(error)", logFile: "./StORMlog.txt")
			self.error = StORMError.error("\(error)")
			throw error
		}

	}


}
