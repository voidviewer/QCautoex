//
// Module contains buttons for controlling data generation.
//
import QtQuick 2.0

Item {
    property int buttonHeight: 24
    property int buttonSpacing: 4

    DefaultButton {
        id: startStopButton
        buttonText: "Start/Stop"
        anchors.left: parent.left
        anchors.leftMargin: buttonSpacing
        onClicked: {
            toggleEngine()
        }
    }
    DefaultButton {
        id: resetButton
        buttonText: "Reset"
        anchors.left: startStopButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            resetEngine()
        }
    }
    DefaultButton {
        id: quitButton
        buttonText: "Quit"
        anchors.left: resetButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            Qt.quit()
        }
    }

    function toggleEngine() {
        rpmTimer.running = !rpmTimer.running
        speedTimer.running = !speedTimer.running
        turnSignals.running = !turnSignals.running
        gearTimer.running = !gearTimer.running
        engineOilTempTimer.running = !engineOilTempTimer.running
        engineOilPressureTimer.running = !engineOilPressureTimer.running
        engineWaterTempTimer.running = !engineWaterTempTimer.running
        transOilTempTimer.running = !transOilTempTimer.running
        transOilPressureTimer.running = !transOilPressureTimer.running
        fuelAmountTimer.running = !fuelAmountTimer.running
        fuelPressureTimer.running = !fuelPressureTimer.running
    }

    function resetEngine() {
        rpmTimer.running = false
        revMeter.needleRotation = 0
        sensoryEngine.rpm = 0
        speedTimer.running = false
        speedoMeter.needleRotation = 0
        sensoryEngine.speed = 0
        turnSignals.running = false
        turnSignalsItem.resetTurnSignals()
        gearTimer.running = false
        selectedGear = 0
        gearDisplay.gear = "P"
        speedDisplay.speed = "0"
        engineOilTempTimer.running = false
        engineOilTempGauge.gaugeValue = 50
        engineOilPressureTimer.running = false
        engineOilPressureGauge.gaugeValue = 1
        engineWaterTempTimer.running = false
        engineWaterTempGauge.gaugeValue = 50
        transOilTempTimer.running = false
        transOilTempGauge.gaugeValue = 50
        transOilPressureTimer.running = false
        transOilPressureGauge.gaugeValue = 1
        fuelAmountTimer.running = false
        fuelAmountGauge.gaugeValue = 100
        fuelPressureTimer.running = false
        fuelPressureGauge.gaugeValue = 0
    }
}
