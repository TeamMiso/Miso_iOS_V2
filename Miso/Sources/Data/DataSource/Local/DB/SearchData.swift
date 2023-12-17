import Foundation
import SQLite3


class SearchDataDB {
    static let shared = SearchDataDB()
    
    var db: OpaquePointer?
    var path = "mySqlite.sqlite"
    
    init() {
        self.db = createDB()
    }
    
    func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let dbPath = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false).appendingPathComponent(path)
            
            if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
                print("Success create db Path")
                return db
            }
        }
        catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }
    
    func createTable() {
        let query = """
        create table if not exists myDB(
            id INTEGER primary key autoincrement,
            title TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            recycleMethod TEXT NOT NULL,
            recyclablesType TEXT NOT NULL
        );
        """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Creating table has been succesfully done. db: \(String(describing: self.db))")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        } else {
            print("error: create table sqlite3 prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteTable() {
        let query = "DROP TABLE myDB"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete table success")
            } else {
                print("delete table step fail")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
    }
    
    func insertData(title: String, imageUrl: String, recycleMethod: String, recyclablesType: String) {
        let inserQuery = "insert into myDB (title, imageUrl, recycleMethod, recyclablesType) values (?,?,?,?);"
        var statement: OpaquePointer? = nil
        
        do {
            
            if sqlite3_prepare_v2(self.db, inserQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, title, -1, nil)
                sqlite3_bind_text(statement, 2, imageUrl, -1, nil)
                sqlite3_bind_text(statement, 3, recycleMethod, -1, nil)
                sqlite3_bind_text(statement, 4, recyclablesType, -1, nil)
            } 
            else {
                print("insert Data prepare fail")
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("insert data success")
            } else {
                print("insert data sqlite3 step fail")
            }
            
            sqlite3_finalize(statement)
        }
        catch {
            print("JsonEncoder Error")
        }
    }
    
    func readData() -> [SearchRecyclablesListResponse] {
        let query = "select * from myDB"
        var statement: OpaquePointer? = nil
        
        var result: [SearchRecyclablesListResponse] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let title = String(cString: sqlite3_column_text(statement, 0))
                let imageUrl = String(cString: sqlite3_column_text(statement, 1))
                let recycleMethod = String(cString: sqlite3_column_text(statement, 2))
                let recyclablesType = String(cString: sqlite3_column_text(statement, 3))
                
                result.append(SearchRecyclablesListResponse(
                    title: String(title),
                    imageUrl: String(imageUrl),
                    recycleMethod: String(recycleMethod),
                    recyclablesType: String(recyclablesType))
                )
            }
        }
        return result
    }
    
    func deleteData() {
        let query = "delete from myDB where id >= 2"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete data success")
            } else {
                print("delete data step fail")
            }
        } else {
            print("delete data prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    func updateData() {
        let query = "update myDB set id = 2 where id = 5"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("success updateData")
            } else {
                print("updataData sqlite3 step fail")
            }
        } else {
            print("updateData prepare fail")
        }
    }
}
