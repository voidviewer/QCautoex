//
// Module displays current gear inside main gauge.
//
import QtQuick 2.0

Rectangle {     // gear display
    property string gear: "P"

    width: parent.width / 7
    height: parent.height / 5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: window.height * 0.07
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.leftMargin: 0
    color: "transparent"
    border.width: appDebug ? 1 : 0
    border.color: appDebug ? "#484848" : "transparent"

    Text {      // gear value
        text: gear
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
