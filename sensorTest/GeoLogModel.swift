//
//  GeoLog.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/10/22.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//

import Foundation
class GeoLogModel : DBAbs {
    
    init (){
        super.init(table_name: "geo_logs", data_colums_array : ["geo_point_x" : .DoubleVal, "geo_point_y" : .DoubleVal, "status" : .IntVal, "memo" : .StringVal, "created" : .DateVal, "modified" : .DateVal])
    }
    
    /**
     * 選択
     */
    func SelectAll() -> [Dictionary<String, String>] {
        let sql: String = "select * from " + self.table_name + " order by id desc limit 20";
        var data = self.select(sql)
        var result_str: [Dictionary<String, String>] = [];
 
        for row in data {
            if let id  : Int = row["ID"]?.asInt() {
                let geo_point_x = row["geo_point_x"]?.asDouble()
                let geo_point_y = row["geo_point_y"]?.asDouble()
                let memo = row["memo"]!.asString()
                let status = row["status"]?.asInt()
                var created = row["created"]?.asString()
                if created == nil {
                    created = String(stringInterpolationSegment: row["created"]?.asDate())
                }
                
                result_str.append(["id":String(id), "geo_point_x" : String(stringInterpolationSegment: geo_point_x!), "geo_point_y" : String(stringInterpolationSegment: geo_point_y!), "status":String(stringInterpolationSegment: status!), "memo" : String(stringInterpolationSegment: memo!), "created":String(stringInterpolationSegment: created!)])
                //result.addObject(row)
            }
        }
        return result_str;
    }
    
    
    /**
     * 入力
     */
    func insert (x : String, y: String, status : String ) {
        let date_time_now = Define().getTimeNow()
        let ins_data = [date_time_now, date_time_now, y, x, status, "test"]
        self.add(ins_data)
    }
    
    
    
    /**
     * できるだけ使わない
     */
    func deleteAll () {
        if let res = SD.executeChange("DELETE FROM " + self.table_name) {
            // error hadle
        }
    }
}