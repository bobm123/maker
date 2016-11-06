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
        dwg_size = self._svg.renderer().viewBox()
        swidth = self.width() / dwg_size.width()
        sheight = self.height() / dwg_size.height()
        s = max(swidth, sheight)
        self._scale = (s, s)

        self._zoom = 0
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
