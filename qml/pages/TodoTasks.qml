import QtQuick 2.5
import Sailfish.Silica 1.0
import "../DbWrapper.js" as DbWrapper

SilicaListView {
    id: taskList
    width: parent.itemWidth
    height: parent.height
    clip: true

    signal taskFinished()
    signal taskActive(string taskTitle)


    ListModel {
        id: taskModel
    }

    model: taskModel

    Component.onCompleted: {

        DbWrapper.dbInterface.caller(function(tx) {
            //tx.executeSql("UPDATE tasks SET task_status = 0")
            var r = tx.executeSql("SELECT rowid, task_name, task_description, task_status FROM tasks WHERE task_status == 0  OR task_status = 1 ORDER BY rowid ASC")
            for(var i = 0; i < r.rows.length; i++) {
                console.log(r.rows.item(i).task_status)
                taskModel.append({
                                     rowId: r.rows.item(i).rowid,
                                     taskTitle: r.rows.item(i).task_name,
                                     taskDescription: r.rows.item(i).task_description,
                                     taskStatus: r.rows.item(i).task_status
                                 })
            }
        })
    }

    PullDownMenu {
        MenuItem {
            text: qsTr("New Task")
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("NewTask.qml"))
                dialog.accepted.connect(function () {
                    console.log(dialog.taskTitle)
                    console.log(dialog.taskDescription)
                    DbWrapper.dbInterface.caller(function(tx) {
                        tx.executeSql("INSERT INTO tasks (task_name, task_description, task_status) VALUES(?, ?, ?)", [dialog.taskTitle, dialog.taskDescription, 0])
                        //DbWrapper.dbInterface.caller(function(tx) {
                            var rowId = tx.executeSql("SELECT last_insert_rowid() AS lir").rows.item(0).lir
                            taskModel.append({
                                                 rowId: rowId,
                                                 taskTitle: dialog.taskTitle,
                                                 taskDescription: dialog.taskDescription
                                             })
                        //})

                    })

                })
            }
        }
    }

    header: PageHeader {
        title: qsTr("Todo")
    }

    ViewPlaceholder {
        enabled: taskModel.count === 0
        text: "No tasks."
    }

    delegate: ListItem {
        id: taskItemDelegate
        menu: contextMenuComponent
        width: parent.width
        onClicked: {
            DbWrapper.dbInterface.caller(function(tx) {
                tx.executeSql("UPDATE tasks SET task_status = 0 WHERE task_status = ?", 1)
                tx.executeSql("UPDATE tasks SET task_status = 1 WHERE rowid = ?", rowId)
                taskModel.set(index, {"taskStatus": 1})
                taskActive(taskTitle)
            })
        }

        function remove() {
            remorseAction("Deleting", function () {
                taskModel.remove(index)
            })
        }

        ListView.onRemove: animateRemoval()

        Label {
            id: taskItemTitle
            text: taskTitle
            x: Theme.paddingLarge
            width: parent.width - 2 * Theme.paddingSmall
            anchors.rightMargin: Theme.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            //onClicked: {console.log(1)}
            font.pixelSize: Theme.fontSizeLarge
            truncationMode: TruncationMode.Fade
            color: (taskStatus === 1) ? Theme.highlightColor : Theme.primaryColor
            //onPressAndHold: taskItemDelegate.showMenu()
        }
        Component {
            id: contextMenuComponent
            ContextMenu {
                MenuItem {
                    text: qsTr('Mark as finished')
                    onClicked: {
                        DbWrapper.dbInterface.caller(function(tx) {
                            tx.executeSql("UPDATE tasks SET task_status = 3 WHERE rowid = ?", rowId)
                            taskModel.remove(index)
                        })
                        taskFinished()
                    }
                }
                MenuItem {
                    text: "Edit"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("NewTask.qml"), {
                                                        taskTitle: taskTitle,
                                                        taskDescription: taskDescription
                                                    })
                        dialog.accepted.connect(function () {
                            DbWrapper.dbInterface.caller(function(tx) {
                                tx.executeSql("UPDATE tasks SET task_name = ?, task_description = ? WHERE rowid = ?", [dialog.taskTitle, dialog.taskDescription, rowId])
                            })
                            taskModel.set(index, {
                                              taskTitle: dialog.taskTitle,
                                              taskDescription: dialog.taskDescription,
                                          })
                        })
                    }
                }

                MenuItem {
                    text: "Remove"
                    onClicked: {
                        DbWrapper.dbInterface.caller(function(tx) {

                        })
                    }
                }
            }
        }
    }

    VerticalScrollDecorator {
    }

    //    function findFirstActiveTask() {
    //        for (var i = 0; i < taskModel.count; i++) {
    //            if (taskModel.get(i).status) {
    //                appWindow.titleTask = taskModel.get(i).taskTitle
    //                break
    //            }
    //        }
    //    }
}
