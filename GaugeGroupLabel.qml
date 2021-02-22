import QtQuick 2.0

Rectangle {
    property string labelLetter: ({})
    property int letterIndex: 0
    property int letterCount: 1

    width: parent.width
    height: parent.width
    y: letterIndex * (parent.height / letterCount)
    color: "transparent"
    Text {
        anchors.centerIn: parent
        height: parent.height / letterCount
        text: labelLetter
        color: "#fb4f14"
        font.pixelSize: parent.width
        font.bold: true
    }
}
