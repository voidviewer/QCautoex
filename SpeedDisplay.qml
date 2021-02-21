//
// Module displays current speed inside main gauge.
//
import QtQuick 2.0

Rectangle {
    property string speed: "0"

    width: parent.width / 3
    height: parent.height / 5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: window.height * 0.07
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.leftMargin: 0
    color: "transparent"
    border.width: 1
    border.color: "#484848"

    Text {      // speed value
        text: speed
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#00cccc"
        opacity: 0.75
        font.pixelSize: {
            if ((parent.height * 0.9) > 0) {
                parent.height * 0.9
            } else {
                1
            }
        }
    }
}
