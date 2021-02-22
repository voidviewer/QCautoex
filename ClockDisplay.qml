//
// Module displays time of day.
//
import QtQuick 2.0
import QtQml 2.0

Rectangle {
    property string gaugeValue: "0"

    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "transparent"
    border.width: appDebug ? 1 : 0
    border.color: appDebug ? "#484848" : "transparent"

    Text {  // time value
        text: {
            var hour = Math.floor(gaugeValue / 60)
            var minute = gaugeValue - (Math.floor(gaugeValue / 60)) * 60
            if (minute < 10) minute = "0" + minute
            hour + ":" + minute
        }
        anchors.right: parent.right
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
