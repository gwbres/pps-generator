#! /usr/bin/env python3

# Qt 
from PyQt5.QtWidgets import QApplication, QStyleFactory

import sys
sys.path.append("./widgets")

from widgets.main_window import *

if __name__ == "__main__":
	QApplication.setStyle("material")
	app = QApplication([])
	mainWindow = MainWindow()
	app.exec_()
