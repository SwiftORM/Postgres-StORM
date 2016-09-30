//
//  Select.swift
//  PerfectPostgresCRUD
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation
import PerfectCRUD
import PostgreSQL

extension PostgresConnect {

	public func select(
		table:			String,
		cols:			[String],
		whereclause:	String,
		vals:			[Any],
		orderby:		[String],
		cursor:			PerfectCRUDCursor = PerfectCRUDCursor(),
		joins:			[DataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) -> PerfectResultSet {
		self.table = table

		let clauseCount = "COUNT(*) AS counter"
		var clauseSelectList = "*"
		var clauseWhere = ""
		var clauseOrder = ""

		if cols.count > 0 {
			clauseSelectList = cols.joined(separator: ",")
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
		rows.cursorData = PerfectCRUDCursor(
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

		rows.rows = execRows(str, params: valsString)
		
		return rows
	}

}
