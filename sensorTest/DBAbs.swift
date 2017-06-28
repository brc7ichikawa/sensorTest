//
//  Db.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/10/21.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//

import Foundation
import UIKit
class DBAbs {
    var table_name :String = ""
    var data_colums_array : [String: SwiftData.DataType] = ["": .StringVal]
    var data_colums_name : String = ""
    
    /**
     * 初期化処理
     */
    init (table_name : String, data_colums_array : [String: SwiftData.DataType]) {
        self.table_name = table_name
        self.data_colums_array = data_colums_array
        self.initDataClumsName()
        let (tb, err) = SD.existingTables()
        if !contains(tb, table_name) {
            if let err = SD.createTable(table_name, withColumnNamesAndTypes: self.data_colums_array) {
                //there was an error during this function, handle it here
            } else {
                //no error, the table was created successfully
            }
        }
        // println(SD.databasePath())
    }
    
    /**
     * カラム名初期化
     */
    func initDataClumsName () {
        var first_flag = false
        for (name, value) in self.data_colums_array {
            //if()
            if first_flag {
                self.data_colums_name += ","
            } else {
                first_flag = true
            }
            self.data_colums_name += name
        }
    }
    
    /**
     * 選択
     */
    func select (sql_ :String) -> [SD.SDRow] {
        
        //var result = NSMutableArray()
        let (resultSet, err) = SD.executeQuery(sql_)
        return  resultSet;
    }
    
    /**
     * clum追加
     */
    func add (data :[AnyObject]) -> Int {
        var result: Int? = nil
        if let err = SD.executeChange("INSERT INTO " + self.table_name + " (" + self.data_colums_name + ") VALUES (" + self.getHolderChar() + ")", withArgs: data) {
            //there was an error during the insert, handle it here
        } else {
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                result = 0
                //err
            }else{
                //ok
                result = Int(id)
            }
        }
        return result!;
    }
    
    func deleteOne (id : String) {
        if let err = SD.executeChange("DELETE FROM " + self.table_name + " WHERE ID =" + id) {
        }
    }
    
    /**
     * place holderの文字列分だけ取得
     */
    func getHolderChar () -> String {
        var result : String = ""
        var first_flag = false
        for (name, value) in self.data_colums_array {
            if first_flag {
               result += ","
            } else {
                first_flag = true
            }
            result += "?"
        }
        return result;
    }
}