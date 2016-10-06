import XCTest
import PerfectLib
import StORM
@testable import PostgresSTORM


class User: PostgresStORM {
	// NOTE: First param in class should be the ID.
	var id				: Int = 0
	var firstname		: String = ""
	var lastname		: String = ""
	var email			: String = ""


	override open func table() -> String {
		return "users"
	}

	override func to(_ this: StORMRow) {
		id				= this.data["id"] as! Int
		firstname		= this.data["firstname"] as! String
		lastname		= this.data["lastname"] as! String
		email			= this.data["email"] as! String
	}

	func rows() -> [User] {
		var rows = [User]()
		for i in 0..<self.results.rows.count {
			let row = User()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}
	override func makeRow() {
		self.to(self.results.rows[0])
	}
}


class PostgresSTORMTests: XCTestCase {
	var connect = PostgresConnect(
		host: "localhost",
		username: "perfect",
		password: "perfect",
		database: "perfect_testing",
		port: 32768
	)
	
	override func setUp() {
		super.setUp()
	}

	func testSaveNew() {
		let obj = User(connect)
		//obj.connection = connect    // Use if object was instantiated without connection
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(error as! String)
		}
		XCTAssert(obj.id > 0, "Object not saved (new)")
	}

	func testSaveUpdate() {
		let obj = User(connect)
		//obj.connection = connect    // Use if object was instantiated without connection
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(error as! String)
		}

		obj.firstname = "A"
		obj.lastname = "B"
		do {
			try obj.save()
		} catch {
			XCTFail(error as! String)
		}
		print(obj.errorMsg)
		XCTAssert(obj.id > 0, "Object not saved (update)")
	}


	static var allTests : [(String, (PostgresSTORMTests) -> () throws -> Void)] {
		return [
			("testSaveNew", testSaveNew),
			("testSaveUpdate", testSaveUpdate),
		]
	}

}
