#include "mediabackend.h"
#include <QDirIterator>
#include <qdebug.h>


MediaBackend::MediaBackend(QObject *parent) :
    QObject(parent) {}


QStringList MediaBackend::getDeviceTrackList()                       //you get the paths of the mp3 tracks on the device
{
    QStringList trackList;
    QString musicDir = QDir::homePath();
    QString sdCard = "/accounts/1000/removable/sdcard/";
#if defined(Q_OS_MAC)
    musicDir.append("/Music/Music");
    qDebug() << "Running on Mac";
#elif defined(Q_OS_QNX)
    musicDir = "/accounts/1000/shared";
    sdCard = "/accounts/1000/removable/sdcard/";
    qDebug() << "Running on QNX ";
#elif defined(Q_OS_WIN32)
    qDebug() << "Running on Windows";
    qDebug() << musicDir;
#endif
    if (QDir(musicDir).exists())
        trackList = getAlbumTracklist(musicDir);
    if (QDir(sdCard).exists())
        trackList << getAlbumTracklist(sdCard);

    return trackList;
}


QStringList MediaBackend::getAlbumTracklist(const QString &album)
{
    QString Dir(album);
    Dir.remove("file://");
    Dir.remove("/C:");
    if (Dir.isEmpty()) return QStringList();

    QStringList songs;
    QDirIterator it(Dir, QDir::Dirs | QDir::NoDotAndDotDot | QDir::NoSymLinks,
                    QDirIterator::Subdirectories);

    QStringList audioFilesAlbum = QDir(Dir).entryList(QStringList() << "*.mp3");
    for (int i = 0; i < audioFilesAlbum.size(); i++)
    {
        audioFilesAlbum[i] = Dir + "/" + audioFilesAlbum[i];
    }
    if (!audioFilesAlbum.isEmpty())
        songs << audioFilesAlbum;

    while (it.hasNext()) {
        QString subDir = it.next();
        QStringList audioFilesSubAlbum = QDir(subDir).entryList(QStringList() << "*.mp3");
        for (int i = 0; i < audioFilesSubAlbum.size(); i++)
        {
            audioFilesSubAlbum[i] = subDir + "/" + audioFilesSubAlbum[i];
        }
        if (!audioFilesSubAlbum.isEmpty())
            songs << audioFilesSubAlbum;
    }
    return songs;
}

