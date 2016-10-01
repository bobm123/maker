"""
Profile Plot
Usage:
  SvgViewer.py <svgfile>
"""
import sys
from PySide import QtCore, QtGui, QtOpenGL, QtSvg
from docopt import docopt


def SvgViewer(argv):
    svgFilename = arguments['<svgfile>']

    # Create a Qt application
    app = QtGui.QApplication('')

    # Create a Window
    mywindow = QtGui.QWidget()
    mywindow.resize(425, 200)
    mywindow.setWindowTitle('SVG Viewer')

    # Create a label and display it all together
    mylabel = QtGui.QLabel(mywindow)
    mylabel.setGeometry(QtCore.QRect(10, 10, 80, 15))
    mylabel.setText(svgFilename)

    mysvg_widget = QtSvg.QSvgWidget(svgFilename, mywindow)
    print(mysvg_widget.size())
    print(mysvg_widget.widthMM(), mysvg_widget.heightMM())

    spos = QtCore.QPoint(10,10)
    ssize= QtCore.QSize(mysvg_widget.size())

    mywindow.show()

    # Enter Qt application main loop
    sys.exit(app.exec_())

    
if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Svg Viewer 0.0')
    SvgViewer(arguments)
    
