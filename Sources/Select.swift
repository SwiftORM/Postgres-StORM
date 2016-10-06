//
//  Select.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation
import StORM
import PostgreSQL

extension PostgresStORM {

	public func select(
		whereclause:	String,
		params:			[Any],
		orderby:		[String],
		cursor:			StORMCursor = StORMCursor(),
		joins:			[StORMDataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) throws {
		do {
			try select(columns: [], whereclause: whereclause, params: params, orderby: orderby, cursor: cursor, joins: joins, having: having, groupBy: groupBy)
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

	public func select(
		columns:		[String],
		whereclause:	String,
		params:			[Any],
		orderby:		[String],
		cursor:			StORMCursor = StORMCursor(),
		joins:			[StORMDataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) throws {

		let clauseCount = "COUNT(*) AS counter"
		var clauseSelectList = "*"
		var clauseWhere = ""
		var clauseOrder = ""

		if columns.count > 0 {
			clauseSelectList = columns.joined(separator: ",")
		} else {
			var keys = [String]()
			for i in cols() {
				keys.append(i.0)
			}
			clauseSelectList = keys.joined(separator: ",")
		}
		if whereclause.characters.count > 0 {
			clauseWhere = " WHERE \(whereclause)"
		}

		var paramsString = [String]()
		for i in 0..<params.count {
			paramsString.append(String(describing: params[i]))
		}
		if orderby.count > 0 {
			clauseOrder = " ORDER BY \(orderby.joined(separator: ", "))"
		}
		do {
			let getCount = try execRows("SELECT \(clauseCount) FROM \(table) \(clauseWhere)", params: paramsString)
			let numrecords = getCount.first?.data["counter"]! as? Int ?? 0
			results.cursorData = StORMCursor(
				limit: cursor.limit,
				offset: cursor.offset,
				totalRecords: numrecords)


			// SELECT ASSEMBLE
			var str = "SELECT \(clauseSelectList) FROM \(table) \(clauseWhere) \(clauseOrder)"


			// TODO: Add joins, having, groupby

			if cursor.limit > 0 {
				str += " LIMIT \(cursor.limit)"
			}
			if cursor.offset > 0 {
				str += " OFFSET \(cursor.offset)"
			}

			// save results into ResultSet
			results.rows = try execRows(str, params: paramsString)

			// if just one row returned, act like a "GET"
			if results.cursorData.totalRecords == 1 { makeRow() }

			//return results
		} catch {
			throw StORMError.error(error.localizedDescription)
		}
	}

}
