//
//  PostgresConnect.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

import StORM
import PostgreSQL
import PerfectLogger

open class PostgresConnect: StORMConnect {

	// server connection
	public let server = PGConnection()


	/// Init with no credentials
	override init() {
		super.init()
		self.datasource = .Postgres
	}

	/// Init with credentials
	public init(
	            host: String,
	            username: String = "",
	            password: String = "",
	            database: String = "",
	            port: Int = 0) {
		super.init()
		self.database = database
		self.datasource = .Postgres
		self.credentials = StORMDataSourceCredentials(host: host, port: port, user: username, pass: password)
	}

	// Connection String
	private func connectionString() -> String {
		let conn = "postgresql://\(credentials.username):\(credentials.password)@\(credentials.host):\(credentials.port)/\(database)"
		if StORMdebug { LogFile.info("Postgres conn: \(conn)", logFile: "./StORMlog.txt") }
		return conn
	}

	// Initiates the connection
	public func open() {
		let status = server.connectdb(self.connectionString())
		if status != .ok {
			resultCode = .error("\(status)")
			if StORMdebug { LogFile.info("Postgres conn error: \(status)", logFile: "./StORMlog.txt") }
		} else {
			if StORMdebug { LogFile.info("Postgres conn state: ok", logFile: "./StORMlog.txt") }
			resultCode = .noError
		}
	}
}


