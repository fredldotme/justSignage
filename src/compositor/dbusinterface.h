#ifndef DBUS_INTERFACE_H
#define DBUS_INTERFACE_H

#include <QObject>

class DBusInterface : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "io.justsignage.compositor")

public:
    explicit DBusInterface(QObject* parent = nullptr);

public Q_SLOTS:
    void shuffle();
    void animate();

Q_SIGNALS:
    void shuffleTriggered();
    void animateTriggered();
};

#endif
