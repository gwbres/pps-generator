############################################################################
# Guillaume W. Bres, 2021               <guillaume.bressaix@gorgy-timing.fr>
# Ui to operate the 1-PPS generator
############################################################################

class MainWindow (QMainWindow):
    """
    Main Window object
    """
    def __init__ (self):
        """
        Builds MainWindow object
        """
        super().__init__()
        self.resize(500,600)
