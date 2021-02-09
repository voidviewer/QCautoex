import QtQuick 2.0

Item {
    property int buttonHeight: 24
    property int buttonSpacing: 8

    DefaultButton {
        id: startStopButton
        buttonText: "Start/Stop"
        onClicked: {
            rpmTimer.running = !rpmTimer.running
            speedTimer.running = !speedTimer.running
        }
    }
    DefaultButton {
        id: resetButton
        buttonText: "Reset"
        anchors.left: startStopButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            revMeter.needleRotation = 45
            rpmTimer.running = false
            speedoMeter.needleRotation = 45
            speedTimer.running = false
        }
    }
    DefaultButton {
        id: frameModeButton
        buttonText: "Toggle frame"
        anchors.left: resetButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            if (window.flags !== 2048) {
                window.flags = "FramelessWindowHint"
            } else {
                window.flags = 1
            }
            console.log("window.flags: " + window.flags);
        }
    }
    DefaultButton {
        id: quitButton
        buttonText: "Quit"
        anchors.left: frameModeButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            Qt.quit()
        }
    }
}
