# Import PySide classes
import sys
from PySide import QtCore, QtGui, QtOpenGL, QtSvg

# Create a Qt application
app = QtGui.QApplication(sys.argv)

# Create a Window
mywindow = QtGui.QWidget()
mywindow.resize(425, 200)
mywindow.setWindowTitle('SVG Viewer')

#TODO: Get filename fomr UI or command line
fileName = 'clarky.dat.svg'

# Create a label and display it all together
mylabel = QtGui.QLabel(mywindow)
mylabel.setText(fileName)
mylabel.setGeometry(QtCore.QRect(10, 10, 80, 15))

mysvg_widget = QtSvg.QSvgWidget(fileName, mywindow)

mywindow.show()

# Enter Qt application main loop
sys.exit(app.exec_())