
.pragma library
.import QtQuick.LocalStorage 2.0 as Sql



var test = (function() {
    var db = Sql.LocalStorage.openDatabaseSync("ParadajzDB", "1.0", "Paradajz DB.", 1000000)
    console.log("Init lib!")
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(rule_name TEXT, value INTEGER)")

        //TODO: If there is no values in settings populate it

    })



     var func1 = function() {
        console.log("func1!")
    }

    return {
    func1: func1
    }
})()


