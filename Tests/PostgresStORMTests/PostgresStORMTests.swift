import XCTest
import PerfectLib
import Foundation
import StORM
@testable import PostgresStORM


class User: PostgresStORM {
	// NOTE: First param in class should be the ID.
	var id				: Int = 0
	var firstname		: String = ""
	var lastname		: String = ""
	var email			: String = ""
	var stringarray		= [String]()


	override open func table() -> String {
		return "users_test1"
	}

	override func to(_ this: StORMRow) {
		id				= this.data["id"] as? Int ?? 0
		firstname		= this.data["firstname"] as? String ?? ""
		lastname		= this.data["lastname"] as? String ?? ""
		email			= this.data["email"] as? String ?? ""
		stringarray		= toArrayString(this.data["stringarray"] as? String ?? "")
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
}


class PostgresStORMTests: XCTestCase {

	override func setUp() {
		super.setUp()
		#if os(Linux)

			PostgresConnector.host		= ProcessInfo.processInfo.environment["HOST"]!
			PostgresConnector.username	= ProcessInfo.processInfo.environment["USER"]!
			PostgresConnector.password	= ProcessInfo.processInfo.environment["PASS"]!
			PostgresConnector.database	= ProcessInfo.processInfo.environment["DB"]!
			PostgresConnector.port		= Int(ProcessInfo.processInfo.environment["PORT"]!)!

		#else
			PostgresConnector.host		= "localhost"
			PostgresConnector.username	= "perfect"
			PostgresConnector.password	= "perfect"
			PostgresConnector.database	= "perfect_testing"
			PostgresConnector.port		= 5432
		#endif
		let obj = User()
		try? obj.setup()
		StORMdebug = true
	}

	/* =============================================================================================
	Save - New
	============================================================================================= */
	func testSaveNew() {

		let obj = User()
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(String(describing: error))
		}
		XCTAssert(obj.id > 0, "Object not saved (new)")
	}

	/* =============================================================================================
	Save - Update
	============================================================================================= */
	func testSaveUpdate() {
		let obj = User()
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(String(describing: error))
		}

