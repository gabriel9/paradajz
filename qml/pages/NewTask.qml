import QtQuick 2.5
import Sailfish.Silica 1.0


Dialog {
    id: createTask

    property string taskTitle
    property string taskDescription
    canAccept: false
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id:column
            width: parent.width
            DialogHeader { }
            TextField {
                id: createTaskTitle
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: qsTr("Task title")
                text: taskTitle
                focus: true
                onTextChanged: {
                    createTask.canAccept = createTaskTitle.text.replace(/\s/g, '') !== ''
                }
            }
            TextArea {
                id: createTaskDescription
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: qsTr("Task description")
                text: taskDescription
            }
        }
    }
    onDone: {
        console.log('It is done.')
        if(result === DialogResult.Accepted) {
            taskTitle = createTaskTitle.text
            taskDescription = createTaskDescription.text
        }
    }
}





