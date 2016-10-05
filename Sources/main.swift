//
//  main.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

import StORM

var connect = PostgresConnect(
	host: "localhost",
	username: "perfect",
	password: "perfect",
	database: "github_stats",
	port: 32768
)


class StatsTesting: PostgresStORM {

	var id				: Int = 0
	var repo			: String = ""
	var clones			: Int = 0
	var clonesunique	: Int = 0
	var visitors		: Int = 0
	var visitorsunique	: Int = 0
	var stars			: Int = 0
	var watchers		: Int = 0
	var forks			: Int = 0

	override init() {
		super.init()

		// initialize which table
		// keeps it out of the var set which will pollute introspection
		// some ORM's require tablename to be the same as classname. That's silly.
		table = "stats"
	}
/*
	// only required if StORMProtocol is defined
	
	// required by Protocol
	func to(_ this: StORMRow) {
		id				= this.data["id"] as! Int
		repo			= this.data["repo"] as! String
		clones			= this.data["clones"] as! Int
		clonesunique	= this.data["clonesunique"] as! Int
		visitors		= this.data["visitors"] as! Int
		visitorsunique	= this.data["visitorsunique"] as! Int
		stars			= this.data["stars"] as! Int
		watchers		= this.data["watchers"] as! Int
		forks			= this.data["forks"] as! Int
	}

	// required by Protocol
	func rows() -> [StatsTesting] {
		var rows = [StatsTesting]()
		for i in 0..<self.results.rows.count {
			let row = StatsTesting()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}
*/
}

var obj = StatsTesting()
obj.connection = connect

let _ = obj.select(whereclause: "stars = $1 AND repo = $2", vals: ["5", "perfect"], orderby: ["id"])

print(obj.results.cursorData)
