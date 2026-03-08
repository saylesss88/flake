import QtQuick
import Quickshell

ShellRoot {
    Instantiator {
        model: Quickshell.screens

        delegate: PanelWindow {
            screen: modelData
            anchors { top: true; left: true; right: true }
            height: 32
            color: "#1e1e2e"

            Row {
                id: barRow
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 20

                Text {
                    id: logo
                    text: "❄️ NixOS"
                    color: "#cdd6f4"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: screenName
                    text: modelData.name 
                    color: "#89b4fa"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // --- THE SPACER ---
                // We use one clean calculation to push the clock to the right
                Item {
                    width: barRow.width - (logo.width + screenName.width + clock.width + (barRow.spacing * 3) + 20)
                    height: parent.height
                }

                // --- THE CLOCK ---
                Text {
                    id: clock
                    property var time: new Date()
                    text: Qt.formatDateTime(time, "hh:mm:ss")
                    color: "#a6adc8"
                    anchors.verticalCenter: parent.verticalCenter

                    // This makes the clock tick every 1000ms (1 second)
                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: clock.time = new Date()
                    }
                }
            }
        }
    }
}
