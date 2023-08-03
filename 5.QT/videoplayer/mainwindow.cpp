#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    m_pPlayer = new QMediaPlayer;
        m_pPlayerWidget = new QVideoWidget;
        m_pPlayer->setVideoOutput(m_pPlayerWidget);
        ui->verticalLayout->addWidget(m_pPlayerWidget);

        m_pPlayerWidget->setAutoFillBackground(true);
        QPalette qplte;
        qplte.setColor(QPalette::Window, QColor(0,0,0));
        m_pPlayerWidget->setPalette(qplte);
        //载入
        connect(ui->loadbut, SIGNAL(clicked()), this, SLOT(OnSetMediaFile()));
        //播放
        connect(ui->playbut, SIGNAL(clicked()), m_pPlayer, SLOT(play()));
        //停止
        connect(ui->stopbut, SIGNAL(clicked()), m_pPlayer, SLOT(stop()));

        connect(m_pPlayer, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(OnStateChanged(QMediaPlayer::State)));

        ui->stopbut->setEnabled(false);
        //设置滑块行为
        m_bReLoad = true;
        ui->slider->setEnabled(false);
        connect(m_pPlayer, SIGNAL(positionChanged(qint64)), this, SLOT(OnSlider(qint64)));
        connect(m_pPlayer, SIGNAL(durationChanged(qint64)), this, SLOT(OnDurationChanged(qint64)));
        connect(ui->slider, SIGNAL(sigProgress(qint64)), m_pPlayer, SLOT(setPosition(qint64)));



}

MainWindow::~MainWindow()
{
    delete ui;
    delete m_pPlayer;
    delete m_pPlayerWidget;

}

void MainWindow::OnSetMediaFile(void)
{
    QFileDialog dialog(this);
    dialog.setFileMode(QFileDialog::AnyFile);
    QStringList fileNames;
    if (dialog.exec())
        fileNames = dialog.selectedFiles();

    if(!fileNames.empty())
    {
        m_pPlayer->setMedia(QUrl::fromLocalFile(fileNames[0]));
        m_bReLoad = true;
        ui->slider->setValue(0);
    }
}

void MainWindow::OnSlider(qint64 i64Pos)
{
    ui->slider->setProgress(i64Pos);
}

void MainWindow::OnDurationChanged(qint64 i64Duration)
{
    if(i64Duration > 0 && m_bReLoad)
    {
        ui->slider->setRange(0, i64Duration);
        m_bReLoad = false;
    }
}


void MainWindow::OnStateChanged(QMediaPlayer::State enumState)
{
    if(QMediaPlayer::StoppedState == enumState)
    {
        ui->playbut->setEnabled(true);
        ui->stopbut->setEnabled(false);
        ui->slider->setEnabled(false);
    }
    else if(QMediaPlayer::PlayingState == enumState)
    {
        ui->playbut->setEnabled(false);
        ui->stopbut->setEnabled(true);
        ui->slider->setEnabled(true);
    }
}

void MainWindow::on_slider_actionTriggered(int)
{

}
