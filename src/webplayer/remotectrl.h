#ifndef REMOTECTRL_H
#define REMOTECTRL_H

#include <QObject>
#include <QtDBus/QDBusInterface>

class RemoteCtrl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString compositor MEMBER m_compositor)
public:
    explicit RemoteCtrl(QObject *parent = nullptr);

public slots:
    void connect();
    void shuffle();
    void shuffleOthers();
    void nextVideo();
    void animate();

private:
    QString m_compositor;
    QDBusInterface* m_compositorIface = nullptr;
    QDBusInterface* m_videoIface = nullptr;
};

#endif // REMOTECTRL_H
