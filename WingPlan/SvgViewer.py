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
    mywindow.resize(425, 400)
    mywindow.setWindowTitle('SVG Viewer')

    # Create a label and display it all together
    fileLabel = QtGui.QLabel(mywindow)
    fileLabel.setGeometry(QtCore.QRect(10, 10, 80, 15))
    fileLabel.setText(svgFilename)

    #Create an SVG widget from the file contents
    svgWidget = QtSvg.QSvgWidget(svgFilename, mywindow)
   
    #Resize window based on drawing size
    svgSize = svgWidget.renderer().defaultSize()
    mywindow.resize(svgSize)

    mywindow.show()

    # Enter Qt application main loop
    sys.exit(app.exec_())
    

if __name__ == '__main__':
    arguments = docopt(__doc__, help=True, version='Svg Viewer 0.0')
    SvgViewer(arguments)

