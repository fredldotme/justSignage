#ifndef VIDEOCTRL_H
#define VIDEOCTRL_H

#include <QObject>

class VideoCtrl : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "io.justsignage.video")

public:
    explicit VideoCtrl(QObject *parent = nullptr);

public slots:
    void nextVideo();

signals:
    void nextVideoTriggered();

};

#endif // VIDEOCTRL_H
