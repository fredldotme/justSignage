#include "compositorfinder.h"

CompositorFinder::CompositorFinder(QObject *parent) : QObject(parent)
{
    this->m_browser = new QZeroConf(this);
    QObject::connect(this->m_browser, &QZeroConf::serviceAdded,
                     this, &CompositorFinder::handleServiceAdded);
    this->m_browser->startBrowser("_justsignage._tcp");
}

void CompositorFinder::handleServiceAdded(QZeroConfService service)
{
    emit found(service->host(), service->port());
}
