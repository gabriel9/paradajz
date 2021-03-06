import QtQuick 2.5
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
    id: mainPage
    allowedOrientations: Orientation.Portrait

    SlideshowView {
        id: tasksSlider
        width: parent.width
        height: parent.height
        itemWidth: width
        clip: true
        currentIndex: 1

        model: VisualItemModel {            
            TodoTasks {
                id: tt
            }
            TimerPage {
                id: tp
            }
            DoneTasks {
                id: dt
            }
            Component.onCompleted: {
                tt.onTaskFinished.connect(dt.addNewFinished)
                tt.onTaskActive.connect(tp.setActiveTask)

            }

        }
    }
}
