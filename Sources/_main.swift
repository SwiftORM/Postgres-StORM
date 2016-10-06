//
//  main.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-09-23.
//
//

//import StORM
//
//var connect = PostgresConnect(
//	host: "localhost",
//	username: "perfect",
//	password: "perfect",
//	database: "perfect_testing",
//	port: 32768
//)
//
//
//class User: PostgresStORM {
//	// NOTE: First param in class should be the ID.
//	var id				: Int = 0
//	var firstname		: String = ""
//	var lastname		: String = ""
//	var email			: String = ""
//
//
//	override open func table() -> String {
//		return "users"
//	}
//
//	override func to(_ this: StORMRow) {
//		id				= this.data["id"] as! Int
//		firstname		= this.data["firstname"] as! String
//		lastname		= this.data["lastname"] as! String
//		email			= this.data["email"] as! String
//	}
//
//	func rows() -> [User] {
//		var rows = [User]()
//		for i in 0..<self.results.rows.count {
//			let row = User()
//			row.to(self.results.rows[i])
//			rows.append(row)
//		}
//		return rows
//	}
//	override func makeRow() {
//		self.to(self.results.rows[0])
//	}
//}
//
//print("====================================================")
//
//var obj = User(connect)
////obj.connection = connect    // Use if object was instantiated without connection
//obj.firstname = "X"
//obj.lastname = "Y"
//
//try obj.save {id in obj.id = id as! Int }
//print(obj.id)
//
//
//obj.firstname = "A"
//obj.lastname = "B"
//try obj.save()
//print(obj.id)


//print("====================================================")
//print("INSERT: ")
//var obj = User()
//obj.connection = connect
//
//do {
////	obj.id = try obj.insert(cols: ["firstname","lastname","email"], params: ["Donkey", "Kong", "donkey.kong@mailinator.com"]) as! Int
////	print("New ID: \(obj.id)")
//
//	obj.firstname	= "Mister"
//	obj.lastname	= "PotatoHead"
//	obj.email		= "potato@example.com"
//	try obj.create()
//	print("New ID from create is: \(obj.id)")
//} catch {
//	print("Error detacted: \(error)")
//}
//
//
//print("====================================================")
//print("UPDATE: ")
//obj.firstname = "Mickey"
//obj.lastname = "Mouse"
//obj.email = "Mickey.Mouse@mailinator.com"
//
//do {
//	var updateResponse = try obj.update(cols: ["firstname","lastname","email"], params: [obj.firstname, obj.lastname, obj.email], idName: "id", idValue: obj.id)
//	print("UPDATE RESPONSE: \(updateResponse)")
//} catch {
//	print("Error detacted: \(error)")
//}
//
//print("====================================================")
//print("DELETE: ")
//
////do {
////	//try obj.delete(id: obj.id)
////	try obj.delete()
////} catch {
////	print("Error detacted: \(error)")
////}
//
//
//
//print("====================================================")
//print("SELECT: ")
//obj = User()
//obj.connection = connect
//
//do {
//	try obj.select(whereclause: "firstname = $1", params: ["Joe"], orderby: ["id"])
//	print("\(obj.firstname) \(obj.lastname)")
//
//} catch {
//	print("Error detacted: \(error)")
//}
//
//print("====================================================")
//print("GET (id): ")
//obj = User()
//obj.connection = connect
//
//do {
//	try obj.get(2)
//	print("\(obj.firstname) \(obj.lastname)")
//
//} catch {
//	print("Error detacted: \(error)")
//}
//
//print("====================================================")
//print("GET (): ")
//obj = User()
//obj.connection = connect
//
//do {
//	obj.id = 7
//	try obj.get()
//	print("\(obj.firstname) \(obj.lastname)")
//
//} catch {
//	print("Error detacted: \(error)")
//}

//print("====================================================")

