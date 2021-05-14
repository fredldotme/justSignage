#ifndef COMPOSITORFINDER_H
#define COMPOSITORFINDER_H

#include <QObject>

#include <QtZeroConf/qzeroconf.h>

class CompositorFinder : public QObject
{
    Q_OBJECT
public:
    explicit CompositorFinder(QObject *parent = nullptr);

private:
    void handleServiceAdded(QZeroConfService service);

    QZeroConf* m_browser = nullptr;

signals:
    void found(const QString& host, const quint16 port);
};

#endif // COMPOSITORFINDER_H
