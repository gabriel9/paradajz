import QtQuick 2.5
import Sailfish.Silica 1.0
Page {
    id: aboutPage

    allowedOrientations: Orientation.Portrait | Orientation.Landscape

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: aboutPage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "About"
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: appIcon
                    source: "qrc:/image/harbour-paradajz.png"
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    text: "Paradajz"
                    color: Theme.primaryColor
                }
            }
            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                horizontalAlignment: Text.Center
                wrapMode: Text.WordWrap
                text: qsTr("Pomodoro client for Sailfish OS.")
            }
            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                horizontalAlignment: Text.Center
                text: qsTr('<a href="http://en.wikipedia.org/wiki/Pomodoro_Technique">Wiki article</a>')
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    color: Theme.secondaryColor
                    text: qsTr("Bojan <gabriel9> Kostic")
                }
            }
        }
    }
}





