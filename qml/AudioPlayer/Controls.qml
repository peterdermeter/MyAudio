import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: rootControls
    signal playClicked()
    signal pauseClicked()
    signal stopClicked()
    signal playlistClicked()
    signal openFileDialogClicked()

    property alias sliderMaximumValue: slider.maximumValue
    property alias sliderValue: slider.value
    property alias sliderPressed: slider.pressed
    property alias durationText: duration.text
    property alias playZ: playButtonIcon.z
    property alias pauseZ: pauseButtonIcon.z
    property alias playWidth: playButtonIcon.width
    property alias playHeight: playButtonIcon.height
    property alias sliderWidth: slider.width
    property alias sliderHeight: slider.height
    property alias folderWidth: fileDialogIcon.width
    property alias folderHeight: fileDialogIcon.height

    Image {
        id: playButtonIcon
        source: "PlayButton.png"
        width: rootControls.width/12.5
        height: rootControls.height/8.75
        MouseArea {
            anchors.fill: parent
            onClicked: playClicked()
        }
        anchors {
            bottom: rootControls.bottom
            bottomMargin: rootControls.width/33.5
            left: rootControls.left
            leftMargin: rootControls.width/33.5
        }
    }

    Image {
        id: pauseButtonIcon
        source: "PauseButton.png"
        width: rootControls.width/12.5
        height: rootControls.height/8.75
        z: -1
        MouseArea {
            anchors.fill: parent
            onClicked: pauseClicked()
        }
        anchors {
            bottom: rootControls.bottom
            bottomMargin: rootControls.width/33.5
            left: rootControls.left
            leftMargin: rootControls.width/33.5
        }
    }

    Image {
        id: stopButtonIcon
        source: "StopButton.png"
        width: rootControls.width/12.5
        height: rootControls.height/8.75
        MouseArea {
            id: stopMouseArea
            anchors.fill: parent
            onClicked: stopClicked()
        }
        anchors {
            bottom: rootControls.bottom
            bottomMargin: rootControls.width/33.5
            left: pauseButtonIcon.right
            leftMargin: rootControls.width/33.5
        }
        states:
            State {
            name: "pressed"; when: stopMouseArea.pressed
            PropertyChanges { target: stopButtonIcon; scale: 1.2 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: playlistButtonIcon
        source: "PlaylistButton.png"
        width: rootControls.width/12.5
        height: rootControls.height/8.75
        MouseArea {
            id: playlistMouseArea
            anchors.fill: parent
            onClicked: playlistClicked()
        }
        anchors {
            bottom: rootControls.bottom
            bottomMargin: rootControls.width/33.5
            right: rootControls.right
            rightMargin: rootControls.width/33.5
        }
        states:
            State {
            name: "pressed"; when: playlistMouseArea.pressed
            PropertyChanges { target: playlistButtonIcon; scale: 1.2 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: fileDialogIcon
        source: "Folder-Music.png"
        width: rootControls.width/12.5
        height: rootControls.height/8.75
        MouseArea {
            id: openFileDialogMouseArea
            anchors.fill: parent
            propagateComposedEvents: true
            onClicked: openFileDialogClicked()
        }
        anchors {
            top: rootControls.top
            topMargin: rootControls.width/33.5
            right: rootControls.right
            rightMargin: rootControls.width/33.5
        }
        states:
            State {
            name: "pressed"; when: openFileDialogMouseArea.pressed
            PropertyChanges { target: fileDialogIcon; scale: 1.2 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    Row {
        id: sliderAndDuration
        width: slider.width + duration.width + rootControls.width/50
        anchors {
            horizontalCenter: rootControls.horizontalCenter
            bottom: playButtonIcon.top
            bottomMargin: rootControls.height/17.5
        }
        spacing: rootControls.width/50

        Slider {
            id: slider
            width: rootControls.width/1.4
            stepSize: 0
        }

        Text {
            id: duration
        }
    }
}
