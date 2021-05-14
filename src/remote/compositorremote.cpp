#include "compositorremote.h"

CompositorRemote::CompositorRemote(QObject *parent) : QObject(parent)
{
    this->m_socket = new QTcpSocket(this);
}

void CompositorRemote::reconnect(const QString& host, const quint16 port)
{
    this->m_socket->disconnectFromHost();
    this->m_socket->connectToHost(host, port);
    this->m_socket->waitForConnected(10000);

    if (this->m_socket->state() != QAbstractSocket::ConnectedState) {
        emit connectFailed();
        return;
    }

    QObject::connect(this->m_socket, &QTcpSocket::readyRead,
                     this, &CompositorRemote::socketDataReceived);

    emit connectSuccessful();
}

void CompositorRemote::socketDataReceived()
{
    const QByteArray data = this->m_socket->readAll();
    if (data.startsWith(QByteArrayLiteral("alarmDone"))) {
        emit alarmDone();
    }
}

void CompositorRemote::causeAlarm()
{
    this->m_socket->write("alarm\\n");
    this->m_socket->flush();
}
