import QtQuick 2.0
import QtQuick.Window 2.15

Window {
    title: qsTr("QCautoex - rearview mirror")
    id: mirror
    flags: "FramelessWindowHint"
    y: window.y - height
    x: window.x + (window.width / 2) - (mirror.width / 2)
    color: "black"

    Rectangle {     // window border
        id: mirrorRectangle
        width: mirror.width
        height: mirror.height
        color: "black"
        border.width: 3
        border.color: "grey"
        DefaultCamera {
            id: mirrorCamera
            anchors.centerIn: mirrorRectangle
            width: mirrorRectangle.width - 6
            height: mirrorRectangle.height - 6
        }
        Rectangle {
            anchors.centerIn: mirrorRectangle
            width: mirrorRectangle.width - 6
            height: mirrorRectangle.height - 6
            color: "black"
            opacity: window.mirrorOpacity
        }
    }
}
