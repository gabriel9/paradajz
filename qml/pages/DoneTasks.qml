import QtQuick 2.5
import Sailfish.Silica 1.0

SilicaListView {
    id: doneTaskList
    width: parent.itemWidth
    height: parent.height
    clip: true

    ListModel {
        id: doneTasksModel
    }

    model: doneTasksModel

    PullDownMenu {

        MenuItem {
            text: qsTr("Clear all")
            onClicked: {
                console.log("Clear task list")
            }
        }
    }

    PageHeader {
        title: "Done"
    }

    ViewPlaceholder {
        enabled: doneTasksModel.count === 0
        text: "No tasks."
    }
}
