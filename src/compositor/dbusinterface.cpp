#include "dbusinterface.h"

DBusInterface::DBusInterface(QObject* parent) : QObject(parent)
{

}

void DBusInterface::shuffle()
{
    emit shuffleTriggered();
}

void DBusInterface::animate()
{
    emit animateTriggered();
}
