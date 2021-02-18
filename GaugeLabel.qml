import QtQuick 2.0

Rectangle {
    id: labelRectangle
    property int labelNumber: 0
    property int labelNumberSize: 17
    property real labelRotation: 0.0
    property real gaugeLabelCenterMultiplierX: 0.015
    property real gaugeLabelCenterMultiplierY: 0

    width: parent.width * 0.15
    height: parent.height / 2.2
    x: (parent.width / 2) - (width / 2) - (parent.width * gaugeLabelCenterMultiplierX)
    y: (parent.height / 2) - (parent.height * gaugeLabelCenterMultiplierY)
    transform: Rotation {
        id: rota0
        origin.x: width / 2;
        origin.y: 0
        angle: 45 + labelRotation
    }
    color: "transparent"
    //border.color: "grey"
    //border.width: 1

    Rectangle {
        width: labelRectangle.width
        height: labelRectangle.width
        x: labelRectangle.width - labelRectangle.width
        y: labelRectangle.height - labelRectangle.width
        color: "transparent"
        opacity: 0.7
        transform: Rotation {
            origin.x: width / 2
            origin.y: width / 2
            //angle: 45 + labelRotation
            angle: 45 - labelRotation - 90
        }
        Text {
            id: labelText
            text: qsTr(labelNumber.toString())
            font.pixelSize: labelNumberSize
            color: "#ffffff"
            x: (parent.width / 2) - (labelText.width / 2)
            y: parent.height - labelText.height
        }
    }
}
