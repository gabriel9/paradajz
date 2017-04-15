import QtQuick 2.5
import Sailfish.Silica 1.0
import "../DbWrapper.js" as DbWrapper

SilicaListView {
    id: taskList
    width: parent.itemWidth
    height: parent.height
    clip: true

    ListModel {
        id: taskModel
    }

    model: taskModel



    Component.onCompleted: {

        DbWrapper.dbInterface.caller(function(tx) {
            var r = tx.executeSql("SELECT rowid, task_name, task_description FROM tasks WHERE task_status == 0 ORDER BY rowid ASC")
            for(var i = 0; i < r.rows.length; i++) {
                taskModel.append({
                                     rowId: r.rows.item(i).rowid,
                                     taskTitle: r.rows.item(i).task_name,
                                     taskDescription: r.rows.item(i).task_description
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
                        DbWrapper.dbInterface.caller(function(tx) {
                            var rowId = tx.executeSql("SELECT last_insert_rowid() AS lir").rows.item(0).lir
                            taskModel.append({
                                                 rowId: rowId,
                                                 taskTitle: dialog.taskTitle,
                                                 taskDescription: dialog.taskDescription
                                             })
                        })

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
        width: parent.width - 2 * Theme.paddingLarge
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
            font.pixelSize: Theme.fontSizeLarge
            truncationMode: TruncationMode.Fade
            color: taskItemDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        }
        Component {
            id: contextMenuComponent
            ContextMenu {
                MenuItem {
                    text: qsTr('Mark as finished')
                    onClicked: {
                        console.log("Update database")
                    }
                }
                MenuItem {
                    text: "Remove"
                    onClicked: remove()
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
