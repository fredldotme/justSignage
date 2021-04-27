#include "screenwindow.h"

#include <QGuiApplication>
#include <QDebug>

ScreenWindow::ScreenWindow(QQuickWindow *parent)
    : QQuickWindow(parent)
{
    if (qGuiApp->platformName() != QLatin1String("mirserver")) {
        qCritical("Not using 'mirserver' QPA plugin. Using ScreenWindow may produce unknown results.");
    }
}

ScreenWindow::~ScreenWindow()
{
}

qtmir::Screen *ScreenWindow::screenWrapper() const
{
    return m_screen.data();
}

void ScreenWindow::setScreenWrapper(qtmir::Screen *screen)
{
    if (m_screen != screen) {
        m_screen = screen;
        Q_EMIT screenWrapperChanged();
    }
    QQuickWindow::setScreen(screen->qscreen());
    if (!isActive()) requestActivate();
}
