import QtQuick 2.5
import Sailfish.Silica 1.0
import "../DbWrapper.js" as DbWrapper

SilicaListView {
    id: doneTaskList
    width: parent.itemWidth
    height: parent.height
    clip: true

    function addNewFinished() {
        console.log('Added to finished tasks.')
    }

    Component.onCompleted: {
        DbWrapper.dbInterface.caller(function(tx) {
            var rows = tx.executeSql("SELECT rowid, task_name, task_description FROM tasks WHERE task_status == 2 ORDER BY rowid ASC").rows
            console.log(rows.length)
            for(var i = 0; i < rows.length; i++) {
                doneTasksModel.append({
                                          rowId: rows.item(i).rowid,
                                          taskTitle: rows.item(i).task_name,
                                          taskDescription: rows.item(i).task_description
                                      })
            }
        })
    }

    ListModel {
        id: doneTasksModel
    }

    model: doneTasksModel

    PullDownMenu {

        MenuItem {
            text: qsTr("Clear all.")
            onClicked: {
                console.log("Clear all finished tasks.")
            }
        }
    }

    header: PageHeader {
        title: "Done"
    }

    ViewPlaceholder {
        enabled: doneTasksModel.count === 0
        text: "No tasks."
    }

    delegate: ListItem {
        id: doneTaskItemDelegate
        menu: contextMenuComponent

        width: parent.width

        Label {
            id: taskItemTitle
            text: taskTitle
            x: Theme.paddingLarge
            width: parent.width - 2 * Theme.paddingSmall
            anchors.rightMargin: Theme.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Theme.fontSizeLarge
            truncationMode: TruncationMode.Fade
            // color: taskItemDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        }

        Component {
            id: contextMenuComponent
            ContextMenu {
                MenuItem {
                    text: qsTr('Mark as unfinished')
                    onClicked: {
                        DbWrapper.dbInterface.caller(function(tx) {
                            tx.executeSql("UPDATE tasks SET task_status = 1 WHERE rowid = ?", rowId)
                            doneTasksModel.remove(index)
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
}
