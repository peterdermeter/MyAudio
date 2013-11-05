import QtQuick 2.0

ListView {
    id: rootView
    property int trackIndex: -1

    delegate: Component {
        id: tracklistDelegate
        Text {
            text: title
            font.family: "FontAwesome"
            font.pixelSize: 13
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log(title + " clicked")
                    console.log("Path: " + path)
                    rootView.trackIndex = index
                }
            }
        }
    }
}
