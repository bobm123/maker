import sys, os
from PySide import QtCore, QtGui, QtOpenGL, QtSvg
from docopt import docopt
import logging


logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')


class SvgViewer(QtGui.QGraphicsView):
    _zoomInFactor = 1.1
    _zoomOutFactor = 1/1.1

    def __init__(self, parent):
        super(SvgViewer, self).__init__(parent)
        self._loaded = False
        self._zoom = 0

        self.setTransformationAnchor(QtGui.QGraphicsView.AnchorUnderMouse)
        self.setResizeAnchor(QtGui.QGraphicsView.AnchorUnderMouse)
        self.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.setDragMode(QtGui.QGraphicsView.ScrollHandDrag)

    def setFilePath(self, image_path=None):
        if not image_path:
            return

        logging.debug('Loading {} '.format(os.path.split(image_path)[-1]))
        self._svg = QtSvg.QSvgWidget(image_path)
        self._scene = QtGui.QGraphicsScene(self)
        self._scene.addWidget(self._svg)
        self.setScene(self._scene)
        self.setScale()
        self._loaded = True

    def setScale(self):
        # Initialize scale factor index
        self._zoom = 0

        # Set the svg widget to the renderer's default size
        defSize = self._svg.renderer().defaultSize()
        self._svg.resize(defSize)

        # Scale it so the drawing fills the screen's x or y dimension
        scale = min((self.width()-18) / defSize.width(), (self.height()-18) / defSize.height())
        self._scale = (scale, scale)

        self.resetTransform()
        self.scale(*self._scale)

    def wheelEvent(self, event):
        if self._loaded:
            if event.delta() > 0:
                factor = self._zoomInFactor
                self._zoom += 1
            else:
                factor = self._zoomOutFactor
                self._zoom -= 1

            if self._zoom > 0:
                self.scale(factor, factor)
            else:
                self._zoom = 0
                self.resetTransform()
                self.scale(*self._scale)


class MainWindow(QtGui.QMainWindow):
    MaxRecentFiles = 6
    windowList = []
    _lastPath = ''

    def __init__(self):
        super(MainWindow, self).__init__()

        self.recentFileActs = []

        self.centralwidget = QtGui.QWidget()
        self.viewer = SvgViewer(self)
        layout = QtGui.QGridLayout(self.centralwidget)
        layout.addWidget(self.viewer, 0, 0, 1, 2)
        self.setCentralWidget(self.centralwidget)
        self.createActions()
        self.createMenus()

    def handleOpen(self, fileName):
        self.viewer.setFilePath(fileName)
        self.setCurrentFile(fileName)

    def open(self):
        fileName, filtr = QtGui.QFileDialog.getOpenFileName(self, dir=self._lastPath)
        if fileName:
            self.handleOpen(fileName)

    def openRecentFile(self):
        action = self.sender()
        if action:
            self.handleOpen(action.data())

    def about(self):
        QtGui.QMessageBox.about(self, "About SVG File Viewer",
                "A lightweight SVG file viewer that allows you "
                "to inspect drawings and take a closer look at "
                "sections of them with the pan and zoom tools")

    def createActions(self):
        self.openAct = QtGui.QAction("&Open...", self,
                shortcut=QtGui.QKeySequence.Open,
                statusTip="Open an svg file", triggered=self.open)

        self.aboutAct = QtGui.QAction("&About", self,
                statusTip="Show the application's About box",
                triggered=self.about)

        for i in range(MainWindow.MaxRecentFiles):
            self.recentFileActs.append(
                    QtGui.QAction(self, visible=False,
                            triggered=self.openRecentFile))

        self.exitAct = QtGui.QAction("E&xit", self, shortcut="Ctrl+Q",
                statusTip="Exit the application",
                triggered=QtGui.qApp.closeAllWindows)

    def createMenus(self):
        self.fileMenu = self.menuBar().addMenu("&File")
        self.fileMenu.addAction(self.openAct)
        self.separatorAct = self.fileMenu.addSeparator()
        for i in range(MainWindow.MaxRecentFiles):
            self.fileMenu.addAction(self.recentFileActs[i])
        self.fileMenu.addSeparator()
        self.fileMenu.addAction(self.exitAct)
        self.updateRecentFileActions()
        self.menuBar().addSeparator()
        self.helpMenu = self.menuBar().addMenu("&Help")
        self.helpMenu.addAction(self.aboutAct)

    def setCurrentFile(self, fileName):
        self.curFile = fileName
        if self.curFile:
            self.setWindowTitle("SvgViewer - {}".format(self.strippedName(self.curFile)))
        else:
            self.setWindowTitle("SvgViewer")

        settings = QtCore.QSettings('Maker', 'SvgViewer')
        files = settings.value('recentFileList', [])
        if isinstance(files, str):
            files = [files] #special case when a single file

        try:
            files.remove(fileName)
        except ValueError:
            pass

        files.insert(0, fileName)
        del files[MainWindow.MaxRecentFiles:]

        settings.setValue('recentFileList', files)

        for widget in QtGui.QApplication.topLevelWidgets():
            if isinstance(widget, MainWindow):
                widget.updateRecentFileActions()

    def updateRecentFileActions(self):
        settings = QtCore.QSettings('Maker', 'SvgViewer')
        files = settings.value('recentFileList')
        files_no = 0
        if files:
            files_no = len(files)
        numRecentFiles = min(files_no, MainWindow.MaxRecentFiles)

        for i in range(numRecentFiles):
            text = "&%d %s" % (i + 1, self.strippedName(files[i]))
            self.recentFileActs[i].setText(text)
            self.recentFileActs[i].setData(files[i])
            self.recentFileActs[i].setVisible(True)

        for j in range(numRecentFiles, MainWindow.MaxRecentFiles):
            self.recentFileActs[j].setVisible(False)

        self.separatorAct.setVisible((numRecentFiles > 0))

    def strippedName(self, fullFileName):
        return QtCore.QFileInfo(fullFileName).fileName()


if __name__ == '__main__':
    import sys
    app = QtGui.QApplication(sys.argv)
    main_window = MainWindow()
    main_window.setGeometry(500, 300, 818, 618)
    main_window.show()
    sys.exit(app.exec_())