		obj.firstname = "A"
		obj.lastname = "B"
		do {
			try obj.save()
		} catch {
			XCTFail(String(describing: error))
		}
		print(obj.errorMsg)
		XCTAssert(obj.id > 0, "Object not saved (update)")
	}

	/* =============================================================================================
	Save - Create
	============================================================================================= */
	func testSaveCreate() {
		// first clean up!
		let deleting = User()
		do {
			deleting.id			= 10001
			try deleting.delete()
		} catch {
			XCTFail(String(describing: error))
		}

		let obj = User()

		do {
			obj.id			= 10001
			obj.firstname	= "Mister"
			obj.lastname	= "PotatoHead"
			obj.email		= "potato@example.com"
			try obj.create()
		} catch {
			XCTFail(String(describing: error))
		}
		XCTAssert(obj.id == 10001, "Object not saved (create)")
	}

	/* =============================================================================================
	Get (with id)
	============================================================================================= */
	func testGetByPassingID() {
		let obj = User()
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(String(describing: error))
		}

		let obj2 = User()

		do {
			try obj2.get(obj.id)
		} catch {
			XCTFail(String(describing: error))
		}
		XCTAssert(obj.id == obj2.id, "Object not the same (id)")
		XCTAssert(obj.firstname == obj2.firstname, "Object not the same (firstname)")
		XCTAssert(obj.lastname == obj2.lastname, "Object not the same (lastname)")
	}


	/* =============================================================================================
	Get (by id set)
	============================================================================================= */
	func testGetByID() {
		let obj = User()
		obj.firstname = "X"
		obj.lastname = "Y"

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(String(describing: error))
		}

		let obj2 = User()
		obj2.id = obj.id
		
		do {
			try obj2.get()
		} catch {
			XCTFail(String(describing: error))
		}
		XCTAssert(obj.id == obj2.id, "Object not the same (id)")
		XCTAssert(obj.firstname == obj2.firstname, "Object not the same (firstname)")
		XCTAssert(obj.lastname == obj2.lastname, "Object not the same (lastname)")
	}

	/* =============================================================================================
	Get (with id) - integer too large
	============================================================================================= */
	func testGetByPassingIDtooLarge() {
		let obj = User()

		do {
			try obj.get(874682634789)
			XCTFail("Should have failed (integer too large)")
		} catch {
			print("^ Ignore this error, that is expected and should show 'ERROR:  value \"874682634789\" is out of range for type integer'")
			// test passes - should have a failure!
		}
	}
	
	/* =============================================================================================
	Get (with id) - no record
	// test get where id does not exist (id)
	============================================================================================= */
	func testGetByPassingIDnoRecord() {
		let obj = User()

		do {
			try obj.get(1111111)
			XCTAssert(obj.results.cursorData.totalRecords == 0, "Object should have found no rows")
		} catch {
			XCTFail(error as! String)
		}
	}




	// test get where id does not exist ()
	/* =============================================================================================
	Get (preset id) - no record
	// test get where id does not exist (id)
	============================================================================================= */
	func testGetBySettingIDnoRecord() {
		let obj = User()
		obj.id = 1111111
		do {
			try obj.get()
			XCTAssert(obj.results.cursorData.totalRecords == 0, "Object should have found no rows")
		} catch {
			XCTFail(error as! String)
		}
	}


	/* =============================================================================================
	Returning DELETE statement to verify correct form
	// deleteSQL
	============================================================================================= */
	func testCheckDeleteSQL() {
		let obj = User()
		XCTAssert(obj.deleteSQL("test", idName: "testid") == "DELETE FROM test WHERE \"testid\" = $1", "DeleteSQL statement is not correct")

	}



	/* =============================================================================================
	Find
	============================================================================================= */
	func testFind() {
		// Ensure table is empty
		do {
			let obj = User()
			let tableName = obj.table()
			_ = try? obj.sql("DELETE FROM \(tableName)", params: [])
		}

		// Doing a `find` with an empty table should yield zero results
		do {
			let obj = User()
			do {
				try obj.find([("lastname", "Ashpool")])
				XCTAssertEqual(obj.results.rows.count, 0)
				XCTAssertEqual(obj.results.cursorData.totalRecords, 0)
			} catch {
				XCTFail("Find error: \(obj.error.string())")
			}
		}

		// Insert more rows than the StORMCursor().limit
		for i in 0..<200 {
			let obj = User()
			obj.firstname = "Tessier\(i)"
			obj.lastname = "Ashpool"
			do {
				try obj.save { id in obj.id = id as! Int }
			} catch {
				XCTFail(String(describing: error))
			}
		}
		for i in 0..<10 {
			let obj = User()
			obj.firstname = "Molly\(i)"
			do {
				try obj.save { id in obj.id = id as! Int }
			} catch {
				XCTFail(String(describing: error))
			}
		}

		// Doing the same `find` should now return rows
		do {
			let obj = User()
			do {
				try obj.find([("lastname", "Ashpool")])
				let cursorLimit: Int = StORMCursor().limit
				XCTAssertEqual(obj.results.rows.count, cursorLimit, "Object should have found the all the rows just inserted. Limited by the default cursor limit.")
				XCTAssertEqual(obj.results.cursorData.totalRecords, 200, "Object should have found the all the rows just inserted")
			} catch {
				XCTFail("Find error: \(obj.error.string())")
			}
		}

		// Doing the same `find` should now return rows limited by the provided cursor limit
		do {
			let obj = User()
			do {
				let cursor = StORMCursor(limit: 150, offset: 0)
				try obj.find(["lastname": "Ashpool"], cursor: cursor)
				XCTAssertEqual(obj.results.rows.count, cursor.limit, "Object should have found the all the rows just inserted. Limited by the provided cursor limit.")
				XCTAssertEqual(obj.results.cursorData.totalRecords, 200, "Object should have found the all the rows just inserted")
			} catch {
				XCTFail("Find error: \(obj.error.string())")
			}
		}
	}
	
	/* =============================================================================================
	FindAll
	============================================================================================= */
	func testFindAll() {
		// Ensure table is empty
		do {
			let obj = User()
			let tableName = obj.table()
			_ = try? obj.sql("DELETE FROM \(tableName)", params: [])
		}

		// Insert more rows than the StORMCursor().limit
		for i in 0..<200 {
			let obj = User()
			obj.firstname = "Wintermute\(i)"
			do {
				try obj.save { id in obj.id = id as! Int }
			} catch {
				XCTFail(String(describing: error))
			}
		}
		
		// Check that all the rows are returned
		do {
			let obj = User()
			do {
				try obj.findAll()
				XCTAssertEqual(obj.results.rows.count, 200, "Object should have found the all the rows just inserted. Not limited by the default cursor limit.")
				XCTAssertEqual(obj.results.cursorData.totalRecords, 200, "Object should have found the all the rows just inserted")
			} catch {
				XCTFail("findAll error: \(obj.error.string())")
			}
		}
	}
	

	/* =============================================================================================
	Test array set & retrieve
	============================================================================================= */
	func testArray() {
		let obj = User()
		obj.stringarray = ["a", "b", "zee"]

		do {
			try obj.save {id in obj.id = id as! Int }
		} catch {
			XCTFail(String(describing: error))
		}

		let obj2 = User()

		do {
			try obj2.get(obj.id)
			try obj.delete()
			try obj2.delete()
		} catch {
			XCTFail(String(describing: error))
		}
		XCTAssert(obj.id == obj2.id, "Object not the same (id)")
		XCTAssert(obj.stringarray == obj2.stringarray, "Object not the same (stringarray)")
	}
	
    /* =============================================================================================
     parseRows (JSON Aggregation)
     ============================================================================================= */
    func testJsonAggregation() {
        
        // In the parseRows function we changed to cast into either [String:Any] type, OR [[String:Any]] type as aggregated JSON type.
        
        let encodedJSONArray = "[{\"id\":\"101\",\"name\":\"Pushkar\",\"salary\":\"5000\"}, {\"id\":\"102\",\"name\":\"Rahul\",\"salary\":\"4000\"},{\"id\":\"103\",\"name\":\"tanveer\",\"salary\":\"56678\"}]"
        
        do {
            let decodedJSONArray    = try encodedJSONArray.jsonDecode()
            
            if decodedJSONArray as? [[String:Any]] == nil {
                XCTAssert(false, "Failed to cast decoded JSON to array of type [String : Any]")
            }
            
        } catch {
            XCTFail("Failed to decode array of JSON.")
        }
        
        let encodedJSON = "{\"id\":\"101\",\"name\":\"Pushkar\",\"salary\":\"5000\"}"
        
        do {
            let decodedJSON         = try encodedJSON.jsonDecode()
            
            if decodedJSON as? [String:Any] == nil {
                XCTAssert(false, "Failed to cast decoded JSON into [String:Any] type.")
            }
        } catch {
            XCTFail("Failed to decode JSON.")
        }
    
    }

	static var allTests : [(String, (PostgresStORMTests) -> () throws -> Void)] {
		return [
			("testSaveNew", testSaveNew),
			("testSaveUpdate", testSaveUpdate),
			("testSaveCreate", testSaveCreate),
			("testGetByPassingID", testGetByPassingID),
			("testGetByID", testGetByID),
			("testGetByPassingIDtooLarge", testGetByPassingIDtooLarge),
			("testGetByPassingIDnoRecord", testGetByPassingIDnoRecord),
			("testGetBySettingIDnoRecord", testGetBySettingIDnoRecord),
			("testCheckDeleteSQL", testCheckDeleteSQL),
			("testFind", testFind),
			("testFindAll", testFindAll),
			("testArray", testArray),
            ("testJsonAggregation", testJsonAggregation)
		]
	}

}
