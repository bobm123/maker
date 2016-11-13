import sys
from PySide import QtCore, QtGui, QtOpenGL, QtSvg
from docopt import docopt


class SvgViewer(QtGui.QGraphicsView):
    _zoomInFactor = 1.1
    _zoomOutFactor = 1/1.1
    def __init__(self, parent):
        super(SvgViewer, self).__init__(parent)
        self._loaded = False
        self._zoom = 0
        self._svg = QtSvg.QSvgWidget()
        self._scene = QtGui.QGraphicsScene(self)
        self._scene.addWidget(self._svg)
        self.setScene(self._scene)

        self.setTransformationAnchor(QtGui.QGraphicsView.AnchorUnderMouse)
        self.setResizeAnchor(QtGui.QGraphicsView.AnchorUnderMouse)
        self.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.setDragMode(QtGui.QGraphicsView.ScrollHandDrag)

    def setFilePath(self, image_path=None):
        if image_path:
            print("Loading {}".format(image_path))
            self._svg.load(image_path)
            self.setScale()
            self._loaded = True

    def setScale(self):
        # Set initial scale factor
        viewBox = self._svg.renderer().viewBox()
        defSize = self._svg.renderer().defaultSize()
        print("Before Transform")
        print("viewBox size  {} {}".format(viewBox.width(), viewBox.height()))
        print("defaultSize() {} {}".format(defSize.width(), defSize.height()))
        print("self.size     {} {}".format(self.width(), self.height()))
        print("sceneRect {}".format(self.sceneRect()))

        # TODO: This set of scale factors at least seems to preseerve AR, but how
        # to actually scale initial view so graphics fills the window?
        swidth = (self.height() / self.width()) * defSize.width() / self.width()
        sheight = defSize.height() / self.height()
        self._scale = (swidth, sheight)
        print(self._scale)

        self._zoom = 0
        self.resetTransform()
        self.scale(*self._scale)

        viewBox = self._svg.renderer().viewBox()
        defSize = self._svg.renderer().defaultSize()
        print("After Transform")
        print("viewBox size  {} {}".format(viewBox.width(), viewBox.height()))
        print("defaultSize() {} {}".format(defSize.width(), defSize.height()))
        print("self.size     {} {}".format(self.width(), self.height()))
        print("sceneRect {}".format(self.sceneRect()))

    def wheelEvent(self, event):
        if self._loaded:
            if event.delta() > 0:
                factor = self._zoomInFactor
                self._zoom += 1
            else:
                factor = self._zoomOutFactor
                self._zoom -= 1

            if self._zoom >= 0:
                self.scale(factor, factor)
            else:
                self.resetTransform()
                self.scale(*self._scale)


class MainWindow(QtGui.QMainWindow):
    MaxRecentFiles = 9
    windowList = []

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
        fileName, filtr = QtGui.QFileDialog.getOpenFileName(self)
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
    main_window.setGeometry(500, 300, 822, 651)
    main_window.show()
    sys.exit(app.exec_())

