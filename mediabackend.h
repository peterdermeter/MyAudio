#ifndef MEDIABACKEND_H
#define MEDIABACKEND_H

#include <QObject>

#include <QStringList>
#include <qdebug.h>

class MediaBackend : public QObject
{
    Q_OBJECT
public:
    explicit MediaBackend(QObject *parent = 0);
    Q_INVOKABLE QStringList getDeviceTrackList();                        //erstellt eine Albumliste des devices (Pfade)
    Q_INVOKABLE QStringList getAlbumTracklist(const QString &album);
signals:

public slots:

};

#endif // MEDIABACKEND_H
