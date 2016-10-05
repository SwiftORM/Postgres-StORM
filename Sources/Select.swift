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
		vals:			[Any],
		orderby:		[String],
		cursor:			StORMCursor = StORMCursor(),
		joins:			[StORMDataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) -> StORMResultSet {
		return select(columns: [], whereclause: whereclause, vals: vals, orderby: orderby, cursor: cursor, joins: joins, having: having, groupBy: groupBy)
	}

	public func select(
		columns:		[String],
		whereclause:	String,
		vals:			[Any],
		orderby:		[String],
		cursor:			StORMCursor = StORMCursor(),
		joins:			[StORMDataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) -> StORMResultSet {

		let clauseCount = "COUNT(*) AS counter"
		var clauseSelectList = "*"
		var clauseWhere = ""
		var clauseOrder = ""

		if columns.count > 0 {
			clauseSelectList = columns.joined(separator: ",")
		} else {
			clauseSelectList = cols().keys.joined(separator: ",")
		}
		if whereclause.characters.count > 0 {
			clauseWhere = " WHERE \(whereclause)"
		}

		var valsString = [String]()
		for i in 0..<vals.count {
			valsString.append(String(describing: vals[i]))
		}
		if orderby.count > 0 {
			clauseOrder = " ORDER BY \(orderby.joined(separator: ", "))"
		}

		let getCount = execRows("SELECT \(clauseCount) FROM \(table) \(clauseWhere)", params: valsString)
		results.cursorData = StORMCursor(
			limit: cursor.limit,
			offset: cursor.offset,
			totalRecords: getCount.first!.data["counter"]! as! Int)


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
		results.rows = execRows(str, params: valsString)
		
		return results
	}

}
