
.pragma library
.import QtQuick.LocalStorage 2.0 as Sql



var dbInterface = (function() {
    var db = Sql.LocalStorage.openDatabaseSync("ParadajzDB", "1.0", "Paradajz DB.", 1000000)
    console.log("Init lib!")
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(rule_name TEXT, value INTEGER)")
        //tx.executeSql("DROP TABLE IF EXISTS tasks")

        tx.executeSql("CREATE TABLE IF NOT EXISTS tasks(task_name TEXT, task_description TEXT, task_status INTEGER)")

        var settingRows = tx.executeSql("SELECT * FROM settings")
        if(settingRows.rows.length === 0) {
            tx.executeSql("INSERT INTO settings (rule_name, value) VALUES ('shortBreak', 5), ('longBreak', 10), ('taskTime', 25)")
        }
    })

     var insertNewTask = function(taskName, taskDescription) { // TODO: add return
        db.transaction(function(tx) {
            tx.executeSql("INSERT INTO tasks (task_name, task_description, task_status) VALUES(?, ?, ?)", taskName, taskDescription, 0)
        })
    }

    var updateTask = function(taskId, taskName, taskDescription, taskStatus) { // TODO: add return
        db.transaction(function(tx) {
            tx.executeSql("UPDATE tasks SET task_name = ?, task_description = ?, task_status = ? WHERE taskId = ?", taskName, taskDescription, taskStatus, taskStatus)
        })
    }

    var deleteTask = function(taskId) { // TODO: add return
        db.transaction("DELETE FROM tasks WHERE task_id = ?", taskId)
    }

    var getToDoTask = function() {

        db.readTransaction(function(tx) {
            console.log('get shit')
            return 1 // tx.executeSql("SELECT rowid, task_name, task_description FROM tasks WHERE task_status == 0 ORDER BY rowid ASC")
        })
    }

    var caller = function(func) {
        db.transaction(func)
    }


    return {
        insertNewTask: insertNewTask,
        updateTask: updateTask,
        deleteTask: deleteTask,
        getToDoTask: getToDoTask,
        caller: caller
    }
})()


