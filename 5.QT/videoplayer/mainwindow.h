#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QWidget>
#include <QtMultimedia>
#include <QVideoWidget>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    bool            m_bReLoad;
public slots:
    void            OnSetMediaFile(void);
    void            OnSlider(qint64);
    void            OnDurationChanged(qint64);
    void            OnStateChanged(QMediaPlayer::State);

private slots:
    void on_slider_actionTriggered(int action);

private:
    QVideoWidget    *       m_pPlayerWidget;
    QMediaPlayer    *       m_pPlayer;
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
