#ifndef COMPOSITORREMOTE_H
#define COMPOSITORREMOTE_H

#include <QObject>

#include <QTcpSocket>

class CompositorRemote : public QObject
{
    Q_OBJECT
public:
    explicit CompositorRemote(QObject *parent = nullptr);

public slots:
    void reconnect(const QString& host, const quint16 port);
    void causeAlarm();

private slots:
    void socketDataReceived();

private:
    QTcpSocket* m_socket = nullptr;

signals:
    void connectFailed();
    void connectSuccessful();
    void alarmDone();
};

#endif // COMPOSITORREMOTE_H
