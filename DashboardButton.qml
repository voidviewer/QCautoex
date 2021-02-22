//
// Module provides base item for dashboard buttons.
//
import QtQuick 2.0
import QtQuick.Controls 2.15

Button {
    property string buttonText: "*"

    anchors.centerIn: parent
    width: parent.width; height: parent.height

    background: Rectangle {
        id: bgRect
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8
        radius: parent.width / 2
        color: engineRunning ? "#138808" : "#b22222"
        Text {
            anchors.centerIn: parent
            //anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: parent.height / 3.75
            font.bold: true
            text: buttonText
//            transform: Scale {
//                origin.x: bgRect.width - (width * 0.16); origin.y: bgRect.height / 2; xScale: 0.5
//            }
        }
    }
}
