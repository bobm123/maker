"""
SVG Viewer
Usage:
  SvgViewer <svgfile>
"""
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


class Window(QtGui.QWidget):
    def __init__(self):
        super(Window, self).__init__()
        self.viewer = SvgViewer(self)
        self.edit = QtGui.QLineEdit(self)
        self.edit.setReadOnly(True)
        self.button = QtGui.QToolButton(self)
        self.button.setText('...')
        self.button.clicked.connect(self.handleOpen)
        layout = QtGui.QGridLayout(self)
        layout.addWidget(self.viewer, 0, 0, 1, 2)
        layout.addWidget(self.edit, 1, 0, 1, 1)
        layout.addWidget(self.button, 1, 1, 1, 1)

    def handleOpen(self):
        path = QtGui.QFileDialog.getOpenFileName(
            self, 'Choose Image', self.edit.text())
        print(path)
        if path:
            self.edit.setText(path[0])
            self.viewer.setFilePath(path[0])


if __name__ == '__main__':
#TODO: Make this play with Qt arg system (may have to use argparse)
#    arguments = docopt(__doc__, version='Svg Viewer 0.0', options_first=True)
#    SvgViewer(arguments)

    import sys
    app = QtGui.QApplication(sys.argv)
    window = Window()
    window.setGeometry(500, 300, 822, 651)
    window.show()
    sys.exit(app.exec_())

