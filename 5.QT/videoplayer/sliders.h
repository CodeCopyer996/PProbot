#ifndef SLIDERS_H
#define SLIDERS_H

#include <QSlider>
#include <QMouseEvent>

class sliders : public QSlider
{
    Q_OBJECT
public:
    sliders(QWidget * parent = 0);
    void        setProgress(qint64);
signals:
    void        sigProgress(qint64);
private:
    bool        m_bPressed;
protected:
    void        mousePressEvent(QMouseEvent *);
    void        mouseMoveEvent(QMouseEvent *);
    void        mouseReleaseEvent(QMouseEvent *);
};


#endif // SLIDERS_H
