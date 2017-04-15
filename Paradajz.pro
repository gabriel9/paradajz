# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = Paradajz

CONFIG += sailfishapp

SOURCES += src/Paradajz.cpp

OTHER_FILES += qml/Paradajz.qml \
    qml/cover/CoverPage.qml \
    rpm/Paradajz.changes.in \
    rpm/Paradajz.spec \
    rpm/Paradajz.yaml \
    translations/*.ts \
    Paradajz.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/Paradajz-de.ts

RESOURCES += \
    resources.qrc

DISTFILES += \
    qml/pages/DoneTasks.qml \
    qml/pages/TimerPage.qml \
    qml/pages/TodoTasks.qml \
    qml/DbWrapper.js \
    qml/pages/NewTask.qml \
    qml/pages/MainPage.qml \
    qml/pages/About.qml
