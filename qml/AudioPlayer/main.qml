import QtQuick 2.0
import QtQuick.Dialogs 1.0
import QtMultimedia 5.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0


Rectangle {
    id: root
    width: 500
    height: 350

    property var deviceTracklist
    property var folderTracklist
    property bool validTracklist: false

    MediaPlayer {
        id: audioPlayer
        property int playMinute: Math.floor(controls.sliderValue/60000)
        property int playSecond: Math.floor(((controls.sliderValue/60000 - Math.floor(controls.sliderValue/60000))*600/10))
        property int durationMinute: Math.floor(audioPlayer.duration/60000)
        property int durationSecond: Math.floor(((audioPlayer.duration/60000 - Math.floor(audioPlayer.duration/60000))*600/10))

        property string playMinuteFormatted: (playMinute.toString().length < 2) ? "0"+playMinute : playMinute
        property string playSecondFormatted: (playSecond.toString().length < 2) ? "0"+playSecond : playSecond
        property string durationMinuteFormatted: (durationMinute.toString().length < 2) ? "0"+durationMinute : durationMinute
        property string durationSecondFormatted: (durationSecond.toString().length < 2) ? "0"+durationSecond : durationSecond

        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.PlayingState) {
                controls.pauseZ = +1
                controls.playZ = -1
                timer.start()
            }
            if (playbackState === MediaPlayer.PausedState) {
                controls.pauseZ = -1
                controls.playZ = +1
            }
            if (playbackState === MediaPlayer.StoppedState) {
                controls.pauseZ = -1
                controls.playZ = +1
                timer.stop()
                controls.sliderValue = 0
            }
        }

        onStatusChanged: {
            if (audioPlayer.status === MediaPlayer.EndOfMedia) {
                console.log("End of Media")
                if ( tracklistView.trackIndex === tracklistModel.count-1) {
                    tracklistView.trackIndex = 0
                    audioPlayer.stop()
                }
                else
                    tracklistView.trackIndex += 1
            }
        }
    }

    Timer {
        id: timer
        repeat: true
        interval: 1000
        triggeredOnStart: false
        onTriggered: controls.sliderValue = audioPlayer.position
    }

    Controls {
        id: controls
        anchors.fill: parent
        sliderMaximumValue: audioPlayer.hasAudio ? audioPlayer.duration : 1.0
        durationText: root.validTracklist ? audioPlayer.playMinuteFormatted + ":" + audioPlayer.playSecondFormatted + "/" +  audioPlayer.durationMinuteFormatted + ":" + audioPlayer.durationSecondFormatted : "00:00/00:00"

        property bool loadtracklistModel: true
        signal playlistLoaded()

        onPlayClicked: {
            if (audioPlayer.hasAudio) {
                audioPlayer.play()
                audioPlayer.autoPlay = true
            }
        }
        onPauseClicked: {
            audioPlayer.pause()
        }
        onStopClicked: {
            audioPlayer.stop()
        }
        onPlaylistClicked: {
            if (loadtracklistModel) {
                audioPlayer.stop()
                tracklistModel.clear()
                if (!deviceTracklist)
                    deviceTracklist = mediaBackend.getDeviceTrackList()
                for (var i = 0; i < deviceTracklist.length; i++) {
                    tracklistModel.append({index: i, path: deviceTracklist[i], title: deviceTracklist[i].split("/").pop(-1)})
                }
                loadtracklistModel = false
                tracklistView.trackIndex = -1
                playlistLoaded()
            }
            if (tracklistView.visible === false) {
                tracklistView.visible = true
            }
        }
        onPlaylistLoaded: {
            tracklistView.trackIndex = 0
            audioPlayer.stop()
        }
        onOpenFileDialogClicked: {
            audioPlayer.stop()
            fileDialog.open()
        }
        onSliderValueChanged: {
            if (sliderPressed)
                audioPlayer.seek(sliderValue)
        }
    }


    FileDialog {
        id: fileDialog
        title: "Please choose a mp3 File"
        nameFilters: [ "Mp3 files (*.mp3)", "All files (*)" ]
        selectFolder: true
        signal newFolderLoaded()
        onAccepted: {
            controls.loadtracklistModel = true
            tracklistModel.clear()
            var urls = fileDialog.fileUrls
            folderTracklist = mediaBackend.getAlbumTracklist(urls)
            for (var i = 0; i < folderTracklist.length; i++) {
                tracklistModel.append({index: i, path: folderTracklist[i], title: folderTracklist[i].split("/").pop(-1)})
            }
            tracklistView.trackIndex = -1
            if (tracklistView.visible === false)
                tracklistView.visible = true
            newFolderLoaded()
        }
        onRejected: {
            console.log("Canceled")
        }
        onNewFolderLoaded: {
            tracklistView.trackIndex = 0
            audioPlayer.stop()
        }
    }

    ListModel {
        id: tracklistModel
    }

    TrackListView {
        id: tracklistView
        width: parent.width - controls.folderWidth - parent.width/20
        height: parent.height - controls.playHeight - controls.sliderHeight - parent.height/4
        anchors {
            top: parent.top
            topMargin: 20
            left : parent.left
            leftMargin: 20
        }

        model: tracklistModel
        spacing: 5
        visible: false
        onTrackIndexChanged: {
            if ((trackIndex >= 0) && (tracklistModel.count > 0)) {
                root.validTracklist = true
                audioPlayer.source = tracklistModel.get(trackIndex).path
            }
            else {
                root.validTracklist = false
                audioPlayer.source = ""
            }
        }
    }
}
