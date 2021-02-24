//
// Module contains buttons for controlling data generation.
//
import QtQuick 2.0

Item {
    readonly property int buttonHeight: 24
    readonly property int buttonSpacing: 4

    property bool startStop: false
    onStartStopChanged: toggleEngine()
    property bool reset: false
    onResetChanged: !engineRunning ? resetEngine() : {}

//    DefaultButton {
//        id: startStopButton
//        buttonText: "Start/Stop"
//        anchors.left: parent.left
//        anchors.leftMargin: buttonSpacing
//        onClicked: {
//            toggleEngine()
//        }
//    }
    DefaultButton {
        id: resetButton
        buttonText: "Reset"
        //anchors.left: startStopButton.right
        anchors.left: parent.left
        anchors.leftMargin: buttonSpacing
        onClicked: {
            resetEngine()
            windowFrameToggle.checked = false
            windowSizeSlider.value = windowSizeSlider.from
            logModel.clear()
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
        clockTimer.running = !clockTimer.running

//        if (!engineRunning) {
//            console.log("!engineRunning")
//            rpmTimer.running = true
//            speedTimer.running = true
//            turnSignals.running = true
//            gearTimer.running = true
//            engineOilTempTimer.running = true
//            engineOilPressureTimer.running = true
//            engineWaterTempTimer.running = true
//            transOilTempTimer.running = true
//            transOilPressureTimer.running = true
//            fuelAmountTimer.running = true
//            fuelPressureTimer.running = true
//            clockTimer.running = true
//        } else {
//            console.log("engineRunning")
//            rpmTimer.running = false
//            speedTimer.running = false
//            turnSignals.running = false
//            gearTimer.running = false
//            engineOilTempTimer.running = false
//            engineOilPressureTimer.running = false
//            engineWaterTempTimer.running = false
//            transOilTempTimer.running = false
//            transOilPressureTimer.running = false
//            fuelAmountTimer.running = false
//            fuelPressureTimer.running = false
//            clockTimer.running = false
//        }
    }

    function resetEngine() {
        socket.sendTextMessage("Ar0");
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
        clockTimer.running = false
        clockGauge.gaugeValue = 0
    }
}
