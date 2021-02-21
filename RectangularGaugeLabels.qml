//
// Module writes labels for rectangular gauges.
//
import QtQuick 2.0

Rectangle {
    id: labelRectangle
    property int labelNumber: 0
    property int labelNumberSize: 6
    property int labelIndex: 0
    property int labelCount: 5
    width: parent.width * 0.9
    height: parent.height * 0.25
    anchors.verticalCenter: parent.verticalCenter
    x: (labelIndex * (width / labelCount)) + (width * 0.08)
    color: "transparent"

    Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        transform: Scale { xScale: 0.85 }
        text: qsTr(labelNumber.toString())
        font.pixelSize: labelNumberSize
        color: "#ffffff"
        // font opacity adjusted according to its size for compensating brightness
        // labels appear on different gauges
        opacity: 1 - (labelNumberSize / 200)
    }
}
