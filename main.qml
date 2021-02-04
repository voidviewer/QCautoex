import QtQuick 2.15
import QtQuick.Window 2.15

Window {
//    width: 1920
//    height: 480
    maximumWidth: 1920
    maximumHeight: 480
    minimumWidth: 1920
    minimumHeight: 480
    visible: true
    title: qsTr("QCautoex")
    Image {
        id: backgroundImage
        source: "images/background.png"
        anchors.fill: parent
    }
}
