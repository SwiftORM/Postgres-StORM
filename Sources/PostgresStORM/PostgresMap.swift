//
//  PostgresMap.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-24.
//
//

import Foundation

/// This is a reference function used to help the ORM class determine how to interpret field types from Postgres.
/// The function is not meant for use outside this library.
public func PostgresMap(_ i: Int) -> String {
	switch i {
	case 16: return "Bool"
	case 20: return "Int"
	case 21: return "Int"
	case 23: return "Int"
	case 25: return "String"
	case 114: return "json"
	//case 142: return "xml"
	case 700: return "float"
	case 701: return "float"
	case 1043: return "String"
	case 1082: return "date"
	case 1083: return "time"
	case 1114: return "timestamp"
	case 1184: return "timestampz"
	case 3802: return "jsonb"

	default: return "Invalid"
	}
}
