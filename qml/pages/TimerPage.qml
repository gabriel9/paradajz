import QtQuick 2.5
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../DbWrapper.js" as DbWrapper
SilicaFlickable {
    id: mainPage

    width: parent.itemWidth
    height: parent.height

    property int value: 0
    property bool running: false
    property int stateString: 1 // 1 - work runing; 2 - small break; 3 - long break
    property string taskText: "No task"
    property int jobMinutes: 25
    property int smallBreakMinutes: 5
    property int longBreakMinutes: 10
    property int remainingTimeSecconds: 60 * (stateString == 1 ? jobMinutes : stateString == 2 ? smallBreakMinutes : longBreakMinutes)

    Component.onCompleted: {
        // DbWrapper.test.func1()
            //var db = LocalStorage.openDatabaseSync("ParadajzDB", "1.0", "Paradajz DB.", 1000000)
            //db.transaction(function(tx) {
                //tx.executeSql("DROP TABLE IF EXISTS settings")
                //tx.executeSql("CREATE TABLE IF NOT EXISTS settings(rule_name TEXT, value INTEGER)")
                //tx.executeSql("INSERT INTO settings (rule_name, value) VALUES ('shortBreak', 5), ('longBreak', 10), ('taskTime', 25)")



                // var setResutls = tx.executeSql("SELECT * FROM settings")
                // var taskResults = tx.executeSql("SELECT * FROM tasks")

//                var shortBreakRow = tx.executeSql("SELECT value FROM settings WHERE rule_name = 'shortBreak'")
//                var longBreakRow = tx.executeSql("SELECT value FROM settings WHERE rule_name = 'longBreak'")
//                var taskTimeRow = tx.executeSql("SELECT value FROM settings WHERE rule_name = 'taskTime'")

//                var resetSettings = function() {
//                    tx.executeSql("CREATE TABLE IF NOT EXISTS settings(rule_name TEXT, value INTEGER)")
//                    tx.executeSql("CREATE TABLE IF NOT EXISTS tasks(task_name TEXT, task_description TEXT, task_status INTEGER)")
//                }

//                if(shortBreakRow.rows.length !== 0) {
//                    mainPage.smallBreakMinutes = shortBreakRow.rows.item(0).value
//                }

//                if(longBreakRow.rows.length !== 0) {
//                    mainPage.longBreakMinutes = longBreakRow.rows.item(0).value
//                }

//                if(taskTimeRow.rows.length !== 0) {
//                    mainPage.jobMinutes = taskTimeRow.rows.item(0).value
//                }

                // console.log(tx.executeSql("SELECT value FROM settings WHERE rule_name = 'shortBreak'").rows.item(0).value)

                // for(var i = 0; i < setResutls.rows.length; i++) {
                //     console.log(setResutls.rows.item(i).rule_name + " " + setResutls.rows.item(i).value)
                // }
                // for(var i = 0; i < taskResults.rows.length; i++) {
                //     console.log(taskResults.rows.item(i))
                // }

            //})
        }

    Timer {
        id: timer
        running: mainPage.running
        interval: 1000
        repeat: true
        onTriggered: {
            mainPage.remainingTimeSecconds = mainPage.remainingTimeSecconds - 1
        }
    }

    PullDownMenu {
        MenuItem {
            text: qsTr('About')
            onClicked: {
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }
        MenuItem {
            text: qsTr("Settings")
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("Settings.qml"), {
                                                taskTime: mainPage.jobMinutes,
                                                shortBreak: mainPage.smallBreakMinutes,
                                                longBreak: mainPage.longBreakMinutes
                                            })
                dialog.accepted.connect(function() {


//                    if(mainPage.jobMinutes !== dialog.taskTime) {
//                        console.log("changed task time")
//                        mainPage.jobMinutes = dialog.taskTime

//                    }

//                    if(mainPage.smallBreakMinutes !== dialog.shortBreak) {
//                        console.log("changed short break time")
//                    }

//                    if(mainPage.longBreakMinutes !== dialog.longBreak) {
//                        console.log("changed long break time")
//                    }

                    // page.gTaskTimeMinute = dialog.taskTime
                    // page.shortBreak = dialog.shortBreak
                    // page.longBreak = dialog.longBreak
                });
            }
        }
    }

    contentHeight: column.height

    Column {
        id: column

        width: mainPage.width
        spacing: Theme.paddingLarge
        PageHeader {
            id: headerState
            title: qsTr((stateString == 1 ? "Work Time" : stateString == 2 ? "Small break" : "Long break"))
        }
        Label {
            id: timerMinutes
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr((parseInt(remainingTimeSecconds / 60, 10).toString() < 10 ?  '0' : '') + parseInt(remainingTimeSecconds / 60, 10).toString())
            font.pixelSize: 350
            color: Theme.highlightColor
            font.bold: true
        }
        Label {
            id: timerSecconds
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr((parseInt(remainingTimeSecconds % 60, 10).toString() < 10 ? '0' : '') + parseInt(remainingTimeSecconds % 60, 10).toString())
            font.pixelSize: 350
            color: Theme.highlightColor
        }
        Label {
            id: labelTask
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr(mainPage.taskText)
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.secondaryColor
        }
    }
    PushUpMenu {
        MenuItem {
            text: mainPage.running ? qsTr("Stop") : qsTr("Start")
            onClicked: {
                mainPage.running = !mainPage.running

            }
        }
        MenuItem {
            text: qsTr("Reset")
            onClicked: {
                mainPage.running = false
                mainPage.remainingTimeSecconds = 60 * mainPage.jobMinutes
            }
        }
    }
}
