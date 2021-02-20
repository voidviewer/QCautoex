import QtQuick 2.0

Rectangle {     // speed display
    property string speedValue: "0"

    width: parent.width / 3
    height: parent.height / 5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: window.height * 0.07
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.leftMargin: 0
    color: "transparent"
    border.width: 1
    border.color: "#484848"

    Text {          // speed value
        //text: speedValue
        text: {     // real to integer
            //~~speedValue;
            Math.round(speedValue)
        }
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
