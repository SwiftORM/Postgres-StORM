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

	/* =============================================================================================
	Save - New
	============================================================================================= */
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

	/* =============================================================================================
	Save - Update
	============================================================================================= */
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

	/* =============================================================================================
	Get (with id)
	============================================================================================= */
	func testGetByPassingID() {
		let obj = User(connect)
		//obj.connection = connect    // Use if object was instantiated without connection
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(error as! String)
		}

		let obj2 = User(connect)

		do {
			try obj2.get(obj.id)
		} catch {
			XCTFail(error as! String)
		}
		XCTAssert(obj.id == obj2.id, "Object not the same (id)")
		XCTAssert(obj.firstname == obj2.firstname, "Object not the same (firstname)")
		XCTAssert(obj.lastname == obj2.lastname, "Object not the same (lastname)")
	}


	/* =============================================================================================
	Get (by id set)
	============================================================================================= */
	func testGetByID() {
		let obj = User(connect)
		//obj.connection = connect    // Use if object was instantiated without connection
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(error as! String)
		}

		let obj2 = User(connect)
		obj2.id = obj.id
		
		do {
			try obj2.get()
		} catch {
			XCTFail(error as! String)
		}
		XCTAssert(obj.id == obj2.id, "Object not the same (id)")
		XCTAssert(obj.firstname == obj2.firstname, "Object not the same (firstname)")
		XCTAssert(obj.lastname == obj2.lastname, "Object not the same (lastname)")
	}













	static var allTests : [(String, (PostgresSTORMTests) -> () throws -> Void)] {
		return [
			("testSaveNew", testSaveNew),
			("testSaveUpdate", testSaveUpdate),
		]
	}

}
