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
		cursor:			PerfectCRUDCursor,
		joins:			[DataSourceJoin] = [],
		having:			[String] = [],
		groupBy:		[String] = []
		) -> [Any] {

		
		var str = "SELECT \(cols.joined(separator: ",")) FROM \(table)"
		if whereclause.characters.count > 0 {
			str += " WHERE \(whereclause)"
		}
		var valsString = [String]()
		for i in 0..<vals.count {
			valsString.append(String(describing: vals[i]))
		}
		if orderby.count > 0 {
			str += " ORDER BY \(orderby.joined(separator: ", "))"
		}

		return execRows(str, params: valsString)

	}

}
