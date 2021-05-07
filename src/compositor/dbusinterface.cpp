#include "dbusinterface.h"

DBusInterface::DBusInterface(QObject* parent) : QObject(parent)
{

}

void DBusInterface::shuffle()
{
    Q_EMIT shuffleTriggered();
}

void DBusInterface::animate()
{
    Q_EMIT animateTriggered();
}
