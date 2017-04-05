import QtQuick 2.2
import Sailfish.Silica 1.0

SilicaListView {
    id: taskList
    width: parent.itemWidth
    height: parent.height
    clip: true

    ListModel {
        id: taskModel
    }

    model: taskModel

    PullDownMenu {
        MenuItem {
            text: qsTr("New Task")
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("NewTask.qml"))
                dialog.accepted.connect(function () {
                    taskModel.append({
                                         taskTitle: dialog.taskTitle,
                                         taskDescription: dialog.taskDescription,
                                         status: true
                                     })
                    findFirstActiveTask()
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
                taskModel.set(index, {
                                  taskTitle: dialog.taskTitle,
                                  taskDescription: dialog.taskDescription,
                                  status: true
                              })
                findFirstActiveTask()
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
            font.strikeout: !status
            truncationMode: TruncationMode.Fade
            color: taskItemDelegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        }
        Component {
            id: contextMenuComponent
            ContextMenu {
                MenuItem {
                    text: (status) ? qsTr('Mark as finished') : qsTr(
                                         'Mark as not finished')
                    onClicked: {
                        taskModel.setProperty(index, 'status', !status)
                        findFirstActiveTask()
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
