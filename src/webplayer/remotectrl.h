#ifndef REMOTECTRL_H
#define REMOTECTRL_H

#include <QObject>
#include <QtDBus/QDBusInterface>

class RemoteCtrl : public QObject
{
    Q_OBJECT
public:
    explicit RemoteCtrl(QObject *parent = nullptr);

public slots:
    void shuffle();
    void nextVideo();

private:
    QDBusInterface* m_compositorIface = nullptr;
    QDBusInterface* m_videoIface = nullptr;
};

#endif // REMOTECTRL_H
