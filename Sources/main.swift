//
//  main.swift
//  PerfectCRUD
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

var connect = PostgresConnect(host: "localhost", username: "perfect", password: "perfect", database: "github_stats", port: 32768)
print("PostgresConnect.datasource: \(connect.datasource)")

//github_stats

let sel = connect.select(
	table: "stats",
	cols: [],
	whereclause: "repo = $1",
	vals: ["perfect"],
	orderby: ["id ASC"]
)

print("Statement: \(connect.statement)")

print("Found: \(sel.cursorData.totalRecords)")
print("Num records fetched: \(sel.rows.count)")

print("===========")

for i in 0..<sel.rows.count {
	print("\(sel.rows[i].data["id"]!), \(sel.rows[i].data["stars"]!)")
}

print("===========")
